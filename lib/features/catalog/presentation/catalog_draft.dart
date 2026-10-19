import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../core/api/api_error.dart';
import '../data/catalog_models.dart';
import '../data/catalog_repository.dart';
import '../form/catalog_form_engine.dart';

enum DraftSave { idle, dirty, saving, saved, conflict, failed }

/// Form state for one record: values, dirty keys, draft save (POST once,
/// then PATCH with `If-Match`), autosave, 409 handling and the publish gate.
class CatalogDraft extends ChangeNotifier {
  CatalogDraft({
    required this.repo,
    required this.type,
    required this.schema,
    CatalogItem? item,
    this.autosave = false,
    this.autosaveDelay = const Duration(milliseconds: 1200),
  }) : _item = item {
    if (item != null) _values = _fromItem(item);
  }

  final CatalogRepository repo;
  final String type;
  final CatalogTypeSchema schema;
  final bool autosave;
  final Duration autosaveDelay;

  CatalogItem? _item;
  Map<String, Object?> _values = {};
  final Set<String> _dirty = {};
  DraftSave _save = DraftSave.idle;
  Object? _error;
  List<String> _serverMissing = const [];
  Timer? _timer;
  Future<bool>? _inFlight;

  CatalogItem? get item => _item;
  Map<String, Object?> get values => _values;
  DraftSave get saveState => _save;
  Object? get error => _error;
  bool get isNew => _item == null || _item!.id.isEmpty;
  bool get hasChanges => _dirty.isNotEmpty;
  Set<String> get dirtyKeys => {..._dirty};

  /// Missing required fields: the client gate, plus whatever the last 422
  /// listed that is still empty.
  List<String> get missing {
    final local = schema.missing(_values);
    final extra = _serverMissing.where((k) => !local.contains(k) && !(schema.field(k)?.isFilled(_values[k]) ?? false));
    return [...local, ...extra];
  }

  bool get complete => missing.isEmpty;
  double get completeness => schema.completeness(_values);

  Map<String, Object?> _fromItem(CatalogItem item) {
    final v = <String, Object?>{};
    for (final f in schema.fields) {
      final raw = item.valueOf(f.key);
      v[f.key] = switch (f.kind) {
        FieldKind.i18nText || FieldKind.i18nTextarea => I18n.from(raw),
        _ => raw,
      };
    }
    // Envelope basics even when the schema puts them elsewhere.
    v.putIfAbsent('title', () => item.title);
    if (item.images.isNotEmpty) v.putIfAbsent('images', () => item.images);
    v[supplierNameKey] = item.supplierName;
    return v;
  }

  void set(String key, Object? value) {
    _values = {..._values, key: value};
    if (!key.startsWith('_')) _dirty.add(key);
    if (_save != DraftSave.conflict) _save = DraftSave.dirty;
    notifyListeners();
    if (autosave && !isNew) {
      _timer?.cancel();
      _timer = Timer(autosaveDelay, save);
    }
  }

  Map<String, Object?> _pick(Iterable<String> keys) => {for (final k in keys) k: _values[k]};

  /// Saves the draft: POST (all values) the first time, PATCH (dirty keys)
  /// after. Returns false on failure; a 409 moves to [DraftSave.conflict].
  Future<bool> save() {
    _timer?.cancel();
    if (_inFlight != null) return _inFlight!.then((_) => _dirty.isEmpty ? true : save()) as Future<bool>;
    return _inFlight = _doSave().whenComplete(() => _inFlight = null);
  }

  Future<bool> _doSave() async {
    if (_save == DraftSave.conflict) return false;
    if (!isNew && _dirty.isEmpty) {
      _save = DraftSave.saved;
      notifyListeners();
      return true;
    }
    final sending = {..._dirty};
    _save = DraftSave.saving;
    _error = null;
    notifyListeners();
    try {
      if (isNew) {
        _item = await repo.create(type, CatalogValues.body(_values));
      } else {
        final next = await repo.patch(type, _item!.id, CatalogValues.body(_pick(sending)), ifMatch: _item!.updatedAtRaw);
        _item = next.id.isEmpty ? _item!.merge(next.json) : next;
      }
      _dirty.removeAll(sending);
      _save = _dirty.isEmpty ? DraftSave.saved : DraftSave.dirty;
      notifyListeners();
      if (_dirty.isNotEmpty && autosave) _timer = Timer(autosaveDelay, save);
      return true;
    } catch (e) {
      _error = e;
      _save = isConflict(e) ? DraftSave.conflict : DraftSave.failed;
      notifyListeners();
      return false;
    }
  }

  /// After a 409: [keepMine] re-reads the record for its fresh `updatedAt`
  /// and re-sends the local edits; otherwise local edits are dropped.
  Future<bool> resolveConflict({required bool keepMine}) async {
    if (_item == null) return false;
    final fresh = (await repo.get(type, _item!.id)).item;
    _item = fresh;
    _save = DraftSave.dirty;
    if (keepMine) {
      notifyListeners();
      return save();
    }
    _dirty.clear();
    _values = _fromItem(fresh);
    _save = DraftSave.saved;
    notifyListeners();
    return true;
  }

  /// Saves, then publishes (staff) / submits for review (supplier). A 422
  /// stores the server's missing list. Returns the record or null.
  Future<CatalogItem?> publish() async {
    if (!complete) return null;
    if (!await save()) return null;
    try {
      final next = await repo.publish(type, _item!.id);
      _item = next.id.isEmpty ? _item!.merge(next.json) : next;
      _serverMissing = const [];
      notifyListeners();
      return _item;
    } catch (e) {
      _error = e;
      if (isIncomplete(e)) _serverMissing = missingFromError(e);
      notifyListeners();
      if (e is ApiError && !isIncomplete(e)) rethrow;
      return null;
    }
  }

  void replaceItem(CatalogItem next) {
    _item = next;
    notifyListeners();
  }

  bool _disposed = false;

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _disposed = true;
    super.dispose();
  }
}

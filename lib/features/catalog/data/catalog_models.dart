import '../../../core/api/api_client.dart';
import '../../../core/api/models/json_record.dart';

/// `{ en, ar }` pair. Accepts a bare string (treated as English).
class I18n {
  const I18n({this.en = '', this.ar = ''});

  factory I18n.from(Object? v) {
    if (v is Map) return I18n(en: '${v['en'] ?? ''}', ar: '${v['ar'] ?? ''}');
    if (v is String) return I18n(en: v);
    return const I18n();
  }

  final String en;
  final String ar;

  bool get isEmpty => en.trim().isEmpty && ar.trim().isEmpty;
  bool get complete => en.trim().isNotEmpty && ar.trim().isNotEmpty;

  /// The localized value, falling back to the other language.
  String of(bool arabic) {
    final a = ar.trim(), e = en.trim();
    return arabic ? (a.isNotEmpty ? a : e) : (e.isNotEmpty ? e : a);
  }

  I18n copyWith({String? en, String? ar}) => I18n(en: en ?? this.en, ar: ar ?? this.ar);

  Map<String, String> toJson() => {'en': en, 'ar': ar};

  @override
  bool operator ==(Object other) => other is I18n && other.en == en && other.ar == ar;

  @override
  int get hashCode => Object.hash(en, ar);
}

/// Record lifecycle. `review` is what a supplier "publish" turns into.
abstract final class CatalogStatus {
  static const draft = 'draft';
  static const review = 'review';
  static const published = 'published';
  static const hidden = 'hidden';
  static const archived = 'archived';

  static const filters = [draft, review, published, hidden, archived];
}

/// Uniform record envelope (contract § Uniform record envelope).
class CatalogItem extends JsonRecord {
  const CatalogItem(super.json);

  String get type => s('type');
  String get status => s('status', CatalogStatus.draft);
  String? get supplierId => so('supplierId');
  String? get supplierName => so('supplierName');
  I18n get title => I18n.from(json['title']);
  I18n get summary => I18n.from(json['summary']);
  String? get coverImage => so('coverImage') ?? (images.isEmpty ? null : images.first);
  List<String> get images => [
        for (final v in (json['images'] is List ? json['images'] as List : const []))
          if (v != null && '$v'.isNotEmpty) '$v',
      ];
  num? get priceFromEGP => n('priceFromEGP');
  Json get fields => m('fields');

  /// The raw `updatedAt` string, sent back verbatim as `If-Match`.
  String? get updatedAtRaw => so('updatedAt');
  DateTime? get updatedAt => d('updatedAt');
  String? get updatedBy => so('updatedBy');
  double get completeness => (n('completeness') ?? 0).toDouble().clamp(0.0, 1.0);

  bool get isPublished => status == CatalogStatus.published;
  bool get isArchived => status == CatalogStatus.archived;

  /// Value for a schema field key: envelope-level keys first, then `fields`.
  Object? valueOf(String key) {
    if (CatalogValues.topLevel.contains(key)) return json[key];
    return fields.containsKey(key) ? fields[key] : json[key];
  }

  /// Form values keyed as in the schema.
  Map<String, Object?> values(Iterable<CatalogField> schemaFields) => {
        for (final f in schemaFields) f.key: valueOf(f.key),
      };

  CatalogItem merge(Json patch) => CatalogItem({...json, ...patch});

  /// Client-side marks set by the repository from the write envelope.
  static const queuedKey = r'$queuedForApproval';
  static const approvalKey = r'$approvalId';

  /// The write that returned this record was queued for staff approval
  /// (202); for a queued price change the record is unchanged.
  bool get queuedForApproval => json[queuedKey] == true;
  String? get approvalId => so(approvalKey);
}

/// One row of `GET {base}/summary`.
class CatalogTypeSummary {
  const CatalogTypeSummary({
    this.total = 0,
    this.draft = 0,
    this.published = 0,
    this.hidden = 0,
    this.archived = 0,
    this.review = 0,
  });

  factory CatalogTypeSummary.fromJson(Json j) {
    int n(String k) => (j[k] is num) ? (j[k] as num).toInt() : 0;
    return CatalogTypeSummary(
      total: n('total'),
      draft: n('draft'),
      published: n('published'),
      hidden: n('hidden'),
      archived: n('archived'),
      review: n('review'),
    );
  }

  /// Excludes archived records.
  final int total;
  final int draft;
  final int published;
  final int hidden;
  final int archived;
  final int review;
}

/// Splits form values into the write body (`{ title, summary, images,
/// supplierId, fields }`).
abstract final class CatalogValues {
  static const topLevel = {'title', 'summary', 'images', 'supplierId', 'status'};

  static Json body(Map<String, Object?> values) {
    final top = <String, dynamic>{};
    final fields = <String, dynamic>{};
    values.forEach((k, v) {
      if (k.startsWith('_')) return;
      final w = v is I18n ? v.toJson() : v;
      if (topLevel.contains(k)) {
        top[k] = w;
      } else {
        fields[k] = w;
      }
    });
    return {...top, if (fields.isNotEmpty) 'fields': fields};
  }
}

class CatalogOption {
  const CatalogOption(this.value, this.label);

  factory CatalogOption.from(Object? v) {
    if (v is Map) return CatalogOption('${v['value'] ?? ''}', I18n.from(v['label'] ?? v['value']));
    return CatalogOption('$v', I18n(en: '$v'));
  }

  final String value;
  final I18n label;
}

/// Form field kinds (contract § Schema endpoint).
enum FieldKind {
  text,
  i18nText,
  i18nTextarea,
  number,
  money,
  boolean,
  select,
  multiselect,
  tags,
  time,
  timeList,
  duration,
  geo,
  gallery,
  supplier,
  dayPlan,
  json;

  static FieldKind parse(String? v) => FieldKind.values.firstWhere((k) => k.name == v, orElse: () => FieldKind.text);
}

class CatalogField {
  const CatalogField({
    required this.key,
    required this.kind,
    this.label = const I18n(),
    this.required = false,
    this.min,
    this.max,
    this.options = const [],
    this.suggestions = const [],
    this.help,
  });

  factory CatalogField.fromJson(Json j) => CatalogField(
        key: '${j['key'] ?? ''}',
        kind: FieldKind.parse(j['kind'] as String?),
        label: I18n.from(j['label']),
        required: j['required'] == true,
        min: j['min'] as num?,
        max: j['max'] as num?,
        options: [for (final o in (j['options'] is List ? j['options'] as List : const [])) CatalogOption.from(o)],
        suggestions: [for (final o in (j['suggestions'] is List ? j['suggestions'] as List : const [])) '$o'],
        help: j['help'] == null ? null : I18n.from(j['help']),
      );

  final String key;
  final FieldKind kind;
  final I18n label;
  final bool required;
  final num? min;
  final num? max;
  final List<CatalogOption> options;
  final List<String> suggestions;
  final I18n? help;

  /// Label in [arabic], falling back to a humanized key.
  String labelOf(bool arabic) {
    final v = label.of(arabic);
    if (v.isNotEmpty) return v;
    final spaced = key.replaceAllMapped(RegExp('([a-z])([A-Z])'), (m) => '${m[1]} ${m[2]}').replaceAll('_', ' ');
    return spaced.isEmpty ? key : spaced[0].toUpperCase() + spaced.substring(1);
  }

  /// Whether [v] counts as filled for completeness.
  bool isFilled(Object? v) {
    switch (kind) {
      case FieldKind.i18nText:
      case FieldKind.i18nTextarea:
        final i = v is I18n ? v : I18n.from(v);
        return i.complete;
      case FieldKind.gallery:
        final n = v is List ? v.length : 0;
        return n >= (min ?? 1).toInt();
      case FieldKind.boolean:
        return v is bool;
      case FieldKind.geo:
        return v is Map && v['lat'] is num && v['lng'] is num;
      default:
        if (v == null) return false;
        if (v is String) return v.trim().isNotEmpty;
        if (v is List) return v.isNotEmpty;
        if (v is Map) return v.isNotEmpty;
        return true;
    }
  }
}

class CatalogSection {
  const CatalogSection({required this.key, this.label = const I18n(), this.fields = const []});

  factory CatalogSection.fromJson(Json j) => CatalogSection(
        key: '${j['key'] ?? ''}',
        label: I18n.from(j['label']),
        fields: [for (final f in listOfMaps(j['fields'])) CatalogField.fromJson(f)],
      );

  final String key;
  final I18n label;
  final List<CatalogField> fields;

  String labelOf(bool arabic) {
    final v = label.of(arabic);
    return v.isNotEmpty ? v : (key.isEmpty ? '' : key[0].toUpperCase() + key.substring(1));
  }
}

/// A child collection: `rooms` (records), `rates` (rateCalendar), `slots`,
/// `menu`, `orders`.
class CatalogChildSpec {
  const CatalogChildSpec({required this.key, this.label = const I18n(), this.kind, this.itemType});

  factory CatalogChildSpec.fromJson(Json j) => CatalogChildSpec(
        key: '${j['key'] ?? ''}',
        label: I18n.from(j['label']),
        kind: j['kind'] as String?,
        itemType: j['itemType'] as String?,
      );

  final String key;
  final I18n label;
  final String? kind;
  final String? itemType;

  bool get isRateCalendar => kind == 'rateCalendar' || key == 'rates';
  bool get isSlots => kind == 'slots' || key == 'slots';
  bool get isMenu => kind == 'menu' || key == 'menu';
  bool get isOrders => kind == 'orders' || key == 'orders';
}

class CatalogTypeSchema {
  const CatalogTypeSchema({
    required this.type,
    this.label = const I18n(),
    this.icon,
    this.sections = const [],
    this.children = const [],
    this.listColumns = const [],
    this.filters = const [],
  });

  factory CatalogTypeSchema.fromJson(Json j) => CatalogTypeSchema(
        type: '${j['type'] ?? ''}',
        label: I18n.from(j['label']),
        icon: j['icon'] as String?,
        sections: [for (final s in listOfMaps(j['sections'])) CatalogSection.fromJson(s)],
        children: [for (final c in listOfMaps(j['children'])) CatalogChildSpec.fromJson(c)],
        listColumns: [for (final c in (j['listColumns'] is List ? j['listColumns'] as List : const [])) '$c'],
        filters: [for (final c in (j['filters'] is List ? j['filters'] as List : const [])) '$c'],
      );

  final String type;
  final I18n label;
  final String? icon;
  final List<CatalogSection> sections;
  final List<CatalogChildSpec> children;
  final List<String> listColumns;
  final List<String> filters;

  Iterable<CatalogField> get fields => sections.expand((s) => s.fields);

  CatalogField? field(String key) => fields.where((f) => f.key == key).firstOrNull;

  String labelOf(bool arabic) {
    final v = label.of(arabic);
    return v.isNotEmpty ? v : type;
  }

  /// Required field keys still empty in [values] (the publish gate).
  List<String> missing(Map<String, Object?> values) => [
        for (final f in fields)
          if ((f.required || (f.kind == FieldKind.gallery && (f.min ?? 0) > 0)) && !f.isFilled(values[f.key])) f.key,
      ];

  /// Client estimate of `completeness` (required fields + photos).
  double completeness(Map<String, Object?> values) {
    final req = [
      for (final f in fields)
        if (f.required || f.kind == FieldKind.gallery) f,
    ];
    if (req.isEmpty) return 1;
    return req.where((f) => f.isFilled(values[f.key])).length / req.length;
  }
}

/// `{ item, children: { [key]: Envelope[] } }`.
class CatalogDetail {
  const CatalogDetail(this.item, this.children);

  factory CatalogDetail.fromJson(Json j) {
    final item = j['item'] is Map ? (j['item'] as Map).cast<String, dynamic>() : j;
    final kids = j['children'] is Map ? (j['children'] as Map).cast<String, dynamic>() : const <String, dynamic>{};
    return CatalogDetail(CatalogItem(item), {
      for (final e in kids.entries) e.key: [for (final m in listOfMaps(e.value)) CatalogItem(m)],
    });
  }

  final CatalogItem item;
  final Map<String, List<CatalogItem>> children;
}

/// One hotel night (`{date, roomId, nightlyEGP, closed}`).
class RateNight {
  const RateNight({required this.date, this.roomId, this.nightlyEGP, this.closed = false});

  factory RateNight.fromJson(Json j) => RateNight(
        date: DateTime.tryParse('${j['date']}') ?? DateTime(1970),
        roomId: j['roomId'] as String?,
        nightlyEGP: j['nightlyEGP'] is num ? j['nightlyEGP'] as num : num.tryParse('${j['nightlyEGP']}'),
        closed: j['closed'] == true,
      );

  final DateTime date;
  final String? roomId;
  final num? nightlyEGP;
  final bool closed;
}

/// One activity slot (`{date|startsAt, time, capacity, booked, closed}`).
class SlotRow {
  const SlotRow({required this.date, this.time = '', this.capacity = 0, this.booked = 0, this.closed = false, this.id});

  factory SlotRow.fromJson(Json j) {
    final starts = DateTime.tryParse('${j['startsAt'] ?? j['startAt'] ?? ''}');
    final date = DateTime.tryParse('${j['date'] ?? ''}') ?? starts ?? DateTime(1970);
    String time = '${j['time'] ?? ''}';
    if (time.isEmpty && starts != null) {
      time = '${starts.hour.toString().padLeft(2, '0')}:${starts.minute.toString().padLeft(2, '0')}';
    }
    int toInt(Object? v) => v is num ? v.toInt() : int.tryParse('$v') ?? 0;
    return SlotRow(
      id: j['id'] as String?,
      date: DateTime(date.year, date.month, date.day),
      time: time,
      capacity: toInt(j['capacity']),
      booked: toInt(j['booked'] ?? j['reserved']),
      closed: j['closed'] == true || j['status'] == 'closed',
    );
  }

  final String? id;
  final DateTime date;
  final String time;
  final int capacity;
  final int booked;
  final bool closed;
}

/// `yyyy-MM-dd`.
String isoDate(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// Catalogue permission family per type (`catalog.<family>.<verb>`).
String catalogFamily(String type) => switch (type) {
      'activity' => 'activities',
      'package' => 'packages',
      'hotel' || 'hotel-room' => 'hotels',
      'restaurant' => 'restaurants',
      _ when type.startsWith('transfer') => 'transfers',
      _ => '${type}s',
    };

String catalogPerm(String type, String verb) => 'catalog.${catalogFamily(type)}.$verb';

/// Every `catalog.*.view` key (More group gate).
const catalogViewPermissions = [
  'catalog.activities.view',
  'catalog.packages.view',
  'catalog.transfers.view',
  'catalog.hotels.view',
  'catalog.restaurants.view',
];

const supplierCatalogPermission = 'supplier.catalog.manage';

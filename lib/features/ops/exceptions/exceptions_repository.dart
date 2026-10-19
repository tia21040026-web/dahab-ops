import 'package:injectable/injectable.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/models/json_record.dart';
import '../../../core/api/models/paged.dart';

enum ExceptionSource { alert, support, review, gap }

/// One exception, normalised from its source (contract has no single
/// endpoint; the web `ExceptionsCenter` merges the same four).
class OpsException extends JsonRecord {
  const OpsException(super.json, this.source);

  final ExceptionSource source;

  String get title => switch (source) {
        ExceptionSource.alert => first(const ['titleEn', 'titleAr', 'alertType']),
        ExceptionSource.support => first(const ['travelerName', 'category'], 'Support'),
        ExceptionSource.review => first(const ['summaryEn', 'issueType']),
        ExceptionSource.gap => first(const ['category', 'description']),
      };

  String titleFor(bool arabic) => arabic && source == ExceptionSource.alert
      ? first(const ['titleAr', 'titleEn'])
      : title;

  String messageFor(bool arabic) => switch (source) {
        ExceptionSource.alert =>
          arabic ? first(const ['messageAr', 'messageEn']) : first(const ['messageEn', 'messageAr']),
        ExceptionSource.support => s('message'),
        ExceptionSource.review =>
          arabic ? first(const ['summaryAr', 'summaryEn']) : first(const ['summaryEn', 'issueType']),
        ExceptionSource.gap => s('description'),
      };

  String get severity => switch (source) {
        ExceptionSource.support => b('urgent') ? 'CRITICAL' : 'MEDIUM',
        _ => s('severity', 'MEDIUM').toUpperCase(),
      };

  int get rank => switch (severity) { 'CRITICAL' => 0, 'HIGH' => 1, 'MEDIUM' => 2, _ => 3 };

  DateTime? get at => d('createdAt') ?? d('detectedAt');
  bool get acknowledged => b('acknowledged');
  bool get canAcknowledge => source == ExceptionSource.alert && !acknowledged;
}

@lazySingleton
class ExceptionsRepository {
  ExceptionsRepository(this._api);

  final ApiClient _api;

  Future<List<OpsException>> _safe(Future<List<OpsException>> Function() f) =>
      f().catchError((Object _) => <OpsException>[]);

  /// All four sources; one failing source never blanks the screen.
  Future<Paged<OpsException>> all(ListQuery q) async {
    final parts = await Future.wait([
      _safe(() async => [
            for (final m in listOfMaps((await _api.get('/api/market/alerts'))['alerts']))
              OpsException(m, ExceptionSource.alert),
          ]),
      _safe(() async => [
            for (final m in listOfMaps((await _api.get('/api/support/messages'))['messages']))
              if ('${m['status']}' == 'OPEN' || '${m['status']}' == 'ESCALATED')
                OpsException(m, ExceptionSource.support),
          ]),
      _safe(() async => [
            for (final m in listOfMaps((await _api.get('/api/market/review-queue'))['items']))
              if ('${m['status']}' == 'PENDING_REVIEW') OpsException(m, ExceptionSource.review),
          ]),
      _safe(() async => [
            for (final m in listOfMaps((await _api.get('/api/dahab/admin/gaps'))['gaps']))
              OpsException(m, ExceptionSource.gap),
          ]),
    ]);
    final source = q.filters['source'];
    final items = parts.expand((p) => p).where((e) => source == null || e.source.name == source).toList()
      ..sort((a, b) {
        final r = a.rank.compareTo(b.rank);
        if (r != 0) return r;
        return (b.at ?? DateTime(0)).compareTo(a.at ?? DateTime(0));
      });
    return Paged(items: items, total: items.length);
  }

  Future<void> acknowledge(String alertId, String by) =>
      _api.post('/api/market/alerts/$alertId/acknowledge', body: {'acknowledgedBy': by});
}

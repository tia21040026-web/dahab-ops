import 'package:injectable/injectable.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/models/json_record.dart';
import '../../../core/api/models/paged.dart';

class JobPolicy extends JsonRecord {
  const JobPolicy(super.json);

  String get sourceId => s('sourceId', id);
  String get source => first(const ['sourceReference', 'sourceId']);
  String get type => s('sourceType');
  String get interval => s('scheduleInterval');
  String get mode => s('ingestionMode');
  bool get enabled => b('enabled', true);
  int get failures => i('consecutiveFailures');
  DateTime? get lastRun => d('lastCompletedRun') ?? d('lastScheduledRun');
  DateTime? get nextRun => d('nextScheduledRun');
}

class HealthReading extends JsonRecord {
  const HealthReading(super.json);

  String get status => s('status', 'unknown');
  String get readiness => s('commercialReadiness');
  Map<String, dynamic> get database => m('database');
  Map<String, dynamic> get ledger => m('ledger');
  bool get paymentsSimulated => b('paymentsSimulated');
  bool get aiConfigured => b('aiConfigured');
  String get aiModel => s('aiModel');
  bool get aiQuotaExhausted => m('aiQuota')['exhausted'] == true;
  bool get pushConfigured => b('firebaseAdminConfigured');
}

class IntegrationFreshness extends JsonRecord {
  const IntegrationFreshness(super.json);

  String get name => s('name');
  String get purpose => s('purpose');
  String get status => s('status');
  String get freshness => s('freshness');
  DateTime? get lastSuccess => d('lastSuccess');
  DateTime? get lastFailure => d('lastFailure');
}

/// Jobs (`/api/market/jobs`, `/api/jobs/status`) and system health
/// (`/api/health`, `/api/operations/integrations`).
@lazySingleton
class SystemRepository {
  SystemRepository(this._api);

  final ApiClient _api;

  Future<Paged<JobPolicy>> jobs(ListQuery q) async =>
      pagedFrom(await _api.get('/api/market/jobs'), const ['policies', 'jobs'], JobPolicy.new);

  Future<int> activeJobs() async {
    final json = await _api.get('/api/jobs/status');
    return (json['activeJobsCount'] as num?)?.toInt() ?? 0;
  }

  Future<void> runJob(String sourceId) => _api.post('/api/market/jobs/trigger', body: {'sourceId': sourceId});

  Future<HealthReading> health() async => HealthReading(await _api.get('/api/health'));

  Future<List<IntegrationFreshness>> integrations() async => [
        for (final m in listOfMaps((await _api.get('/api/operations/integrations'))['integrations']))
          IntegrationFreshness(m),
      ];
}

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../core/api/api_client.dart';
import '../../../core/storage/key_value_store.dart';

/// `GET /api/operations/overview` summary block.
class OverviewSummary {
  const OverviewSummary({
    this.activeTrips = 0,
    this.pendingBookings = 0,
    this.pendingSupplierConfirmations = 0,
    this.paymentIssues = 0,
    this.atRiskTrips = 0,
  });

  final int activeTrips;
  final int pendingBookings;
  final int pendingSupplierConfirmations;
  final int paymentIssues;
  final int atRiskTrips;

  factory OverviewSummary.fromJson(Map<String, dynamic> json) {
    int v(Object? x) => x is num ? x.toInt() : 0;
    return OverviewSummary(
      activeTrips: v(json['activeTrips']),
      pendingBookings: v(json['pendingBookings']),
      pendingSupplierConfirmations: v(json['pendingSupplierConfirmations']),
      paymentIssues: v(json['paymentIssues']),
      atRiskTrips: v(json['atRiskTrips']),
    );
  }

  Map<String, int> toCounts() => {
        'activeTrips': activeTrips,
        'pendingBookings': pendingBookings,
        'pendingSupplierConfirmations': pendingSupplierConfirmations,
        'paymentIssues': paymentIssues,
        'atRiskTrips': atRiskTrips,
      };
}

/// One Pulse KPI: a live value plus, once history exists, a delta against
/// the previous snapshot and a sparkline of recent snapshots.
class KpiReading {
  const KpiReading({
    required this.key,
    required this.value,
    this.delta,
    this.deltaCount,
    this.spark = const [],
    this.upIsGood = true,
    this.critical = false,
    this.warning = false,
  });

  final String key;
  final int value;

  /// Relative change vs the previous snapshot (0.12 = +12%). Null until two
  /// snapshots exist — never invented.
  final double? delta;

  /// Absolute change vs the previous snapshot; null with [delta].
  final int? deltaCount;
  final List<double> spark;
  final bool upIsGood;
  final bool critical;
  final bool warning;
}

/// Everything Pulse renders, assembled from the overview, notifications,
/// transfers and integrations endpoints — no mocks.
class PulseData {
  const PulseData({
    required this.summary,
    required this.kpis,
    required this.systemStatus,
    required this.systemDetail,
    required this.unreadNotifications,
    required this.fetchedAt,
    this.subsystems = const {},
  });

  final OverviewSummary summary;
  final List<KpiReading> kpis;
  final String systemStatus;
  final String systemDetail;
  final int unreadNotifications;
  final DateTime fetchedAt;

  /// `api` / `database` / `payments` / `ai` → `ok`, `warn`, `down` or
  /// `unknown`, from `/api/health` and `/api/operations/integrations`.
  final Map<String, String> subsystems;
}

/// `GET /api/operations/*` for the Pulse screen.
@lazySingleton
class OverviewRepository {
  OverviewRepository(this._api, this._store);

  final ApiClient _api;
  final KeyValueStore _store;

  static const _historyKey = 'pulse.history.v1';
  static const _historyCap = 8;

  String? _etag;

  Future<PulseData> load() async {
    final now = DateTime.now();
    final overview = await _getOverview();
    final summary = OverviewSummary.fromJson(
      (overview['summary'] as Map?)?.cast<String, dynamic>() ?? const {},
    );

    var unread = 0;
    var supportTotal = 0;
    try {
      final n = await _api.get('/api/operations/notifications');
      final s = (n['summary'] as Map?)?.cast<String, dynamic>() ?? const {};
      unread = (s['unread'] as num?)?.toInt() ?? 0;
      supportTotal = (s['total'] as num?)?.toInt() ?? 0;
    } catch (_) {
      // Notifications are additive context; Pulse works without them.
    }

    var activeTransfers = 0;
    try {
      final t = await _api.get('/api/operations/transfers');
      final list = (t['transfers'] as List?) ?? const [];
      activeTransfers = list.length;
    } catch (_) {
      // Same: additive.
    }

    var systemStatus = 'healthy';
    var systemDetail = '';
    final subsystems = <String, String>{
      'api': _lastOverview != null ? 'ok' : 'unknown',
      'database': 'unknown',
      'payments': 'unknown',
      'ai': 'unknown',
    };
    try {
      final g = await _api.get('/api/operations/integrations');
      final items = ((g['integrations'] as List?) ?? const []).whereType<Map>().toList();
      final bad = items.where((e) => '${e['status']}'.toLowerCase() != 'healthy').toList();
      if (bad.isNotEmpty) {
        systemStatus = 'degraded';
        systemDetail = bad.map((e) => '${e['name']} ${e['status']}').join(' · ');
      }
      String? worst(bool Function(String name) match) {
        final hits = items.where((e) => match('${e['name']} ${e['purpose'] ?? ''}'.toLowerCase())).toList();
        if (hits.isEmpty) return null;
        final st = hits.map((e) => '${e['status']}'.toLowerCase()).toList();
        if (st.any((x) => x == 'down' || x == 'failing' || x == 'error')) return 'down';
        if (st.any((x) => x != 'healthy')) return 'warn';
        return 'ok';
      }
      subsystems['payments'] = worst((n) => n.contains('pay')) ?? subsystems['payments']!;
      subsystems['ai'] = worst((n) => RegExp(r'\b(ai|openai|gemini|llm)\b').hasMatch(n)) ??
          subsystems['ai']!;
    } catch (_) {
      // Unknown health is not an error state on its own.
    }
    try {
      final h = await _api.get('/api/health');
      final db = (h['database'] as Map?)?.cast<String, dynamic>();
      if (db != null) {
        final st = '${db['status'] ?? (db['connected'] == false ? 'down' : 'ok')}'.toLowerCase();
        subsystems['database'] =
            (st == 'ok' || st == 'healthy' || st == 'connected' || st == 'up') ? 'ok' : (st == 'down' ? 'down' : 'warn');
      }
      if (subsystems['ai'] == 'unknown' && h['aiConfigured'] is bool) {
        final quota = (h['aiQuota'] as Map?)?['exhausted'] == true;
        subsystems['ai'] = h['aiConfigured'] == true ? (quota ? 'warn' : 'ok') : 'unknown';
      }
      if (subsystems['payments'] == 'unknown' && h['paymentsSimulated'] is bool) {
        subsystems['payments'] = h['paymentsSimulated'] == true ? 'warn' : 'ok';
      }
      if ('${h['status']}'.toLowerCase() == 'ok' || '${h['status']}'.toLowerCase() == 'healthy') {
        subsystems['api'] = 'ok';
      }
    } catch (_) {
      // Health is additive context.
    }

    final counts = {
      'activeTrips': summary.activeTrips,
      'pendingBookings': summary.pendingBookings,
      'supplierConfirmations': summary.pendingSupplierConfirmations,
      'supportQueue': supportTotal,
      'exceptions': summary.atRiskTrips,
      'paymentIssues': summary.paymentIssues,
      'activeTransfers': activeTransfers,
      'unread': unread,
    };
    final history = await _pushHistory(counts);
    final kpis = _kpis(counts, history);

    return PulseData(
      summary: summary,
      kpis: kpis,
      systemStatus: systemStatus,
      systemDetail: systemDetail,
      unreadNotifications: unread,
      fetchedAt: now,
      subsystems: subsystems,
    );
  }

  Future<Map<String, dynamic>> _getOverview() async {
    try {
      final res = await _api.getRaw('/api/operations/overview',
          options: _etag == null ? null : Options(headers: {'If-None-Match': _etag}));
      if (res.statusCode == 304) {
        // Nothing changed; the cached snapshot below is still current.
        return _lastOverview ?? const {};
      }
      final etag = res.headers.value('etag');
      if (etag != null && etag.isNotEmpty) _etag = etag;
      final data = res.data;
      if (data is Map) {
        _lastOverview = data.cast<String, dynamic>();
        return _lastOverview!;
      }
      return const {};
    } catch (_) {
      return _lastOverview ?? const {};
    }
  }

  Map<String, dynamic>? _lastOverview;

  /// Ring of recent `{at, counts}` snapshots persisted on device, so deltas
  /// and sparklines are computed from real past readings.
  Future<List<_Snapshot>> _pushHistory(Map<String, int> counts) async {
    final raw = await _store.read(_historyKey);
    final list = <_Snapshot>[];
    if (raw != null && raw.isNotEmpty) {
      try {
        for (final e in (jsonDecode(raw) as List)) {
          list.add(_Snapshot.fromJson((e as Map).cast<String, dynamic>()));
        }
      } catch (_) {
        // Corrupt history starts over.
      }
    }
    list.add(_Snapshot(at: DateTime.now(), counts: counts));
    while (list.length > _historyCap) {
      list.removeAt(0);
    }
    try {
      await _store.write(_historyKey, jsonEncode(list.map((e) => e.toJson()).toList()));
    } catch (_) {
      // History is a nicety; the screen works without persistence.
    }
    return list;
  }

  List<KpiReading> _kpis(Map<String, int> counts, List<_Snapshot> history) {
    KpiReading one(String key,
        {bool upIsGood = true, bool critical = false, bool warning = false}) {
      final value = counts[key] ?? 0;
      double? delta;
      int? deltaCount;
      List<double> spark = const [];
      if (history.length >= 2) {
        final prev = history[history.length - 2].counts[key] ?? value;
        delta = prev == 0 ? (value == 0 ? 0 : 1) : (value - prev) / prev;
        deltaCount = value - prev;
        spark = [for (final s in history) (s.counts[key] ?? 0).toDouble()];
      }
      return KpiReading(
          key: key, value: value, delta: delta, deltaCount: deltaCount, spark: spark, upIsGood: upIsGood, critical: critical, warning: warning);
    }

    return [
      one('activeTrips'),
      one('pendingBookings'),
      one('supplierConfirmations', upIsGood: false),
      one('supportQueue', upIsGood: false),
      one('exceptions', upIsGood: false, critical: true),
      one('paymentIssues', upIsGood: false, warning: true),
      one('activeTransfers'),
      one('unread'),
    ];
  }
}

class _Snapshot {
  _Snapshot({required this.at, required this.counts});

  final DateTime at;
  final Map<String, int> counts;

  factory _Snapshot.fromJson(Map<String, dynamic> json) => _Snapshot(
        at: DateTime.tryParse('${json['at']}') ?? DateTime.fromMillisecondsSinceEpoch(0),
        counts: ((json['counts'] as Map?) ?? const {}).map((k, v) => MapEntry('$k', v is num ? v.toInt() : 0)),
      );

  Map<String, dynamic> toJson() => {'at': at.toIso8601String(), 'counts': counts};
}

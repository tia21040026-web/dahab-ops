import 'package:injectable/injectable.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/models/json_record.dart';
import '../../../core/api/models/paged.dart';

class SupplierBlock extends JsonRecord {
  const SupplierBlock(super.json);

  DateTime? get start => d('startDate');
  DateTime? get end => d('endDate');
  String get reason => s('reason');
}

class PropertyStay extends JsonRecord {
  const PropertyStay(super.json);

  String get ref => s('bookingRef', id);
  String get traveler => s('travelerName');
  String name(bool arabic) => arabic ? first(const ['nameAr', 'name', 'roomTypeName']) : first(const ['name', 'roomTypeName', 'nameAr']);
  DateTime? get checkIn => d('checkIn');
  DateTime? get checkOut => d('checkOut');
  int get nights => i('nights');
  String get status => s('status');
  num get amountEGP => n('totalEGP') ?? n('depositEGP') ?? 0;
  bool get pending => const {'PENDING', 'PENDING_CONFIRMATION', 'REQUESTED'}.contains(status.toUpperCase());
}

class RentalListing extends JsonRecord {
  const RentalListing(super.json);

  String name(bool arabic) => arabic ? first(const ['nameAr', 'name']) : first(const ['name', 'nameAr']);
  String get category => s('category');
  int get quantity => i('quantity');
  num get dailyRateEGP => n('dailyRateEGP') ?? 0;
  num get depositEGP => n('depositEGP') ?? 0;
}

class RentalBooking extends JsonRecord {
  const RentalBooking(super.json);

  String get ref => s('bookingRef', id);
  String get traveler => s('travelerName');
  DateTime? get start => d('startDate');
  DateTime? get end => d('endDate');
  int get quantity => i('quantity', 1);
  String get status => s('status');
  String get paymentState => s('paymentState');
  num get totalEGP => (m('priceBreakdown')['totalEGP'] as num?) ?? 0;
  bool get pending => const {'PENDING', 'REQUESTED', 'PENDING_CONFIRMATION'}.contains(status.toUpperCase());
  bool get active => const {'CONFIRMED', 'ACTIVE', 'IN_PROGRESS', 'DELIVERED'}.contains(status.toUpperCase());
}

class RevenueDay {
  const RevenueDay(this.date, this.gross, this.payout, this.count);

  final DateTime date;
  final double gross;
  final double payout;
  final int count;
}

class RevenueReport {
  const RevenueReport({
    required this.totals,
    required this.daily,
    required this.byService,
    required this.windowDays,
  });

  final Map<String, dynamic> totals;
  final List<RevenueDay> daily;
  final List<Map<String, dynamic>> byService;
  final int windowDays;

  num t(String k) => (totals[k] as num?) ?? 0;
}

class ReliabilityScore {
  const ReliabilityScore(this.score);

  final Map<String, dynamic> score;

  num? v(String k) => score[k] as num?;
  int get sampleSize => (score['sampleSize'] as num?)?.toInt() ?? 0;
}

/// Supplier portal tabs beyond the inbox: availability and blocks, property
/// stays, rentals, revenue analytics and reliability.
@lazySingleton
class SupplierPortalRepository {
  SupplierPortalRepository(this._api);

  final ApiClient _api;

  /// `{ 'YYYY-MM-DD': { blocked, reason? } }` for [month] (`YYYY-MM`).
  Future<Map<String, Map<String, dynamic>>> availability(String supplierId, String month) async {
    final json = await _api.get('/api/suppliers/$supplierId/availability', query: {'month': month});
    final a = (json['availability'] as Map?) ?? const {};
    return {for (final e in a.entries) '${e.key}': (e.value as Map).cast<String, dynamic>()};
  }

  Future<List<SupplierBlock>> blocks(String supplierId) async => [
        for (final m in listOfMaps((await _api.get('/api/suppliers/$supplierId/blocks'))['blocks']))
          SupplierBlock(m),
      ];

  Future<void> addBlock(String supplierId, DateTime start, DateTime end, String reason) {
    String day(DateTime d) => d.toIso8601String().substring(0, 10);
    return _api.post('/api/suppliers/$supplierId/blocks',
        body: {'startDate': day(start), 'endDate': day(end), 'reason': reason});
  }

  Future<Paged<PropertyStay>> stays(ListQuery q) async =>
      pagedFrom(await _api.get('/api/property-stays'), const ['stays'], PropertyStay.new);

  Future<void> respondStay(String ref, {required bool approve, String? reason}) =>
      _api.post('/api/property-stays/$ref/respond', body: {'approve': approve, 'reason': reason});

  Future<Paged<RentalListing>> rentals(ListQuery q) async =>
      pagedFrom(await _api.get('/api/rentals/provider'), const ['rentals'], RentalListing.new);

  Future<Paged<RentalBooking>> rentalBookings(ListQuery q) async =>
      pagedFrom(await _api.get('/api/rental-bookings/provider'), const ['bookings'], RentalBooking.new);

  /// `accept` | `reject` | `mark-returned`.
  Future<void> rentalAction(String id, String action, {String? reason}) =>
      _api.post('/api/rental-bookings/$id/$action', body: {'reason': reason});

  Future<RevenueReport> revenue(String supplierId, {int days = 30}) async {
    final json = await _api.get('/api/suppliers/$supplierId/revenue-analytics', query: {'days': days});
    double d(Object? v) => v is num ? v.toDouble() : 0;
    return RevenueReport(
      totals: (json['totals'] as Map?)?.cast<String, dynamic>() ?? const {},
      windowDays: (json['windowDays'] as num?)?.toInt() ?? days,
      byService: listOfMaps(json['byServiceType']),
      daily: [
        for (final m in listOfMaps(json['daily']))
          if (DateTime.tryParse('${m['date']}') case final date?)
            RevenueDay(date, d(m['grossEGP']), d(m['payoutEGP']), (m['bookingsCount'] as num?)?.toInt() ?? 0),
      ]..sort((a, b) => a.date.compareTo(b.date)),
    );
  }

  Future<ReliabilityScore> reliability(String supplierId) async {
    final json = await _api.get('/api/suppliers/$supplierId/reliability');
    return ReliabilityScore((json['score'] as Map?)?.cast<String, dynamic>() ?? json);
  }
}

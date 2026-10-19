import 'package:injectable/injectable.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/models/json_record.dart';
import '../../../core/api/models/paged.dart';

class Accommodation extends JsonRecord {
  const Accommodation(super.json);

  String name(bool arabic) =>
      arabic ? first(const ['nameAr', 'name'], id) : first(const ['name', 'nameAr'], id);
  String get slug => s('slug');
  String get type => first(const ['propertyType', 'type', 'category']);
  String get area => first(const ['area', 'zone', 'location']);
  bool get active => b('active', true);
  num? get rating => n('rating');
  num? get fromEGP => n('priceFromEGP') ?? n('baseNightlyEGP');
}

class StayBooking extends JsonRecord {
  const StayBooking(super.json);

  String get ref => s('bookingRef', id);
  String name(bool arabic) => arabic ? first(const ['nameAr', 'name']) : first(const ['name', 'nameAr']);
  String get traveler => s('travelerName');
  String get phone => s('travelerPhone');
  DateTime? get checkIn => d('checkIn');
  DateTime? get checkOut => d('checkOut');
  int get nights => i('nights');
  int get rooms => i('rooms', 1);
  String get status => s('status');
  num get depositEGP => n('depositEGP') ?? 0;
  num get perNightEGP => n('perNightEGP') ?? 0;

  /// Actions the hotel desk can take from this status.
  List<String> get actions => switch (status.toUpperCase()) {
        'PENDING' || 'PENDING_CONFIRMATION' || 'REQUESTED' => const ['approve', 'decline'],
        'CONFIRMED' || 'APPROVED' || 'PAID' => const ['check-in', 'no-show', 'cancel'],
        'CHECKED_IN' => const ['complete'],
        _ => const [],
      };
}

/// Accommodations (`/api/admin/accommodations`) and hotel stay bookings
/// (`/api/admin/hotel/bookings`).
@lazySingleton
class StaysRepository {
  StaysRepository(this._api);

  final ApiClient _api;

  Future<Paged<Accommodation>> accommodations(ListQuery q) async => pagedFrom(
      await _api.get('/api/admin/accommodations', query: {
        if (q.q?.isNotEmpty ?? false) 'q': q.q,
        if (q.filters['active'] != null) 'active': q.filters['active'],
      }),
      const ['accommodations'],
      Accommodation.new);

  Future<Accommodation> setActive(String id, bool active, String reason) async {
    final json = await _api.patch('/api/admin/accommodations/$id/active',
        body: {'active': active, 'reason': reason});
    return Accommodation((json['accommodation'] as Map?)?.cast<String, dynamic>() ?? json);
  }

  Future<Paged<StayBooking>> bookings(ListQuery q) async => pagedFrom(
      await _api.get('/api/admin/hotel/bookings', query: {
        'limit': 100,
        if (q.filters['status'] != null) 'status': q.filters['status'],
      }),
      const ['bookings'],
      StayBooking.new);

  /// `POST /api/admin/hotel/bookings/:ref/<action>`.
  Future<StayBooking> act(String ref, String action, {String? reason}) async {
    final path = switch (action) {
      'approve' || 'decline' => 'respond',
      _ => action,
    };
    final body = switch (action) {
      'approve' => {'approve': true},
      'decline' => {'approve': false, 'reason': reason},
      'cancel' => {'reason': reason},
      _ => <String, dynamic>{'reason': reason},
    };
    final json = await _api.post('/api/admin/hotel/bookings/$ref/$path', body: body);
    return StayBooking((json['booking'] as Map?)?.cast<String, dynamic>() ?? json);
  }
}

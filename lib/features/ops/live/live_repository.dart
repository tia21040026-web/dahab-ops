import 'package:injectable/injectable.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/models/json_record.dart';
import '../../../core/api/models/paged.dart';

/// `TripEntity` + `bookingCount`, `activeTransfers`.
class Trip extends JsonRecord {
  const Trip(super.json);

  String get title => first(const ['title', 'name'], id);
  String get status => s('status');
  int get days => i('lengthDays');
  int get travelers => i('travelersCount');
  num get estimatedEGP => n('totalEstimatedEGP') ?? 0;
  num get paidEGP => n('totalPaidEGP') ?? 0;
  int get bookingCount => i('bookingCount');
  int get activeTransfers => i('activeTransfers');
  DateTime? get startDate => d('startDate');
  DateTime? get endDate => d('endDate');
  String get pace => s('pace');

  static const statuses = ['DRAFT', 'PLANNED', 'CONFIRMED', 'IN_DESTINATION', 'COMPLETED', 'CANCELLED'];
}

/// A transfer booking (booking + driver/vehicle/margin fields).
class Transfer extends JsonRecord {
  const Transfer(super.json);

  String get bookingRef => s('bookingRef', id);
  String get traveler => s('travelerName');
  String get pickup => first(const ['pickupLocation', 'origin']);
  String get dropoff => s('dropoffLocation');
  String get scheduled => [s('scheduledDate'), s('scheduledTime')].where((x) => x.isNotEmpty).join(' ');
  String get driver => first(const ['driverName']);
  String get plate => s('vehiclePlate');
  String get status => first(const ['supplierState', 'status']);
  String get paymentState => s('paymentState');
  num get amountEGP => n('amountEGP') ?? n('sellEGP') ?? 0;
  num? get marginEGP => n('marginEGP');
  int get passengers => i('passengersCount');
  DateTime? get lastTelemetryAt => d('lastTelemetryAt');
}

class TripItem extends JsonRecord {
  const TripItem(super.json);

  String get title => s('title');
  String get serviceType => s('serviceType');
  int get day => i('dayNumber');
  String get timeSlot => s('timeSlot');
  num get priceEGP => n('priceEGP') ?? 0;
  String get status => s('status');
  String? get bookingId => so('bookingId');
}

/// Live trips and transfers (`/api/operations/trips`, `/transfers`).
@lazySingleton
class LiveRepository {
  LiveRepository(this._api);

  final ApiClient _api;

  Future<Paged<Trip>> trips(ListQuery q) async {
    final p = pagedFrom(await _api.get('/api/operations/trips'), const ['trips'], Trip.new);
    final status = q.filters['status'];
    return status == null ? p : p.copyWith(items: p.items.where((t) => t.status == status).toList());
  }

  Future<Paged<Transfer>> transfers(ListQuery q) async =>
      pagedFrom(await _api.get('/api/operations/transfers'), const ['transfers'], Transfer.new);

  Future<(Trip, List<TripItem>)> trip(String id) async {
    final json = await _api.get('/api/trips/$id');
    return (Trip((json['trip'] as Map?)?.cast<String, dynamic>() ?? json), [
      for (final m in listOfMaps(json['items'])) TripItem(m),
    ]);
  }

  Future<Trip> setTripStatus(String id, String status) async {
    final json = await _api.patch('/api/trips/$id/status', body: {'status': status});
    return Trip((json['trip'] as Map?)?.cast<String, dynamic>() ?? json);
  }
}

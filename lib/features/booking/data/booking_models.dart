/// Shared ops models, parsed tolerantly from the staff API.
/// Every field the backend may omit has a safe default — a missing key must
/// never crash a dashboard screen.
Map<String, dynamic> _map(Object? v) => v is Map ? v.cast<String, dynamic>() : const {};

double _dbl(Object? v, [double fallback = 0]) {
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v) ?? fallback;
  return fallback;
}

int _int(Object? v, [int fallback = 0]) {
  if (v is num) return v.toInt();
  if (v is String) return int.tryParse(v) ?? fallback;
  return fallback;
}

String _str(Object? v, [String fallback = '']) {
  if (v == null) return fallback;
  return v.toString();
}

/// `BookingEntity` as served by `/api/operations/bookings`,
/// `/api/suppliers/:id/bookings` and the overview payload.
class Booking {
  const Booking({
    required this.id,
    required this.bookingRef,
    required this.tripId,
    required this.supplierId,
    required this.serviceType,
    required this.amountEGP,
    required this.paymentState,
    required this.supplierState,
    required this.travelerName,
    required this.travelerPhone,
    required this.travelerEmail,
    required this.passengersCount,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.confirmationCode,
    required this.createdAt,
    required this.updatedAt,
    this.pickupLocation,
    this.dropoffLocation,
    this.checkOut,
    this.nights,
    this.flightNumber,
    this.specialRequests,
    this.driverName,
    this.vehiclePlate,
    this.skuId = '',
  });

  final String id;
  final String bookingRef;
  final String tripId;
  final String supplierId;
  final String serviceType;
  final double amountEGP;
  final String paymentState;
  final String supplierState;
  final String travelerName;
  final String travelerPhone;
  final String travelerEmail;
  final int passengersCount;
  final String scheduledDate;
  final String scheduledTime;
  final String confirmationCode;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? pickupLocation;
  final String? dropoffLocation;
  final String? checkOut;
  final int? nights;
  final String? flightNumber;
  final String? specialRequests;
  final String? driverName;
  final String? vehiclePlate;
  final String skuId;

  factory Booking.fromJson(Map<String, dynamic> json) {
    DateTime? dt(Object? v) => v is String ? DateTime.tryParse(v) : null;
    final assigned = _map(json['assignedResource']);
    return Booking(
      id: _str(json['id']),
      bookingRef: _str(json['bookingRef']),
      tripId: _str(json['tripId']),
      supplierId: _str(json['supplierId']),
      serviceType: _str(json['serviceType'], 'activity'),
      amountEGP: _dbl(json['amountEGP']),
      paymentState: _str(json['paymentState'], 'UNKNOWN'),
      supplierState: _str(json['supplierState'], 'UNKNOWN'),
      travelerName: _str(json['travelerName']),
      travelerPhone: _str(json['travelerPhone']),
      travelerEmail: _str(json['travelerEmail']),
      passengersCount: _int(json['passengersCount'], 1),
      scheduledDate: _str(json['scheduledDate']),
      scheduledTime: _str(json['scheduledTime']),
      confirmationCode: _str(json['confirmationCode']),
      createdAt: dt(json['createdAt']),
      updatedAt: dt(json['updatedAt']),
      pickupLocation: json['pickupLocation'] as String?,
      dropoffLocation: json['dropoffLocation'] as String?,
      checkOut: json['checkOut'] as String?,
      nights: json['nights'] is num ? (json['nights'] as num).toInt() : null,
      flightNumber: json['flightNumber'] as String?,
      specialRequests: json['specialRequests'] as String?,
      driverName: (json['driverName'] ?? assigned['driverName']) as String?,
      vehiclePlate: (json['vehiclePlate'] ?? assigned['vehiclePlate']) as String?,
      skuId: _str(json['skuId']),
    );
  }

  bool get needsSupplierConfirm => supplierState == 'PENDING_CONFIRMATION';
  bool get isFailedPayment => paymentState == 'FAILED' || paymentState == 'REFUNDED';
  bool get isTransfer => serviceType == 'transfer';

  /// Scheduled start, when the backend carries a parseable date + time.
  DateTime? get scheduledAt {
    if (scheduledDate.isEmpty) return null;
    final time = scheduledTime.isEmpty ? '00:00' : scheduledTime;
    return DateTime.tryParse('${scheduledDate}T$time');
  }
}

/// Slim supplier row (`GET /api/suppliers`, reliability endpoint).
class SupplierLite {
  const SupplierLite({
    required this.id,
    required this.businessName,
    required this.category,
    required this.status,
    this.pendingCount = 0,
    this.confirmationRate,
  });

  final String id;
  final String businessName;
  final String category;
  final String status;
  final int pendingCount;
  final int? confirmationRate;

  factory SupplierLite.fromJson(Map<String, dynamic> json) => SupplierLite(
        id: _str(json['supplierId'].toString().isEmpty ? json['id'] : json['supplierId']),
        businessName: _str(json['businessName']),
        category: _str(json['category']),
        status: _str(json['status']),
        pendingCount: _int(json['pendingCount']),
        confirmationRate: json['confirmationRate'] is num ? (json['confirmationRate'] as num).toInt() : null,
      );
}

/// `GET /api/operations/notifications` summary + item.
class OpsNotification {
  const OpsNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.priority,
    required this.read,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String body;
  final String priority;
  final bool read;
  final DateTime? createdAt;

  factory OpsNotification.fromJson(Map<String, dynamic> json) => OpsNotification(
        id: _str(json['id']),
        title: _str(json['title'] ?? json['summary']),
        body: _str(json['body'] ?? json['message']),
        priority: _str(json['priority'], 'NORMAL'),
        read: json['read'] == true,
        createdAt: json['createdAt'] is String ? DateTime.tryParse(json['createdAt'] as String) : null,
      );

  bool get isUrgent => priority == 'URGENT' || priority == 'HIGH';
}

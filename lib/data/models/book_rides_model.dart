import 'dart:convert';

/// Main Booking Model matching the new API response
class Booking {
  final String id;
  final String rideType;
  final String tripType;
  final String scheduleType;
  final int? numberOfDays;
  final List<String> pickupDays;
  final String startDate;

  // Morning trip details
  final String? morningFrom;
  final String? morningTo;
  final String? morningTime;
  final String? morningFromAddress;
  final String? morningToAddress;

  // Afternoon trip details
  final String? afternoonFrom;
  final String? afternoonTo;
  final String? afternoonTime;
  final String? afternoonFromAddress;
  final String? afternoonToAddress;

  // Geographic coordinates
  final String startLatitude;
  final String startLongitude;
  final String endLatitude;
  final String endLongitude;

  // Status and metadata
  final String status;
  final bool reminderSent;
  final DateTime createdAt;
  final DateTime? serviceEndDate;

  // Related entities
  final String userId;
  final BookingChild child;
  final List<BookingDriver> drivers;

  Booking({
    required this.id,
    required this.rideType,
    required this.tripType,
    required this.scheduleType,
    this.numberOfDays,
    required this.pickupDays,
    required this.startDate,
    this.morningFrom,
    this.morningTo,
    this.morningTime,
    this.morningFromAddress,
    this.morningToAddress,
    this.afternoonFrom,
    this.afternoonTo,
    this.afternoonTime,
    this.afternoonFromAddress,
    this.afternoonToAddress,
    required this.startLatitude,
    required this.startLongitude,
    required this.endLatitude,
    required this.endLongitude,
    required this.status,
    required this.reminderSent,
    required this.createdAt,
    this.serviceEndDate,
    required this.userId,
    required this.child,
    required this.drivers,
  });

  /// Create Booking from JSON
  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['_id'] ?? '',
      rideType: json['ride_type'] ?? '',
      tripType: json['trip_type'] ?? '',
      scheduleType: json['schedule_type'] ?? '',
      numberOfDays: json['number_of_days'],
      pickupDays: List<String>.from(json['pickup_days'] ?? []),
      startDate: json['start_date'] ?? '',
      morningFrom: json['morning_from'],
      morningTo: json['morning_to'],
      morningTime: json['morning_time'],
      morningFromAddress: json['morning_from_address'],
      morningToAddress: json['morning_to_address'],
      afternoonFrom: json['afternoon_from'],
      afternoonTo: json['afternoon_to'],
      afternoonTime: json['afternoon_time'],
      afternoonFromAddress: json['afternoon_from_address'],
      afternoonToAddress: json['afternoon_to_address'],
      startLatitude: json['start_latitude']?.toString() ?? '0',
      startLongitude: json['start_longitude']?.toString() ?? '0',
      endLatitude: json['end_latitude']?.toString() ?? '0',
      endLongitude: json['end_longitude']?.toString() ?? '0',
      status: json['status'] ?? 'pending',
      reminderSent: json['reminderSent'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      serviceEndDate: json['serviceEndDate'] != null
          ? DateTime.parse(json['serviceEndDate'])
          : null,
      userId:
          json['user'] is String ? json['user'] : json['user']?['_id'] ?? '',
      child: BookingChild.fromJson(json['child'] ?? {}),
      drivers: (json['drivers'] as List?)
              ?.map((driver) => BookingDriver.fromJson(driver))
              .toList() ??
          [],
    );
  }

  /// Convert Booking to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'ride_type': rideType,
      'trip_type': tripType,
      'schedule_type': scheduleType,
      'number_of_days': numberOfDays,
      'pickup_days': pickupDays,
      'start_date': startDate,
      'morning_from': morningFrom,
      'morning_to': morningTo,
      'morning_time': morningTime,
      'morning_from_address': morningFromAddress,
      'morning_to_address': morningToAddress,
      'afternoon_from': afternoonFrom,
      'afternoon_to': afternoonTo,
      'afternoon_time': afternoonTime,
      'afternoon_from_address': afternoonFromAddress,
      'afternoon_to_address': afternoonToAddress,
      'start_latitude': startLatitude,
      'start_longitude': startLongitude,
      'end_latitude': endLatitude,
      'end_longitude': endLongitude,
      'status': status,
      'reminderSent': reminderSent,
      'createdAt': createdAt.toIso8601String(),
      'serviceEndDate': serviceEndDate?.toIso8601String(),
      'user': userId,
      'child': child.toJson(),
      'drivers': drivers.map((driver) => driver.toJson()).toList(),
    };
  }

  /// Create a copy with updated fields
  Booking copyWith({
    String? id,
    String? rideType,
    String? tripType,
    String? scheduleType,
    int? numberOfDays,
    List<String>? pickupDays,
    String? startDate,
    String? morningFrom,
    String? morningTo,
    String? morningTime,
    String? morningFromAddress,
    String? morningToAddress,
    String? afternoonFrom,
    String? afternoonTo,
    String? afternoonTime,
    String? afternoonFromAddress,
    String? afternoonToAddress,
    String? startLatitude,
    String? startLongitude,
    String? endLatitude,
    String? endLongitude,
    String? status,
    bool? reminderSent,
    DateTime? createdAt,
    DateTime? serviceEndDate,
    String? userId,
    BookingChild? child,
    List<BookingDriver>? drivers,
  }) {
    return Booking(
      id: id ?? this.id,
      rideType: rideType ?? this.rideType,
      tripType: tripType ?? this.tripType,
      scheduleType: scheduleType ?? this.scheduleType,
      numberOfDays: numberOfDays ?? this.numberOfDays,
      pickupDays: pickupDays ?? this.pickupDays,
      startDate: startDate ?? this.startDate,
      morningFrom: morningFrom ?? this.morningFrom,
      morningTo: morningTo ?? this.morningTo,
      morningTime: morningTime ?? this.morningTime,
      morningFromAddress: morningFromAddress ?? this.morningFromAddress,
      morningToAddress: morningToAddress ?? this.morningToAddress,
      afternoonFrom: afternoonFrom ?? this.afternoonFrom,
      afternoonTo: afternoonTo ?? this.afternoonTo,
      afternoonTime: afternoonTime ?? this.afternoonTime,
      afternoonFromAddress: afternoonFromAddress ?? this.afternoonFromAddress,
      afternoonToAddress: afternoonToAddress ?? this.afternoonToAddress,
      startLatitude: startLatitude ?? this.startLatitude,
      startLongitude: startLongitude ?? this.startLongitude,
      endLatitude: endLatitude ?? this.endLatitude,
      endLongitude: endLongitude ?? this.endLongitude,
      status: status ?? this.status,
      reminderSent: reminderSent ?? this.reminderSent,
      createdAt: createdAt ?? this.createdAt,
      serviceEndDate: serviceEndDate ?? this.serviceEndDate,
      userId: userId ?? this.userId,
      child: child ?? this.child,
      drivers: drivers ?? this.drivers,
    );
  }

  /// Check if this is a return trip (has both morning and afternoon)
  bool get isReturnTrip => tripType.toLowerCase() == 'return';

  /// Get the main pickup location address
  String get mainPickupAddress => morningFromAddress ?? 'N/A';

  /// Get the main dropoff location address
  String get mainDropoffAddress {
    if (isReturnTrip && afternoonToAddress != null) {
      return afternoonToAddress!;
    }
    return morningToAddress ?? 'N/A';
  }

  /// Get formatted pickup days
  String get formattedPickupDays {
    if (pickupDays.isEmpty) return 'No days selected';
    if (pickupDays.length == 7) return 'Every day';
    if (pickupDays.length == 5 &&
        !pickupDays.contains('saturday') &&
        !pickupDays.contains('sunday')) {
      return 'Weekdays';
    }
    return pickupDays
        .map((day) => day[0].toUpperCase() + day.substring(1, 3))
        .join(', ');
  }

  /// Check if ride has assigned drivers
  bool get hasDrivers => drivers.isNotEmpty;

  /// Get first available driver
  BookingDriver? get primaryDriver => drivers.isNotEmpty ? drivers.first : null;

  @override
  String toString() {
    return 'Booking(id: $id, status: $status, child: ${child.fullname})';
  }
}

/// Child information in booking
class BookingChild {
  final String id;
  final String fullname;
  final String? image;
  final int age;
  final String grade;
  final String school;

  BookingChild({
    required this.id,
    required this.fullname,
    this.image,
    required this.age,
    required this.grade,
    required this.school,
  });

  factory BookingChild.fromJson(Map<String, dynamic> json) {
    return BookingChild(
      id: json['_id'] ?? '',
      fullname: json['fullname'] ?? '',
      image: json['image'],
      age: json['age'] ?? 0,
      grade: json['grade']?.toString() ?? '',
      school: json['school'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullname': fullname,
      'image': image,
      'age': age,
      'grade': grade,
      'school': school,
    };
  }

  @override
  String toString() => 'BookingChild(name: $fullname, age: $age)';
}

/// Driver information in booking
class BookingDriver {
  final String id;
  final String fullname;
  final String status;
  final String? image;

  BookingDriver({
    required this.id,
    required this.fullname,
    required this.status,
    this.image,
  });

  factory BookingDriver.fromJson(Map<String, dynamic> json) {
    return BookingDriver(
      id: json['_id'] ?? '',
      fullname: json['fullname'] ?? '',
      status: json['status'] ?? 'unknown',
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullname': fullname,
      'status': status,
      'image': image,
    };
  }

  /// Check if driver is available
  bool get isAvailable => status.toLowerCase() == 'available';

  /// Check if driver is on a trip
  bool get isOnTrip => status.toLowerCase() == 'on_trip';

  @override
  String toString() => 'BookingDriver(name: $fullname, status: $status)';
}

/// Response wrapper for booking API calls
class BookingResponse {
  final bool success;
  final String? message;
  final List<Booking>? rides;
  final Booking? booking;

  BookingResponse({
    required this.success,
    this.message,
    this.rides,
    this.booking,
  });

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    List<Booking>? ridesList;

    // Handle different response formats
    if (json['rides'] != null) {
      ridesList = (json['rides'] as List)
          .map((ride) => Booking.fromJson(ride))
          .toList();
    } else if (json['bookings'] != null) {
      ridesList = (json['bookings'] as List)
          .map((ride) => Booking.fromJson(ride))
          .toList();
    }

    return BookingResponse(
      success: json['success'] ?? true,
      message: json['message'],
      rides: ridesList,
      booking:
          json['booking'] != null ? Booking.fromJson(json['booking']) : null,
    );
  }
}

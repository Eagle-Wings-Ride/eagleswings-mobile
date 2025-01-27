class Booking {
  final String id;
  final String pickUpLocation;
  final String dropOffLocation;
  final String rideType;
  final String tripType;
  final String schedule;
  final String startDate;
  final String pickUpTime;
  final String dropOffTime;
  final String status;
  // final UserModel user;
  // final Child child;
  final String? cancellationReason;
  final String? cancellationDate;
  final String createdAt;
  final double latitude;
  final double longitude;

  Booking({
    required this.id,
    required this.pickUpLocation,
    required this.dropOffLocation,
    required this.rideType,
    required this.tripType,
    required this.schedule,
    required this.startDate,
    required this.pickUpTime,
    required this.dropOffTime,
    required this.status,
    // required this.user,
    // required this.child,
    this.cancellationReason,
    this.cancellationDate,
    required this.createdAt,
    required this.latitude,
    required this.longitude,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['_id'] ?? 'Unknown',
      pickUpLocation: json['pick_up_location'] ?? 'Not provided',
      dropOffLocation: json['drop_off_location'] ?? 'Not provided',
      rideType: json['ride_type'] ?? 'Standard',
      tripType: json['trip_type'] ?? 'One-way',
      schedule: json['schedule'] ?? 'No schedule provided',
      startDate: json['start_date'] ?? 'Unknown',
      pickUpTime: json['pick_up_time'] ?? 'Not provided',
      dropOffTime: json['drop_off_time'] ?? 'Not provided',
      status: json['status'] ?? 'Unknown',
      // user: json['user'] != null ? UserModel.fromJson(json['user']) : UserModel.defaultUser(),
      // child: json['child'] != null ? Child.fromJson(json['child']) : Child.defaultChild(),
      cancellationReason: json['cancellationReason'] ?? null, // Handle null explicitly
      cancellationDate: json['cancellationDate'] ?? null, // Handle null explicitly
      createdAt: json['createdAt'] ?? 'Unknown',
      latitude: json['latitude'] != null ? double.tryParse(json['latitude'].toString()) ?? 0.0 : 0.0,
      longitude: json['longitude'] != null ? double.tryParse(json['longitude'].toString()) ?? 0.0 : 0.0,
    );
  }
}

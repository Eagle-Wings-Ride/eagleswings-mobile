class Pricing {
  final Map<String, int> inHouseDrivers;
  final Map<String, int> freelanceDrivers;
  final String id;
  final DateTime createdAt;

  Pricing({
    required this.inHouseDrivers,
    required this.freelanceDrivers,
    required this.id,
    required this.createdAt,
  });

  factory Pricing.fromJson(Map<String, dynamic> json) {
    return Pricing(
      inHouseDrivers: Map<String, int>.from(json['in_house_drivers']),
      freelanceDrivers: Map<String, int>.from(json['freelance_drivers']),
      id: json['_id'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

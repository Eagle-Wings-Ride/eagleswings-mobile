class LocationOnboardingData {
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? postalCode;
  final double? latitude;
  final double? longitude;

  LocationOnboardingData({
    this.address,
    this.city,
    this.state,
    this.country,
    this.postalCode,
    this.latitude,
    this.longitude,
  });

  factory LocationOnboardingData.fromJson(Map<String, dynamic> json) {
    return LocationOnboardingData(
      address: json['address']?.toString(),
      city: json['city']?.toString(),
      state: json['state']?.toString(),
      country: json['country']?.toString(),
      postalCode: json['postalCode']?.toString(),
      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString())
          : null,
      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'address': address,
        'city': city,
        'state': state,
        'country': country,
        'postalCode': postalCode,
        'latitude': latitude,
        'longitude': longitude,
      };

  @override
  String toString() {
    return 'LocationOnboardingData(address: $address, city: $city, state: $state, country: $country, postalCode: $postalCode, latitude: $latitude, longitude: $longitude)';
  }
}

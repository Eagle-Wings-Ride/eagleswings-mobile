class UserModel {
  final String id;
  final String name;
  final String email;
  final String number;
  final String address;
  // final String isVerified;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.number,
    required this.address,
    // required this.isVerified,
  });

  // From JSON to UserModel (used for API response)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    final resolvedId = (json['_id'] ?? json['id'] ?? '').toString();
    return UserModel(
      id: resolvedId,
      name: json['fullname'] ?? 'Guest',
      email: json['email'] ?? '',
      number: json['phone_number'] ?? '',
      address: json['address'] ?? '',
      // isVerified: json['isVerified'] ?? '',
    );
  }

  // From Map to UserModel (used for local storage like Hive)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    final resolvedId = (map['_id'] ?? map['id'] ?? '').toString();
    return UserModel(
      id: resolvedId,
      name: map['fullname'] ?? '',
      email: map['email'] ?? '',
      number: map['phone_number'] ?? '',
      address: map['address'] ?? '',
      // isVerified: map['isVerified'] ?? '',
    );
  }

  // To JSON from UserModel
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      '_id': id,
      'fullname': name,
      'email': email,
      'phone_number': number,
      'address': address,
      // 'isVerified': isVerified,
    };
  }
}

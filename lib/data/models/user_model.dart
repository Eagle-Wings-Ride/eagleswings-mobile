class UserModel {
  final String id;
  // final String name;
  final String email;
  // final String number;
  // final String address;
  // final String isVerified;

  UserModel({
    required this.id,
    // required this.name,
    required this.email,
    // required this.number,
    // required this.address,
    // required this.isVerified,
  });

  // From JSON to UserModel (used for API response)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      // name: json['full_name'] ?? '',
      email: json['email'] ?? '',
      // number: json['number'] ?? '',
      // address: json['address'] ?? '',
      // isVerified: json['isVerified'] ?? '',
    );
  }

  // From Map to UserModel (used for local storage like Hive)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['_id'] ?? '',
      // name: map['full_name'] ?? '',
      email: map['email'] ?? '',
      // number: map['number'] ?? '',
      // address: map['address'] ?? '',
      // isVerified: map['isVerified'] ?? '',
    );
  }

  // To JSON from UserModel
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      // 'full_name': name,
      'email': email,
      // 'number': number,
      // 'address': address,
      // 'isVerified': isVerified,
    };
  }
}

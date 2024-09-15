class RegisterModel {
  final String fullName;
  final String email;
  final String password;
  final String phoneNumber;
  final String address;

  RegisterModel({
    required this.fullName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.address,
  });

  // factory RegisterModel.fromJson(Map<String, dynamic> json) {
  //   return RegisterModel(
  //     fullName: json['fullName'],
  //     email: json['email'],
  //     password: json['password'],
  //     phoneNumber: json['phoneNumber'],
  //     address: json['address'],
  //   );
  // }

  // Map<String, dynamic> toJson() => {
  //       'fullName': fullName,
  //     };
}

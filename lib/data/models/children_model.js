// class Child {
//     final String id;
//     final String fullname;
//     final int age;
//     final int grade;
//     final String school;
//     final String address;
//     final String relationship;
//     final String user;
//     final DateTime createdAt;
  
//     Child({
//       required this.id,
//       required this.fullname,
//       required this.age,
//       required this.grade,
//       required this.school,
//       required this.address,
//       required this.relationship,
//       required this.user,
//       required this.createdAt,
//     });
  
//     // Factory constructor for creating a Child object from JSON
//     factory Child.fromJson(Map<String, dynamic> json) {
//       return Child(
//         id: json['_id'],
//         fullname: json['fullname'],
//         age: json['age'],
//         grade: json['grade'],
//         school: json['school'],
//         address: json['address'],
//         relationship: json['relationship'],
//         user: json['user'],
//         createdAt: DateTime.parse(json['createdAt']),
//       );
//     }
//   }
  
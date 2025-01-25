class Child {
    final String id;
    final String fullname;
    final int age;
    final int grade;
    final String school;
    final String address;
    final String relationship;
    final String user;
  
    Child({
      required this.id,
      required this.fullname,
      required this.age,
      required this.grade,
      required this.school,
      required this.address,
      required this.relationship,
      required this.user,
    });
  
    // Factory constructor for creating a Child object from JSON
    factory Child.fromJson(Map<String, dynamic> json) {
      return Child(
        id: json['_id'],
        fullname: json['fullname'],
        age: json['age'],
        grade: json['grade'],
        school: json['school'],
        address: json['address'],
        relationship: json['relationship'],
        user: json['user'],
      );
    }

     // toJson method to convert the Child object into a Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullname': fullname,
      'age': age,
      'grade': grade,
      'school': school,
      'address': address,
      'relationship': relationship,
      'user': user,
    };
  }
  }
  
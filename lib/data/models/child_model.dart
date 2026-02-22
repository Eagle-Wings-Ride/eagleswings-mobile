import 'dart:convert';

/// Child Model matching the new API response
class Child {
  final String id;
  final String fullname;
  final String? image;
  final int age;
  final String grade;
  final String relationship;
  final String school;
  final String homeAddress;
  final String schoolAddress;
  final String daycareAddress;
  final String userId;
  final DateTime createdAt;

  Child({
    required this.id,
    required this.fullname,
    this.image,
    required this.age,
    required this.grade,
    required this.relationship,
    required this.school,
    required this.homeAddress,
    required this.schoolAddress,
    required this.daycareAddress,
    required this.userId,
    required this.createdAt,
  });

  /// Create Child from JSON
  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      id: json['_id'] ?? '',
      fullname: json['fullname'] ?? '',
      image: json['image'],
      age: json['age'] ?? 0,
      grade: json['grade']?.toString() ?? '',
      relationship: json['relationship'] ?? '',
      school: json['school'] ?? '',
      homeAddress: json['home_address'] ?? '',
      schoolAddress: json['school_address'] ?? '',
      daycareAddress: json['daycare_address'] ?? '',
      userId: json['user'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  /// Convert Child to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullname': fullname,
      'image': image,
      'age': age,
      'grade': grade,
      'relationship': relationship,
      'school': school,
      'home_address': homeAddress,
      'school_address': schoolAddress,
      'daycare_address': daycareAddress,
      'user': userId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create a copy with updated fields
  Child copyWith({
    String? id,
    String? fullname,
    String? image,
    int? age,
    String? grade,
    String? relationship,
    String? school,
    String? homeAddress,
    String? schoolAddress,
    String? daycareAddress,
    String? userId,
    DateTime? createdAt,
  }) {
    return Child(
      id: id ?? this.id,
      fullname: fullname ?? this.fullname,
      image: image ?? this.image,
      age: age ?? this.age,
      grade: grade ?? this.grade,
      relationship: relationship ?? this.relationship,
      school: school ?? this.school,
      homeAddress: homeAddress ?? this.homeAddress,
      schoolAddress: schoolAddress ?? this.schoolAddress,
      daycareAddress: daycareAddress ?? this.daycareAddress,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Get initials from name
  String get initials {
    if (fullname.isEmpty) return '?';
    final parts = fullname.trim().split(' ');
    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  /// Get formatted age text
  String get ageText => age == 1 ? '$age year old' : '$age years old';

  /// Get formatted grade text
  String get gradeText => 'Grade $grade';

  /// Check if child has profile image
  bool get hasImage => image != null && image!.isNotEmpty;

  @override
  String toString() {
    return 'Child(id: $id, name: $fullname, age: $age, grade: $grade)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Child && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Response wrapper for children API calls
class ChildrenResponse {
  final bool success;
  final String? message;
  final List<Child>? children;
  final Child? child;

  ChildrenResponse({
    required this.success,
    this.message,
    this.children,
    this.child,
  });

  factory ChildrenResponse.fromJson(dynamic json) {
    List<Child>? childrenList;

    // Handle array response
    if (json is List) {
      childrenList = json.map((child) => Child.fromJson(child as Map<String, dynamic>)).toList();
      return ChildrenResponse(
        success: true,
        children: childrenList,
      );
    } 
    
    // Handle object response
    if (json is Map<String, dynamic>) {
      if (json['children'] != null) {
        childrenList = (json['children'] as List)
            .map((child) => Child.fromJson(child as Map<String, dynamic>))
            .toList();
      }
      
      return ChildrenResponse(
        success: json['success'] ?? true,
        message: json['message'],
        children: childrenList,
        child: json['child'] != null ? Child.fromJson(json['child']) : null,
      );
    }

    return ChildrenResponse(success: false);
  }
}
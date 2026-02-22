import 'dart:io';

class ChildUpsertRequest {
  final String fullname;
  final String age;
  final String grade;
  final String relationship;
  final String school;
  final String homeAddress;
  final String schoolAddress;
  final String? daycareAddress;
  final File? imageFile;

  const ChildUpsertRequest({
    required this.fullname,
    required this.age,
    required this.grade,
    required this.relationship,
    required this.school,
    required this.homeAddress,
    required this.schoolAddress,
    this.daycareAddress,
    this.imageFile,
  });

  Map<String, String> toFormFields() {
    final fields = <String, String>{
      'fullname': fullname.trim(),
      'age': age.trim(),
      'grade': grade.trim(),
      'relationship': relationship.trim(),
      'school': school.trim(),
      'home_address': homeAddress.trim(),
      'school_address': schoolAddress.trim(),
    };

    final daycare = daycareAddress?.trim();
    if (daycare != null && daycare.isNotEmpty) {
      fields['daycare_address'] = daycare;
    }

    return fields;
  }

  Map<String, dynamic> toJson() {
    return {
      'fullname': fullname,
      'age': age,
      'grade': grade,
      'relationship': relationship,
      'school': school,
      'home_address': homeAddress,
      'school_address': schoolAddress,
      if (daycareAddress != null && daycareAddress!.trim().isNotEmpty)
        'daycare_address': daycareAddress,
    };
  }
}

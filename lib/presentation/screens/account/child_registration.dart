import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../config/map_api_key.dart';
import '../../../data/models/child_upsert_request.dart';
import '../../../styles/styles.dart';
import '../../../widgets/widgets.dart';
import '../../controller/auth/auth_controller.dart';

class ChildRegistration extends StatefulWidget {
  final dynamic editChild;

  const ChildRegistration({super.key, this.editChild});

  @override
  State<ChildRegistration> createState() => _ChildRegistrationState();
}

class _ChildRegistrationState extends State<ChildRegistration> {
  final AuthController _authController = Get.find();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _relationshipController = TextEditingController();
  final TextEditingController _homeAddressController = TextEditingController();
  final TextEditingController _schoolAddressController =
      TextEditingController();
  final TextEditingController _daycareAddressController =
      TextEditingController();
  final TextEditingController _schoolController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  bool _showDropdown = false;
  final GlobalKey _textFieldKey = GlobalKey();
  double _textFieldOffset = 0; // Position of the TextField
  final registerChildFormKey = GlobalKey<FormState>();
  // bool _isLoading = true;
  List<String> genderList = ['Male', 'Female'];
  bool idSelected = false;
  bool terms = false;
  File? _selectedImage;

  bool get isEditMode => widget.editChild != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      _prefillFormForEdit();
    }
  }

  void _prefillFormForEdit() {
    final child = widget.editChild;
    _fullNameController.text = child.fullname ?? '';
    _ageController.text = child.age?.toString() ?? '';
    _gradeController.text = child.grade?.toString() ?? '';
    _relationshipController.text = child.relationship ?? '';
    _schoolController.text = child.school ?? '';
    _homeAddressController.text = child.homeAddress ?? '';
    _schoolAddressController.text = child.schoolAddress ?? '';
    _daycareAddressController.text = child.daycareAddress ?? '';
    terms = true; // Already agreed when first registered
  }

  @override
  void dispose() {
    _ageController.dispose();
    _fullNameController.dispose();
    _gradeController.dispose();
    _relationshipController.dispose();
    _genderController.dispose();
    _homeAddressController.dispose();
    _schoolAddressController.dispose();
    _daycareAddressController.dispose();
    _schoolController.dispose();
    super.dispose();
  }

  List<dynamic> _suggestions = [];

  // Fetch suggestions from Google Places API
  Future<void> getSuggestions(String input) async {
    if (input.isEmpty) {
      setState(() {
        _suggestions.clear(); // Clear suggestions if input is empty
        _showDropdown = false;
      });
      return;
    }

    final String url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey&components=country:ca";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      // print(data['predictions']);
      setState(() {
        _suggestions = data['predictions'] ?? [];
        _showDropdown = _suggestions.isNotEmpty;
      });
    } else {
      print("Error fetching suggestions");
    }
  }

  // Get the position of the TextField
  void getTextFieldPosition() {
    final RenderBox renderBox =
        _textFieldKey.currentContext!.findRenderObject() as RenderBox;
    final Offset position = renderBox.localToGlobal(Offset.zero);
    setState(() {
      _textFieldOffset = position.dy + renderBox.size.height;
    });
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) {
        return;
      }

      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    } catch (e) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: 'Unable to select image: $e',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    validateFullName(fullName) {
      if (fullName == null || fullName.isEmpty) {
        return 'full name cannot be empty';
      }
      return null;
    }

    validateAge(age) {
      if (age == null || age.isEmpty) {
        return 'age cannot be empty';
      }
      return null;
    }

    validateRelationship(relationship) {
      if (relationship == null || relationship.isEmpty) {
        return 'relationship cannot be empty';
      }
      return null;
    }

    validateGrade(grade) {
      if (grade == null || grade.isEmpty) {
        return 'grade cannot be empty';
      }
      return null;
    }

    validateSchool(school) {
      if (school == null || school.isEmpty) {
        return 'school cannot be empty';
      }
      return null;
    }

    validateHomeAddress(address) {
      if (address == null || address.isEmpty) {
        return 'Please enter a valid home address';
      }
      return null;
    }

    validateSchoolAddress(address) {
      if (address == null || address.isEmpty) {
        return 'Please enter a valid school address';
      }
      return null;
    }

    final genderSelect = TextFormField(
      onTap: () {
        showModalBottomSheet(
          isDismissible: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          context: context,
          builder: (BuildContext context) {
            return FractionallySizedBox(
              heightFactor: 0.5,
              child: Container(
                // height: 350,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(19)),
                child: ListView(
                  children: [
                    Text(
                      'Select Gender',
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: textColor,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: genderList.length,
                        itemBuilder: (context, idx) {
                          return Column(
                            children: [
                              ListTileTheme(
                                contentPadding: const EdgeInsets.only(
                                    left: 13.0, right: 13.0, top: 4, bottom: 4),
                                selectedColor:
                                    Theme.of(context).colorScheme.secondary,
                                child: ListTile(
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: Text(
                                          genderList[idx],
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: textColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    setState(() {
                                      idSelected = true;
                                    });

                                    _genderController.text = genderList[idx];

                                    Navigator.pop(
                                      context,
                                    );

                                    setState(() {});
                                  },
                                ),
                              ),
                              (idx != genderList.length - 1)
                                  ? Divider(
                                      color: Theme.of(context).dividerColor,
                                      height: 1,
                                      indent: 13,
                                      endIndent: 13,
                                    )
                                  : const SizedBox(),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      readOnly: true,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      autofocus: false,
      enableSuggestions: true,
      cursorHeight: 14,
      cursorColor: textColor,
      style: GoogleFonts.poppins(
          color: textColor, fontSize: 14, fontWeight: FontWeight.w500),

      controller: _genderController,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: 'Select Gender',
        errorStyle: GoogleFonts.poppins(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        hintStyle: GoogleFonts.poppins(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: backgroundColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: false,
        fillColor: Colors.transparent,
        contentPadding: EdgeInsets.all(14.sp),
      ),
      maxLines: 1,
    );

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 30.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/app_name.png',
                        height: 21.5.h,
                      ),
                      SizedBox(
                        height: 47.h,
                      ),
                      Text(
                        'Register your child',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      SizedBox(
                        height: 50.h,
                      ),
                      Form(
                        key: registerChildFormKey,
                        child: Column(
                          children: [
                            CustomTextFieldWidget(
                              controller: _fullNameController,
                              keyboardType: TextInputType.name,
                              obscureText: false,
                              filled: false,
                              readOnly: false,
                              labelText: 'Full name',
                              hintText: 'John Doe',
                              autoValidateMode:
                                  AutovalidateMode.onUserInteraction,
                              maxLines: 1,
                              validator: validateFullName,
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 10.h,
                                            left: 3.w,
                                            right: 3.w),
                                        child: Text(
                                          'Select Gender',
                                          style: GoogleFonts.poppins(
                                            color: textColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      genderSelect,
                                      // const SizedBox(
                                      //   height: 20,
                                      // ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: CustomTextFieldWidget(
                                    controller: _ageController,
                                    keyboardType: TextInputType.number,
                                    obscureText: false,
                                    filled: false,
                                    readOnly: false,
                                    labelText: 'Age',
                                    hintText: 'enter age',
                                    autoValidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    maxLines: 1,
                                    validator: validateAge,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            CustomTextFieldWidget(
                              controller: _relationshipController,
                              keyboardType: TextInputType.text,
                              obscureText: false,
                              filled: false,
                              readOnly: false,
                              labelText: 'Relationship',
                              hintText: 'Enter relationship',
                              autoValidateMode:
                                  AutovalidateMode.onUserInteraction,
                              maxLines: 1,
                              validator: validateRelationship,
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            CustomTextFieldWidget(
                              controller: _gradeController,
                              keyboardType: TextInputType.number,
                              obscureText: false,
                              filled: false,
                              readOnly: false,
                              labelText: 'Grade',
                              hintText: 'What Class?',
                              autoValidateMode:
                                  AutovalidateMode.onUserInteraction,
                              maxLines: 1,
                              validator: validateGrade,
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            CustomTextFieldWidget(
                              controller: _schoolController,
                              keyboardType: TextInputType.text,
                              obscureText: false,
                              filled: false,
                              readOnly: false,
                              labelText: 'School',
                              hintText: 'Enter your school?',
                              autoValidateMode:
                                  AutovalidateMode.onUserInteraction,
                              maxLines: 1,
                              validator: validateSchool,
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            CustomTextFieldWidget(
                              key: _textFieldKey,
                              controller: _homeAddressController,
                              keyboardType: TextInputType.streetAddress,
                              obscureText: false,
                              filled: false,
                              readOnly: false,
                              onChanged: (value) {
                                getTextFieldPosition(); // Update position dynamically
                                getSuggestions(value); // Fetch suggestions
                              },
                              prefixIcon: Icon(
                                Icons.location_on_sharp,
                                color: greyColor,
                              ),
                              labelText: 'Home Address',
                              hintText: 'Start typing home address',
                              autoValidateMode:
                                  AutovalidateMode.onUserInteraction,
                              maxLines: 1,
                              validator: validateHomeAddress,
                            ),
                            if (_showDropdown &&
                                _homeAddressController.text.isNotEmpty)
                              Material(
                                elevation: 2,
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  height: 200, // Adjust height as needed
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                  ),
                                  child: ListView.builder(
                                    itemCount: _suggestions.length,
                                    itemBuilder: (context, index) {
                                      final suggestion = _suggestions[index];
                                      return ListTile(
                                        title: Text(suggestion['description']),
                                        onTap: () {
                                          _homeAddressController.text =
                                              suggestion['description'];
                                          setState(() {
                                            _suggestions.clear();
                                            _showDropdown = false;
                                          });
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            SizedBox(
                              height: 10.h,
                            ),
                            CustomTextFieldWidget(
                              controller: _schoolAddressController,
                              keyboardType: TextInputType.streetAddress,
                              obscureText: false,
                              filled: false,
                              readOnly: false,
                              labelText: 'School Address',
                              hintText: 'Enter school address',
                              autoValidateMode:
                                  AutovalidateMode.onUserInteraction,
                              maxLines: 1,
                              validator: validateSchoolAddress,
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            CustomTextFieldWidget(
                              controller: _daycareAddressController,
                              keyboardType: TextInputType.streetAddress,
                              obscureText: false,
                              filled: false,
                              readOnly: false,
                              labelText: 'Daycare Address (Optional)',
                              hintText: 'Enter daycare address',
                              autoValidateMode:
                                  AutovalidateMode.onUserInteraction,
                              maxLines: 1,
                            ),
                            SizedBox(
                              height: 12.h,
                            ),
                            Row(
                              children: [
                                OutlinedButton.icon(
                                  onPressed: _pickImage,
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: backgroundColor,
                                    side: BorderSide(color: backgroundColor),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  icon: const Icon(Icons.image_outlined),
                                  label: Text(
                                    _selectedImage == null
                                        ? 'Upload Image (Optional)'
                                        : 'Change Image',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                if (_selectedImage != null) ...[
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      _selectedImage!.path.split('/').last,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: textColor.withOpacity(0.7),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Center(
                              child: Container(
                                width: double.maxFinite,
                                margin: EdgeInsets.symmetric(vertical: 20.h),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 20.h),
                                alignment: Alignment.bottomCenter,
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  runAlignment: WrapAlignment.center,
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  // spacing: 8.0,
                                  // runSpacing: 8.0,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          terms = !terms;
                                        });
                                      },
                                      child: Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: greyColor, width: 2),
                                            shape: BoxShape.circle,
                                            color: terms == false
                                                ? page
                                                : buttonColor),
                                        child: Icon(
                                          Icons.done,
                                          color: terms == false
                                              ? buttonColor
                                              : Colors.white,
                                          size: 10,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.04,
                                    ),
                                    Text(
                                      'By signing up, you accept our ',
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Text(
                                        'Terms ',
                                        style: TextStyle(
                                          color: backgroundColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text('and ',
                                        style: TextStyle(
                                          color: textColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        )),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Text(
                                        'Privacy Policy ',
                                        style: TextStyle(
                                          color: backgroundColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(
                                      MediaQuery.of(context).size.width - 50,
                                      50),
                                  backgroundColor: textColor,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      50,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  if (registerChildFormKey.currentState!
                                      .validate()) {
                                    if (terms == true) {
                                      final childData = ChildUpsertRequest(
                                        fullname:
                                            _fullNameController.text.trim(),
                                        age: _ageController.text.trim(),
                                        grade: _gradeController.text.trim(),
                                        school: _schoolController.text.trim(),
                                        relationship: _relationshipController
                                            .text
                                            .trim(),
                                        homeAddress:
                                            _homeAddressController.text.trim(),
                                        schoolAddress:
                                            _schoolAddressController.text.trim(),
                                        daycareAddress: _daycareAddressController
                                            .text
                                            .trim(),
                                        imageFile: _selectedImage,
                                      );

                                      if (isEditMode) {
                                        // Update existing child
                                        _authController
                                            .updateChild(
                                          widget.editChild.id,
                                          childData,
                                        )
                                            .then((_) {
                                          Get.back();
                                        });
                                      } else {
                                        // Add new child
                                        _authController.addChild(
                                            childData, context);
                                      }
                                    } else {
                                      showTopSnackBar(
                                        Overlay.of(context),
                                        const CustomSnackBar.error(
                                          message:
                                              'You have to agree to the terms of service',
                                        ),
                                      );
                                      // Get.snackbar('Error!',
                                      //     'You have to agree to the terms of service');
                                    }
                                  } else {
                                    showTopSnackBar(
                                      Overlay.of(context),
                                      const CustomSnackBar.error(
                                        message:
                                            'Please fill the form properly',
                                      ),
                                    );
                                    // Get.snackbar('Error!',
                                    //     'Please fill the form properly');
                                  }
                                },
                                child: Text(
                                  'Confirm',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    color: buttonText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

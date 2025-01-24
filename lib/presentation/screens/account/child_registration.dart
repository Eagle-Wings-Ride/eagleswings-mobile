import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../../../config/map_api_key.dart';
import '../../../styles/styles.dart';
import '../../../widgets/widgets.dart';

class ChildRegistration extends StatefulWidget {
  const ChildRegistration({super.key});

  @override
  State<ChildRegistration> createState() => _ChildRegistrationState();
}

class _ChildRegistrationState extends State<ChildRegistration> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _relationshipController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _showDropdown = false;
  final GlobalKey _textFieldKey = GlobalKey();
  double _textFieldOffset = 0; // Position of the TextField
  final registerChildFormKey = GlobalKey<FormState>();
  bool _isLoading = true;
  List<String> genderList = ['Male', 'Female', 'Other'];
  bool idSelected = false;

  @override
  void dispose() {
    _ageController.dispose();
    _fullNameController.dispose();
    _gradeController.dispose();
    _relationshipController.dispose();
    _genderController.dispose();
    _addressController.dispose();
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
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
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

    validateAddress(address) {
      if (address == null || address.isEmpty) {
        return 'Please enter a valid adress';
      }
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
            SingleChildScrollView(
              child: Column(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
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
                                    width:
                                        MediaQuery.of(context).size.width / 3,
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
                                height: 20.h,
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
                                height: 20.h,
                              ),
                              CustomTextFieldWidget(
                                controller: _gradeController,
                                keyboardType: TextInputType.text,
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
                                height: 20.h,
                              ),
                            ],
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
      ),
    );
  }
}

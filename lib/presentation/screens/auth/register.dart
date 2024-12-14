import 'package:eaglerides/presentation/screens/auth/set_password.dart';
import 'package:eaglerides/presentation/screens/auth/verify_email.dart';
import 'package:eaglerides/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../functions/function.dart';
import '../../../widgets/widgets.dart';
import '../../../pages/loadingPage/loading.dart';
import '../../../pages/noInternet/no_internet.dart';
import 'login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final signUpFormKey = GlobalKey<FormState>();

  // bool enableSignIn = false;
  bool obscureText = true;

  bool terms = false; //terms and conditions true or false
  bool _isLoading = true;

  @override
  void initState() {
    countryCode();
    super.initState();
  }

  countryCode() async {
    var result = await getCountryCode();
    if (result == 'success') {
      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // validateLast(lastValue) {
  //   if (lastValue.isEmpty) {
  //     return 'last name cannot be empty';
  //   }

  //   return null;
  // }

  @override
  Widget build(BuildContext context) {
    validateFullName(fullName) {
      if (fullName == null || fullName.isEmpty) {
        return 'full name cannot be empty';
      }
      return null;
    }

    //Validator
    validateMail(emailValue) {
      if (emailValue == null || emailValue.isEmpty) {
        return 'Please enter an email address.';
      }
      if (!RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
          .hasMatch(emailValue)) {
        return 'Please enter a valid email address.';
      }

      return null;
    }

    validatePhone(phoneValue) {
      if (phoneValue.toString().isEmpty) {
        return 'phone cannot be empty';
      }
      if (phoneValue.toString().length < 11) {
        return 'phone is invalid';
      }
      if (int.tryParse(phoneValue.toString()) == null) {
        return 'enter valid number';
      }
      return null;
    }

    validateAddress(address) {
      if (address == null || address.isEmpty) {
        return 'Please enter a valid adress';
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
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
                          'Let’s get you set up',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.dmSans(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        SizedBox(
                          height: 50.h,
                        ),
                        Form(
                          key: signUpFormKey,
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
                              CustomTextFieldWidget(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                obscureText: false,
                                filled: false,
                                readOnly: false,
                                labelText: 'Email',
                                hintText: 'user@email.com',
                                autoValidateMode:
                                    AutovalidateMode.onUserInteraction,
                                maxLines: 1,
                                validator: validateMail,
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        bottom: 10.h, left: 3.w, right: 3.w),
                                    child: Text(
                                      'Phone Number',
                                      style: GoogleFonts.dmSans(
                                        color: textColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  IntlPhoneField(
                                    dropdownIconPosition: IconPosition.trailing,
                                    initialCountryCode: 'CA',
                                    disableLengthCheck: false,
                                    controller: _phoneNumberController,
                                    flagsButtonPadding:
                                        EdgeInsets.only(left: 14.sp),
                                    cursorColor: textColor,
                                    cursorHeight: 14,
                                    style: GoogleFonts.dmSans(
                                        color: textColor, fontSize: 14),
                                    decoration: InputDecoration(
                                      filled: false,
                                      // fillColor: Colors.black12,
                                      fillColor: Theme.of(context).canvasColor,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: const BorderSide(
                                          color: Color(0xffE0E0E0),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: backgroundColor, width: 1),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: const BorderSide(
                                          color: Color(0xffE0E0E0),
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: const BorderSide(
                                            color: Colors.red, width: 1),
                                      ),
                                      hintText: '005 094 098',
                                      errorStyle: GoogleFonts.dmSans(
                                        color: Colors.red,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      hintStyle: GoogleFonts.dmSans(
                                        color: Colors.grey,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      contentPadding: EdgeInsets.all(14.sp),
                                    ),
                                    onChanged: (phone) {
                                      debugPrint(phone.completeNumber);
                                    },
                                    onCountryChanged: (country) {
                                      debugPrint(
                                          'Country changed to: ${country.name}');
                                    },
                                    validator: validatePhone,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              CustomTextFieldWidget(
                                controller: _addressController,
                                keyboardType: TextInputType.streetAddress,
                                obscureText: false,
                                filled: false,
                                readOnly: false,
                                prefixIcon: Icon(
                                  Icons.location_on_sharp,
                                  color: greyColor,
                                ),
                                labelText: 'Address',
                                hintText: 'Start typing your address',
                                autoValidateMode:
                                    AutovalidateMode.onUserInteraction,
                                maxLines: 1,
                                validator: validateAddress,
                              ),
                              SizedBox(
                                height: 20.h,
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
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.04,
                                      ),
                                      Text(
                                        'By signing up, you accept our ',
                                        style: TextStyle(
                                          color: textColor,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {},
                                        child: Text(
                                          'Terms ',
                                          style: TextStyle(
                                            color: backgroundColor,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Text('and ',
                                          style: TextStyle(
                                            color: textColor,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400,
                                          )),
                                      GestureDetector(
                                        onTap: () {},
                                        child: Text(
                                          'Privacy Policy ',
                                          style: TextStyle(
                                            color: backgroundColor,
                                            fontSize: 10,
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
                                    // if (signUpFormKey.currentState!
                                    //     .validate()) {
                                    //   if (terms == true) {
                                    //     Navigator.push(
                                    //       context,
                                    //       MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             SetPasswordPage(
                                    //           fullName:
                                    //               _fullNameController.text,
                                    //           email: _emailController.text,
                                    //           phoneNumber:
                                    //               _phoneNumberController.text,
                                    //           address: _addressController.text,
                                    //         ),
                                    //       ),
                                    //     );
                                    //   } else {
                                    //     Get.snackbar('Error!',
                                    //         'You have to agree to the terms of service');
                                    //   }
                                    // } else {
                                    //   Get.snackbar('Error!',
                                    //       'Please fill the form properly');
                                    // }
                                    // _authController.register({
                                    //   'fullName': _fullNameController.text,
                                    //   'email': _emailController.text,
                                    //   'phoneNumber':
                                    //       _phoneNumberController.text,
                                    //   'address': _addressController.text
                                    // });
                                    Get.to(
                                      const VerifyEmail(
                                        email: 'text@gmail.com',
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Continue',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.dmSans(
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
                        Center(
                          child: Container(
                            width: double.maxFinite,
                            margin: EdgeInsets.symmetric(vertical: 20.h),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 0.h),
                            alignment: Alignment.bottomCenter,
                            child: Wrap(
                              children: [
                                Text(
                                  'Already have an account? ',
                                  style: GoogleFonts.dmSans(
                                    color: textColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.to(const Login());
                                  },
                                  child: Text(
                                    'Login ',
                                    style: GoogleFonts.dmSans(
                                      color: backgroundColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //No internet
            (internet == false)
                ? Positioned(
                    top: 0,
                    child: NoInternet(onTap: () {
                      setState(() {
                        _isLoading = true;
                        internet = true;
                        countryCode();
                      });
                    }))
                : Container(),
            (_isLoading == true)
                ? const Positioned(top: 0, child: Loading())
                : Container()
          ],
        ),
      ),
    );
  }
}

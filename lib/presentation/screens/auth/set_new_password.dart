import 'package:eaglerides/presentation/screens/auth/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../styles/styles.dart';
import '../../../widgets/widgets.dart';
import 'login.dart';
import 'verification_confirmation_screen.dart';

class SetNewPasswordScreen extends StatefulWidget {
  const SetNewPasswordScreen({super.key, required this.email});
  final String email;

  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final setNewPasswordFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    validatePass(passValue) {
      RegExp uppercaseRegex = RegExp(r'[A-Z]');
      RegExp lowercaseRegex = RegExp(r'[a-z]');
      RegExp digitsRegex = RegExp(r'[0-9]');
      RegExp specialCharRegex = RegExp(r'[#\$%&*?@]');
      if (passValue == null || passValue.isEmpty) {
        return 'Input a valid password';
      } else if (passValue.length < 8) {
        return "Password must be at least 8 characters long.";
      } else if (!uppercaseRegex.hasMatch(passValue)) {
        return "Password must contain at least one uppercase letter.";
      } else if (!lowercaseRegex.hasMatch(passValue)) {
        return "Password must contain at least one lowercase letter.";
      } else if (!digitsRegex.hasMatch(passValue)) {
        return "Password must contain at least one number.";
      } else if (!specialCharRegex.hasMatch(passValue)) {
        return "Password must contain at least one special character (%&*?@).";
      } else {
        return null;
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
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/app_name.png',
                              height: 21.5.h,
                            ),
                            Image.asset(
                              'assets/images/documents.png',
                              height: 300.h,
                              // height: 21.5.h,
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Container(
                              width: 48,
                              height: 6,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xffFFF0F0),
                                    Color(0xffFFDFDF),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 21.h,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Forget Password?',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: textColor,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Not a Problem, let\'s sign you back in!',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: textColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 30.h,
                            ),
                            Form(
                              key: setNewPasswordFormKey,
                              child: Column(
                                children: [
                                  CustomTextFieldWidget(
                                    controller: _passwordController,
                                    keyboardType: TextInputType.text,
                                    obscureText: true,
                                    filled: false,
                                    readOnly: false,
                                    labelText: 'Enter Password',
                                    hintText: '********',
                                    autoValidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    maxLines: 1,
                                    validator: validatePass,
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  CustomTextFieldWidget(
                                    controller: _confirmPasswordController,
                                    keyboardType: TextInputType.text,
                                    obscureText: true,
                                    filled: false,
                                    readOnly: false,

                                    labelText: 'Confirm Password',
                                    hintText: '********',
                                    autoValidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    maxLines: 1,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please confirm your password';
                                      }
                                      if (value != _passwordController.text) {
                                        return 'Passwords do not match';
                                      }

                                      return null;
                                    },
                                    // validator: validateFirst,
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: Size(
                                            MediaQuery.of(context).size.width -
                                                50,
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
                                        Get.to(
                                          () => VerificationConfirmationScreen(
                                            path: 'login',
                                            nextScreenBuilder: () =>
                                                const Login(), // Builder function for the next page
                                          ),
                                        );
                                        // Navigator.pushReplacement(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) => const Login(),
                                        //   ),
                                        // );
                                        // if (setNewPasswordFormKey.currentState!
                                        //     .validate()) {
                                        //   // _authController.register({
                                        //   //   'fullname': widget.fullName,
                                        //   //   'email': widget.email,
                                        //   //   'password':
                                        //   //       _passwordController.text,
                                        //   //   'phone_number': widget.phoneNumber,
                                        //   //   'address': widget.address,
                                        //   // });
                                        // }
                                      },
                                      child: Text(
                                        'Continue',
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
                      ],
                    ),
                  ),
                  Center(
                    child: Container(
                      width: double.maxFinite,
                      margin: EdgeInsets.symmetric(vertical: 30.h),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 0.h),
                      alignment: Alignment.bottomCenter,
                      child: Wrap(
                        children: [
                          Text(
                            'Don\'t have an account? ',
                            style: GoogleFonts.poppins(
                              color: textColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(const Register());
                            },
                            child: Text(
                              'Sign Up',
                              style: GoogleFonts.poppins(
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
    );
  }
}

import 'dart:ui';

import 'package:eaglerides/presentation/screens/auth/login.dart';
import 'package:eaglerides/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/widgets.dart';
import '../loadingPage/loading.dart';
import '../noInternet/no_internet.dart';

class SetPasswordPage extends StatefulWidget {
  const SetPasswordPage({super.key});

  @override
  State<SetPasswordPage> createState() => _SetPasswordPageState();
}

class _SetPasswordPageState extends State<SetPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final setPasswordFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Secure your account',
                              textAlign: TextAlign.start,
                              style: GoogleFonts.dmSans(
                                color: textColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 30.h,
                            ),
                            Form(
                              key: setPasswordFormKey,
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
                                    // validator: validateFirst,
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
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const Login(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'Create Account',
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
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Center(
                  //   child: Container(
                  //     width: double.maxFinite,
                  //     margin: EdgeInsets.symmetric(vertical: 30.h),
                  //     padding:
                  //         EdgeInsets.symmetric(horizontal: 10.w, vertical: 0.h),
                  //     alignment: Alignment.bottomCenter,
                  //     child: Wrap(
                  //       children: [
                  //         Text(
                  //           'Already have an account? ',
                  //           style: GoogleFonts.dmSans(
                  //             color: textColor,
                  //             fontSize: 12,
                  //             fontWeight: FontWeight.w500,
                  //           ),
                  //         ),
                  //         GestureDetector(
                  //           onTap: () {},
                  //           child: Text(
                  //             'Login ',
                  //             style: GoogleFonts.dmSans(
                  //               color: backgroundColor,
                  //               fontSize: 12,
                  //               fontWeight: FontWeight.w600,
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

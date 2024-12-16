import 'package:eaglerides/presentation/screens/auth/forgot_pass_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../styles/styles.dart';
import '../../../widgets/widgets.dart';
import 'register.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _forgotPassController = TextEditingController();
  final forgotPassFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _forgotPassController.clear();
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
                          children: [
                            Image.asset(
                              'assets/images/app_name.png',
                              height: 21.5.h,
                            ),
                            Image.asset(
                              'assets/images/onboarding.png',
                              height: 300.h,
                            ),
                          ],
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
                              key: forgotPassFormKey,
                              child: Column(
                                children: [
                                  CustomTextFieldWidget(
                                    controller: _forgotPassController,
                                    obscureText: false,
                                    labelText: 'Enter email',
                                    filled: true,
                                    hintText: 'user@gmail.com',
                                    keyboardType: TextInputType.emailAddress,
                                    // textAlign: TextAlign.center,
                                    readOnly: false,
                                  ),
                                  SizedBox(
                                    height: 60.h,
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
                                        FocusScope.of(context).unfocus();
                                        // await verificationSuccessful();
                                        // Get.offAll(NavigationPage());
                                        Get.to(
                                          ForgotPassOtpScreen(
                                              email:
                                                  _forgotPassController.text),
                                        );
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 0.h),
                            alignment: Alignment.bottomCenter,
                            child: Wrap(
                              children: [
                                Text(
                                  'Dont\'t have an account? ',
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

import 'package:eaglerides/presentation/screens/auth/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../styles/styles.dart';
import '../../../widgets/widgets.dart';
import 'set_new_password.dart';
import 'verification_confirmation_screen.dart';

class ForgotPassOtpScreen extends StatefulWidget {
  const ForgotPassOtpScreen({super.key, required this.email});
  final String email;

  @override
  State<ForgotPassOtpScreen> createState() => _ForgotPassOtpScreenState();
}

class _ForgotPassOtpScreenState extends State<ForgotPassOtpScreen> {
  final TextEditingController _forgotPassOtpController =
      TextEditingController();
  final verifyCodeFormKey = GlobalKey<FormState>();

  bool isVerifying = false;
  bool isVerificationSuccessful = false;
  @override
  void dispose() {
    _forgotPassOtpController.clear();
    super.dispose();
  }

  verificationSuccessful() async {
    setState(() {
      isVerificationSuccessful = true;
    });
  }

  confirmVerifying() {
    setState(() {
      isVerifying = true;
    });
  }

  void handleClickButton() async {
    confirmVerifying();
    // Wait for 5 seconds
    await Future.delayed(const Duration(seconds: 5));
    verificationSuccessful();
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
                            'Verify your email',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: textColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'A verification code has been sent to',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: textColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            widget.email,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: backgroundColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          Form(
                            key: verifyCodeFormKey,
                            child: Column(
                              children: [
                                CustomTextFieldWidget(
                                  controller: _forgotPassOtpController,
                                  obscureText: false,
                                  labelText: 'Enter Verification code',
                                  filled: true,
                                  hintText: '000-000',
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                    decimal: false,
                                  ),
                                  textAlign: TextAlign.center,
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
                                      // handleClickButton();
                                      Get.to(
                                        () => VerificationConfirmationScreen(
                                          nextScreenBuilder: () =>
                                              SetNewPasswordScreen(
                                                  email: widget
                                                      .email), // Builder function for the next page
                                        ),
                                      );

                                      // await verificationSuccessful();
                                      // Get.offAll(NavigationPage());
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
      )),
    );
  }
}

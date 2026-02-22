import 'package:eaglerides/presentation/screens/auth/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../styles/styles.dart';
import '../../../widgets/widgets.dart';
import '../../controller/auth/auth_controller.dart';
import 'set_new_password.dart';

class ForgotPassOtpScreen extends StatefulWidget {
  const ForgotPassOtpScreen({super.key, required this.email});
  final String email;

  @override
  State<ForgotPassOtpScreen> createState() => _ForgotPassOtpScreenState();
}

class _ForgotPassOtpScreenState extends State<ForgotPassOtpScreen> {
  final AuthController _authController = Get.find<AuthController>();
  final TextEditingController _forgotPassOtpController =
      TextEditingController();
  final verifyCodeFormKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _forgotPassOtpController.clear();
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
                                      final otp =
                                          _forgotPassOtpController.text.trim();
                                      if (otp.isEmpty) {
                                        Get.snackbar(
                                          'Invalid OTP',
                                          'Please enter the verification code',
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor:
                                              const Color(0xffFF5500),
                                          colorText: Colors.white,
                                        );
                                        return;
                                      }

                                      _authController
                                          .verifyPasswordResetOtp(
                                        email: widget.email,
                                        otp: otp,
                                      )
                                          .then((_) {
                                        Get.to(
                                          () => SetNewPasswordScreen(
                                            email: widget.email,
                                            otp: otp,
                                          ),
                                        );
                                      });
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
                                SizedBox(height: 12.h),
                                TextButton(
                                  onPressed: () async {
                                    await _authController
                                        .resendOtp(widget.email);
                                  },
                                  child: Text(
                                    'Resend OTP',
                                    style: GoogleFonts.poppins(
                                      color: backgroundColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
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

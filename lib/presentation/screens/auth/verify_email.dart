import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../styles/styles.dart';
import '../../../widgets/widgets.dart';
import '../../controller/auth/auth_controller.dart';
import 'login.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key, required this.email});
  final String email;

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  final AuthController _authController = Get.find();
  final TextEditingController _codeController = TextEditingController();
  final verifyCodeFormKey = GlobalKey<FormState>();

  bool isVerifying = false;
  bool isVerificationSuccessful = false;
  @override
  void dispose() {
    _codeController.clear();
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
                                    controller: _codeController,
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
                                        if (_codeController.text
                                            .trim()
                                            .isEmpty) {
                                          showTopSnackBar(
                                            Overlay.of(context),
                                            const CustomSnackBar.error(
                                              message: 'Please enter your code',
                                            ),
                                          );
                                          return;
                                        } else if (_codeController.text
                                                .trim()
                                                .length !=
                                            6) {
                                          showTopSnackBar(
                                            Overlay.of(context),
                                            const CustomSnackBar.error(
                                              message:
                                                  'Please enter a valid 6 digits code',
                                            ),
                                          );
                                          return;
                                        } else {
                                          print(widget.email);
                                          print(_codeController.text.trim());
                                          _authController.verifyOtp(
                                              widget.email,
                                              _codeController.text.trim(),
                                              context);
                                        }
                                        // customSuccessDialog(context);
                                        // Get.to(
                                        //   () => VerificationConfirmationScreen(
                                        //     nextScreenBuilder: () =>
                                        //         const SetPasswordPage(
                                        //       fullName: '',
                                        //       email: '',
                                        //       phoneNumber: '',
                                        //       address: '',
                                        //     ), // Builder function for the next page
                                        //   ),
                                        // );
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) =>
                                        //         const SetPasswordPage(
                                        //       fullName: '',
                                        //       email: '',
                                        //       phoneNumber: '',
                                        //       address: '',
                                        //     ),
                                        //   ),
                                        // );
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
                                  SizedBox(height: 20.h),
                                  // Resend OTP Button
                                  Center(
                                    child: GestureDetector(
                                      onTap: () async {
                                        try {
                                          await _authController
                                              .resendOtp(widget.email);
                                        } catch (e) {
                                          print('Resend OTP error: $e');
                                        }
                                      },
                                      child: Text(
                                        'Didn\'t receive code? Resend OTP',
                                        style: GoogleFonts.poppins(
                                          color: backgroundColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          decoration: TextDecoration.underline,
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
                            'Already have an account? ',
                            style: GoogleFonts.poppins(
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
                              'Login',
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

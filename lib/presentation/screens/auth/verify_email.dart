import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../styles/styles.dart';
import '../../../widgets/widgets.dart';
import 'login.dart';
import 'set_password.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key, required this.email});
  final String email;

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  final TextEditingController _codeController = TextEditingController();
  final verifyCodeFormKey = GlobalKey<FormState>();

  bool isVerifying = false;
  bool isVerificationSuccessful = false;
  @override
  void dispose() {
    _codeController.clear();
    super.dispose();
  }

  verificationSuccessful() async {
    setState(() {
      isVerificationSuccessful = true;
    });
    print('hello');
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

  // @override
  // void initState() {
  //   if (isVerifying == true) {
  //     verificationSuccessful();
  //   }
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: (isVerifying == false)
            ? Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 20.h),
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
                                          keyboardType: const TextInputType
                                              .numberWithOptions(
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
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      50,
                                                  50),
                                              backgroundColor: textColor,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  50,
                                                ),
                                              ),
                                            ),
                                            onPressed: () {
                                              FocusScope.of(context).unfocus();
                                              handleClickButton();
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 0.h),
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
              )
            : (isVerificationSuccessful == false)
                ? Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: page,
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(9, 39, 127, .15),
                                  blurRadius: 30.0,
                                  spreadRadius: -4.0,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/images/app_name.png',
                                  height: 20.5.h,
                                  width: 50,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 30),
                                  child: Column(
                                    children: [
                                      CircularProgressIndicator(
                                        color: backgroundColor,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Confirming Verification code',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'This would take just a minute',
                                        style: GoogleFonts.poppins(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const SizedBox(),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: page,
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(9, 39, 127, .15),
                                  blurRadius: 30.0,
                                  spreadRadius: -4.0,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/images/app_name.png',
                                  height: 20.5.h,
                                  width: 50,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 30),
                                  child: Column(
                                    children: [
                                      const Icon(
                                        Icons.verified_outlined,
                                        color: Colors.green,
                                        size: 30,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Verification Successful',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
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
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(
                                MediaQuery.of(context).size.width - 50, 50),
                            backgroundColor: textColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                50,
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SetPasswordPage(
                                  fullName: '',
                                  email: '',
                                  phoneNumber: '',
                                  address: '',
                                ),
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
                      ],
                    ),
                  ),
      ),
    );
  }
}

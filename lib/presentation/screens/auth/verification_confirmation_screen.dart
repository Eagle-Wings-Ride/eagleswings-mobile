import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../styles/styles.dart';

class VerificationConfirmationScreen extends StatefulWidget {
  const VerificationConfirmationScreen({
    super.key,
    required this.nextScreenBuilder,
    this.path,
  });
  final Widget Function() nextScreenBuilder;
  final String? path;

  @override
  State<VerificationConfirmationScreen> createState() =>
      _VerificationConfirmationScreenState();
}

class _VerificationConfirmationScreenState
    extends State<VerificationConfirmationScreen> {
  bool isVerificationSuccessful = false;

  verificationSuccessful() async {
    setState(() {
      isVerificationSuccessful = true;
    });
  }

  @override
  void initState() {
    super.initState(); // Always call super first in initState

    // Wait for 5 seconds, then call verificationSuccessful
    Future.delayed(const Duration(seconds: 5), () {
      verificationSuccessful();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (isVerificationSuccessful == false)
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
                      minimumSize:
                          Size(MediaQuery.of(context).size.width - 50, 50),
                      backgroundColor: textColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          50,
                        ),
                      ),
                    ),
                    onPressed: () {
                      Get.to(widget.nextScreenBuilder);
                    },
                    child: Text(
                      (widget.path == 'login') ? 'Login' : 'Continue',
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
    );
  }
}

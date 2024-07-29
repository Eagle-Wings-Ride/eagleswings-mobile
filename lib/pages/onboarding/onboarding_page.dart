import 'package:eaglerides/presentation/screens/auth/login.dart';
import 'package:eaglerides/pages/auth/register.dart';
import 'package:eaglerides/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
        centerTitle: true,
        title: Image.asset(
          'assets/images/app_name.png',
          height: 21.5.h,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 40.h,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      'assets/images/onboarding.png',
                      height: 340.h,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 35.w, vertical: 0),
                      child: Column(
                        children: [
                          Text(
                            'Welcome to Eagle’s Rides',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.dmSans(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: textColor,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Text(
                            'Earn While They Learn: Make Money on the School Run!',
                            style: GoogleFonts.dmSans(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              // height: 1.5714,
                              color: textColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          // SizedBox(height: 85.h),
                        ],
                      ),
                    ),
                    // SizedBox(height: 50.h),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Login(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        elevation: 0,
                        textStyle: GoogleFonts.dmSans(
                            color: textColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 12),
                      ),
                      child: Text(
                        "Login",
                        style: GoogleFonts.dmSans(
                            color: textColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 12),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Register(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: textColor,
                        minimumSize: const Size(50, 50),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            20,
                          ),
                        ),
                      ),
                      child: Text(
                        "Sign Up",
                        style: GoogleFonts.dmSans(
                          color: buttonText,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
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
    );
  }
}

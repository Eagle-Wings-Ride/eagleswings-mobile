import 'package:eaglerides/pages/auth/register.dart';
import 'package:eaglerides/presentation/controller/auth/auth_controller.dart';
import 'package:eaglerides/presentation/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../styles/styles.dart';
import '../../../widgets/widgets.dart';
import '../../../navigation_page.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final setPasswordFormKey = GlobalKey<FormState>();
  final AuthController _authController = Get.find();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                              'assets/images/onboarding.png',
                              height: 300.h,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome Back',
                              textAlign: TextAlign.start,
                              style: GoogleFonts.dmSans(
                                color: textColor,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Let’s sign you back in!',
                              textAlign: TextAlign.start,
                              style: GoogleFonts.dmSans(
                                color: textColor,
                                fontSize: 14,
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
                                    controller: _emailController,
                                    keyboardType: TextInputType.text,
                                    obscureText: false,
                                    filled: false,
                                    readOnly: false,

                                    labelText: 'Enter Email',
                                    hintText: 'user@email.com',
                                    autoValidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    maxLines: 1,
                                    // validator: validateFirst,
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
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
                                        // FocusScope.of(context).unfocus();
                                        // if (_emailController.text.isNotEmpty &&
                                        //     _passwordController
                                        //         .text.isNotEmpty &&
                                        //     GetUtils.isEmail(
                                        //         _emailController.text)) {
                                        //   _authController.loginUser(
                                        //     _emailController.text,
                                        //     _passwordController.text,
                                        //   );
                                        // } else {
                                        //   Get.snackbar(
                                        //       "error", "invalid values!");
                                        // }
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const NavigationPage(),
                                            ),
                                            (route) => false);
                                      },
                                      child: Text(
                                        'Login',
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
                            style: GoogleFonts.dmSans(
                              color: textColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(Register());
                            },
                            child: Text(
                              'Sign Up',
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
    );
  }
}
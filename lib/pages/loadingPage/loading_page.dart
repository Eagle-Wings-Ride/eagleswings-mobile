import 'dart:async';

import 'package:eaglerides/navigation_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/network_checker/network_checker_controller.dart';
import '../../functions/function.dart';
import '../../presentation/controller/auth/auth_controller.dart';
import '../../styles/styles.dart';
import '../../presentation/screens/auth/login.dart';
import '../noInternet/no_internet.dart';
import '../../injection_container.dart' as di;

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  final AuthController _authController = Get.put(di.sl<AuthController>());
  final NetWorkStatusChecker _netWorkStatusChecker =
      Get.put(di.sl<NetWorkStatusChecker>());
  String dot = '.';
  var demopage = TextEditingController();

  @override
  void initState() {
    _netWorkStatusChecker.updateConnectionStatus();
    _authController.checkIsSignIn();
    Timer(const Duration(seconds: 3), () async {
      if (_authController.isSignIn.value) {
        // print(_authController.isSignIn.value);
        if (await _authController.checkUserStatus()) {
          Get.off(() => const NavigationPage());
        } else {
          Get.off(() => const Login());
        }
        Get.off(() => const NavigationPage());
      } else {
        Get.off(() => const Login());
      }
    });

    super.initState();
  }

//get language json and data saved in local (bearer token , choosen language) and find users current status
  // getLanguageDone() async {
  //   await getDetailsOfDevice();
  //   if (internet == true) {
  //     var val = await getLocalData();

  //     if (val == '3') {
  //       if (userRequestData.isNotEmpty &&
  //           userRequestData['is_completed'] == 1) {
  //         //invoice page of ride
  //         Navigator.pushAndRemoveUntil(
  //             context,
  //             MaterialPageRoute(builder: (context) => const Invoice()),
  //             (route) => false);
  //       } else if (userRequestData.isNotEmpty &&
  //           userRequestData['is_completed'] != 1) {
  //         //searching ride page
  //         Navigator.pushAndRemoveUntil(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (context) => const BookingConfirmation()),
  //             (route) => false);
  //         mqttForUser();
  //       } else {
  //         //home page
  //         Navigator.pushAndRemoveUntil(
  //             context,
  //             MaterialPageRoute(builder: (context) => const NavigationPage()),
  //             (route) => false);
  //       }
  //     } else if (val == '2') {
  //       Future.delayed(const Duration(seconds: 2), () {
  //         //login page
  //         Navigator.pushReplacement(
  //             context, MaterialPageRoute(builder: (context) => const Login()));
  //       });
  //     } else {
  //       Future.delayed(const Duration(seconds: 2), () {
  //         //choose language page
  //         Navigator.pushReplacement(context,
  //             MaterialPageRoute(builder: (context) => const OnboardingPage()));
  //       });
  //     }
  //   } else {
  //     setState(() {});
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Material(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: media.height * 1,
              width: media.width * 1,
              decoration: BoxDecoration(
                color: page,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(media.width * 0.01),
                    width: media.width * 0.429,
                    height: media.width * 0.429,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/app_logo.png'),
                          fit: BoxFit.contain),
                    ),
                  ),
                ],
              ),
            ),

            //no internet
            (internet == false)
                ? Positioned(
                    top: 0,
                    child: NoInternet(
                      onTap: () {
                        setState(() {
                          internetTrue();
                          // getLanguageDone();
                        });
                      },
                    ))
                : Container(),
          ],
        ),
      ),
    );
  }
}

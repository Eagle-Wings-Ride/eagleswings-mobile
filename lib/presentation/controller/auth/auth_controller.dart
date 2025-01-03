import 'package:eaglerides/domain/usecases/eagle_rides_auth_check_user_usecase.dart';
import 'package:eaglerides/domain/usecases/eagle_rides_auth_is_signed_in_usecase.dart';
import 'package:eaglerides/domain/usecases/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../domain/usecases/login_user.dart';
import '../../../navigation_page.dart';
import '../../screens/auth/verify_email.dart';
import '../../screens/ride/widget/custom_loader.dart';

class AuthController extends GetxController {
  final EagleRidesAuthIsSignInUseCase eagleRidesAuthIsSignInUseCase;
  final EagleRidesLoginUserUseCase eagleRidesLoginUserUseCase;
  final EagleRidesAuthCheckUserUseCase eagleRidesAuthCheckUserUseCase;
  final EagleRidesRegisterUseCase eagleRidesRegisterUseCase;
  // final EagleRidesAuthGetUserUidUseCase eagleRidesAuthGetUserUidUseCase;

  var isSignIn = false.obs;

  AuthController({
    required this.eagleRidesAuthIsSignInUseCase,
    required this.eagleRidesLoginUserUseCase,
    required this.eagleRidesAuthCheckUserUseCase,
    required this.eagleRidesRegisterUseCase,
    // required this.eagleRidesAuthGetUserUidUseCase,
  });

  checkIsSignIn() async {
    bool eagleRideAuthIsSignIn = await eagleRidesAuthIsSignInUseCase.call();
    isSignIn.value = eagleRideAuthIsSignIn;
  }

  Future<bool> checkUserStatus() async {
    var box = await Hive.openBox('authBox');
    final userId = box.get('user_id');
    if (userId != null) {
      return await eagleRidesAuthCheckUserUseCase(userId);
    }
    return false;
  }
  // String riderId = await eagleRidesAuthGetUserUidUseCase.call();
  // return eagleRidesAuthCheckUserUseCase.call(riderId);

  loginUser(String email, String password, context) async {
    try {
      final token = await eagleRidesLoginUserUseCase.call(email, password);
      print(token);
      // Save token or navigate to another page
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.success(
          message: 'Login Successful',
        ),
      );
      // Get.snackbar("Success", "Login Successful");
      Get.offAll(const NavigationPage());
      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => const NavigationPage(),
      //     ),
      //     (route) => false);
    } catch (e) {
      print(e);
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: e.toString(),
        ),
      );
      // Get.snackbar("Login Failed", e.toString());
    }
  }

  register(Map<String, dynamic> requestBody, context) async {
    print('requestBody');
    print(requestBody);
    try {
      EasyLoading.show(
        indicator: const CustomLoader(),
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
      );
      final response = await eagleRidesRegisterUseCase.call(requestBody);
      debugPrint(response);
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.success(
          message: 'Registration Successful',
        ),
      );
      EasyLoading.dismiss();
      Get.to(
        VerifyEmail(
          email: requestBody['email'],
        ),
      );
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: e.toString(),
        ),
      );
      // Get.snackbar('Registration Failed', e.toString());
    }
  }
}

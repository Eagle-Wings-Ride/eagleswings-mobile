import 'package:eaglerides/domain/usecases/eagle_rides_auth_check_user_usecase.dart';
import 'package:eaglerides/domain/usecases/eagle_rides_auth_get_userid_usecase.dart';
import 'package:eaglerides/domain/usecases/eagle_rides_auth_is_signed_in_usecase.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../domain/usecases/login_user.dart';

class AuthController extends GetxController {
  final EagleRidesAuthIsSignInUseCase eagleRidesAuthIsSignInUseCase;
  final EagleRidesLoginUserUseCase eagleRidesLoginUserUseCase;
  final EagleRidesAuthCheckUserUseCase eagleRidesAuthCheckUserUseCase;
  // final EagleRidesAuthGetUserUidUseCase eagleRidesAuthGetUserUidUseCase;

  var isSignIn = false.obs;

  AuthController({
    required this.eagleRidesAuthIsSignInUseCase,
    required this.eagleRidesLoginUserUseCase,
    required this.eagleRidesAuthCheckUserUseCase,
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

  loginUser(String email, String password) async {
    try {
      final token = await eagleRidesLoginUserUseCase.call(email, password);
      // Save token or navigate to another page
      Get.snackbar("Login Successful", "Token: $token");
    } catch (e) {
      Get.snackbar("Login Failed", e.toString());
    }
  }
}

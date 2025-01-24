import 'package:eaglerides/domain/usecases/eagle_rides_auth_check_user_usecase.dart';
import 'package:eaglerides/domain/usecases/eagle_rides_auth_is_signed_in_usecase.dart';
import 'package:eaglerides/domain/usecases/eagle_rides_auth_otp_verification_usecase.dart';
import 'package:eaglerides/domain/usecases/eagle_rides_auth_sign_out_usecase.dart';
import 'package:eaglerides/domain/usecases/getUserUseCase.dart';
import 'package:eaglerides/domain/usecases/register.dart';
import 'package:eaglerides/presentation/screens/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../data/models/user_model.dart';
import '../../../domain/usecases/login_user.dart';
import '../../../navigation_page.dart';
import '../../../widgets/widgets.dart';
import '../../screens/auth/verify_email.dart';
import '../../screens/ride/widget/custom_loader.dart';

class AuthController extends GetxController {
  final EagleRidesAuthIsSignInUseCase eagleRidesAuthIsSignInUseCase;
  final EagleRidesLoginUserUseCase eagleRidesLoginUserUseCase;
  final EagleRidesAuthCheckUserUseCase eagleRidesAuthCheckUserUseCase;
  final EagleRidesRegisterUseCase eagleRidesRegisterUseCase;
  final EagleRidesAuthOtpVerificationUseCase
      eagleRidesAuthOtpVerificationUseCase;
  final EagleRidesAuthSignOutUseCase eagleRidesAuthSignOutUseCase;
  final GetUserUsecase getUserUsecase;

  var user = Rx<UserModel?>(null);

  var isSignIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    // loadUser(); // Load user data when the controller is initialized
  }

  AuthController({
    required this.eagleRidesAuthIsSignInUseCase,
    required this.eagleRidesLoginUserUseCase,
    required this.eagleRidesAuthCheckUserUseCase,
    required this.eagleRidesRegisterUseCase,
    required this.eagleRidesAuthOtpVerificationUseCase,
    required this.eagleRidesAuthSignOutUseCase,
    required this.getUserUsecase,
    // required this.eagleRidesAuthGetUserUidUseCase,
  });

  Future<String?> getToken() async {
    final box = await Hive.openBox('authBox');
    return box.get('auth_token'); // Retrieve the token from storage
  }

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
    final box = await Hive.openBox('authBox');
    final token = box.get('auth_token');
    // Clear token and navigate to login
    await box.delete('auth_token'); // Explicitly delete the auth token
    await box.clear();
    try {
      EasyLoading.show(
        indicator: const CustomLoader(),
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
      );
      final token = await eagleRidesLoginUserUseCase.call(email, password);
      print(token);
      await loadUser();
      // Save token or navigate to another page
      EasyLoading.dismiss();
      // showTopSnackBar(
      //   Overlay.of(context),
      //   const CustomSnackBar.success(
      //     message: 'Login Successful',
      //   ),
      // );
      Get.offAll(const NavigationPage());
    } catch (e) {
      EasyLoading.dismiss();
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

  logout(context) async {
    try {
      EasyLoading.show(
        indicator: const CustomLoader(),
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
      );
      await eagleRidesAuthSignOutUseCase.call();
      user.value = null;

      // Ensure token is cleared before navigating
      final box = await Hive.openBox('authBox');
      final token = box.get('auth_token');
      print('Token after logout: $token'); // Ensure it's null or removed

      EasyLoading.dismiss();
      Get.offAll(const Login());
    } catch (e) { 
      // print(e);
      EasyLoading.dismiss();
      // print(e);
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

  verifyOtp(String email, String otp, context) async {
    try {
      EasyLoading.show(
        indicator: const CustomLoader(),
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
      );
      // final token = await eagleRidesAuthOtpVerificationUseCase.call(email, otp);
      // print(token);

      final response =
          await eagleRidesAuthOtpVerificationUseCase.call(email, otp);
      print('printing respone ...');
      debugPrint(response);
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.success(
          message: 'OTP Verification Successful',
        ),
      );
      EasyLoading.dismiss();

      customSuccessDialog(context);
      // Get.to(const NavigationPage());
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: e.toString(),
        ),
      );
      // Get.snackbar('OTP Verification Failed', e.toString());
    }
  }

  // Method to update the user data
  void setUser(UserModel userModel) {
    user.value = userModel; // This updates the observable user.
    _saveUser(userModel); // Optionally save the user info to local storage
  }

  // Load user data from Hive storage (if available)
  Future<void> loadUser() async {
    var box = await Hive.openBox('authBox');
    String? token = box.get('auth_token'); // Fetch the auth token

    if (token != null) {
      // Token exists, attempt to load user data from storage
      var userInfo = box.get('user_info');
      print('userInfo from storage');
      print(userInfo);
      if (userInfo != null) {
        // If user data exists, update the user value
        user.value = UserModel.fromMap(Map<String, dynamic>.from(userInfo));
        update();
      } else {
        // Fetch user info from the API (if it's not available in local storage)
        try {
          final dynamic response = await getUserUsecase.call();
          print('response');
          print(response);

          // Ensure the response is of the correct type
          if (response is Map<dynamic, dynamic>) {
            final userInfo = Map<String, dynamic>.from(response);
            print('userInfo');
            print(userInfo);
            setUser(UserModel.fromJson(userInfo));
            update();
          } else {
            throw Exception('Invalid response type from getUserUsecase.call');
          }
        } catch (e) {
          print("Error fetching user data: $e");
          if (e.toString().contains('Unauthorized')) {
            Get.offAll(const Login());
          }
        }
      }
    } else {
      // No token found, user is not logged in, redirect to login screen
      Get.offAll(const Login());
    }
  }

  // Save user data to Hive storage (for persistence)
  Future<void> _saveUser(UserModel userModel) async {
    var box = await Hive.openBox('authBox');
    await box.put(
        'user_info', userModel.toJson()); // Save the user data as JSON
  }

  getUser(context) async {
    try {
      EasyLoading.show(
        indicator: const CustomLoader(),
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
      );
      final userInfo = await getUserUsecase.call();
      print(userInfo);
      UserModel userModel = UserModel.fromJson(userInfo);
      setUser(userModel);
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      print(e);
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: e.toString(),
        ),
      );
    }
  }
}

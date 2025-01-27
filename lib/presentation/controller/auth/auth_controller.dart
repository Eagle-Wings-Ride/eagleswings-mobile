import 'package:eaglerides/domain/usecases/add_child_usecase.dart';
import 'package:eaglerides/domain/usecases/eagle_rides_auth_check_user_usecase.dart';
import 'package:eaglerides/domain/usecases/eagle_rides_auth_is_signed_in_usecase.dart';
import 'package:eaglerides/domain/usecases/eagle_rides_auth_otp_verification_usecase.dart';
import 'package:eaglerides/domain/usecases/eagle_rides_auth_sign_out_usecase.dart';
import 'package:eaglerides/domain/usecases/fetch_children_usecase.dart';
import 'package:eaglerides/domain/usecases/fetch_recent_rides_usecase.dart';
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

import '../../../data/models/book_rides_model.dart';
import '../../../data/models/child_model.dart';
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
  final AddChildUseCase addChildUseCase;
  final FetchChildrenUseCase fetchChildrenUseCase;
  final FetchRecentRidesUseCase fetchRecentRidesUseCase;

  var user = Rx<UserModel?>(null);
  RxList<Child> children = <Child>[].obs;
  var recentRides = <Booking>[].obs;

  var isSignIn = false.obs;

  // @override
  // void onInit() {
  //   super.onInit();
  //   // loadUser(); // Load user data when the controller is initialized
  // }

  AuthController({
    required this.eagleRidesAuthIsSignInUseCase,
    required this.eagleRidesLoginUserUseCase,
    required this.eagleRidesAuthCheckUserUseCase,
    required this.eagleRidesRegisterUseCase,
    required this.eagleRidesAuthOtpVerificationUseCase,
    required this.eagleRidesAuthSignOutUseCase,
    required this.getUserUsecase,
    required this.addChildUseCase,
    required this.fetchChildrenUseCase,
    required this.fetchRecentRidesUseCase,
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

  addChild(Map<String, dynamic> requestBody, context) async {
    print('requestBody');
    print(requestBody);
    try {
      EasyLoading.show(
        indicator: const CustomLoader(),
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
      );
      final response = await addChildUseCase.call(requestBody);
      debugPrint(response);
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.success(
          message: 'Child Registration Successful',
        ),
      );
      EasyLoading.dismiss();
      Get.back();
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: e.toString(),
        ),
      );
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

  void setChildren(List<Child> childModels) {
    children
        .assignAll(childModels); // Update the observable list with new children
    _saveChildren(childModels); // Optionally save to local storage
  }

  void _saveChildren(List<Child> childModels) async {
    var box = await Hive.openBox('childrenBox');
    // Save the children list to local storage
    await box.put('children', childModels.map((e) => e.toJson()).toList());
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

  Future<void> fetchChildren() async {
    var box = await Hive.openBox('authBox');
    String? token = box.get('auth_token');
    var childrenBox = await Hive.openBox('childrenBox');

    if (token != null) {
      // Token exists, attempt to load user data from storage
      var childrenInfo = childrenBox.get('children');
      // print('childrenInfo from storage');
      // print(childrenInfo);

      if (childrenInfo != null) {
        // Ensure childrenInfo is a list of maps (dynamic type issue)
        if (childrenInfo is List) {
          // Map the childrenInfo to List<Child>
          List<Child> childrenList = childrenInfo
              .map<Child>((childJson) =>
                  Child.fromJson(Map<String, dynamic>.from(childJson)))
              .toList();
          // print(childrenList);

          // Update the reactive list with the deserialized data
          children.assignAll(childrenList);
          update();
        } else {
          // Handle unexpected structure of the childrenInfo
          print(
              'Error: The stored children data is not in the expected format.');
        }
      } else {
        // If no children data found, fetch from API
        try {
          EasyLoading.show(
            indicator: const CustomLoader(),
            maskType: EasyLoadingMaskType.black,
            dismissOnTap: false,
          );

          final userId =
              user.value?.id; // Get the user ID (check if it's available)
          if (userId == null) {
            throw Exception('User ID not found');
          }

          // Fetch children from the API
          final fetchedChildren = await fetchChildrenUseCase.call(userId);

          // Map the API response to a list of Child objects
          List<Child> childrenList = fetchedChildren
              .map<Child>((childJson) => Child.fromJson(childJson))
              .toList();

          // Save the children to local storage
          childrenBox.put('children', fetchedChildren);

          // Update the reactive list with the fetched children
          children.assignAll(childrenList);
          // setChildren(childrenList); // If necessary, use this method to set the children
        } catch (e) {
          print("Error fetching children: $e");
          Get.snackbar(
            'Error',
            e.toString(),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        } finally {
          EasyLoading.dismiss();
        }
      }
    } else {
      // No token found, user is not logged in, redirect to login screen
      Get.offAll(const Login());
    }
  }

  Future<void> fetchRecentRides(String childId) async {
    // var rideBox = await Hive.openBox('ridesBox');
    var box = await Hive.openBox('authBox');
    String? token = box.get('auth_token');

    if (token != null) {
      try {
        EasyLoading.show(
          indicator: const CustomLoader(),
          maskType: EasyLoadingMaskType.black,
          dismissOnTap: false,
        );

        // var lastSyncTimestamp = rideBox.get('lastSyncTimestamp',
        //     defaultValue: DateTime.now()
        //         .subtract(const Duration(days: 1))
        //         .millisecondsSinceEpoch);

        // bool shouldFetchFromApi =
        //     DateTime.now().millisecondsSinceEpoch - lastSyncTimestamp >
        //         const Duration(hours: 1).inMilliseconds;

        List<Booking> recentBookings = [];

        // if (shouldFetchFromApi) {
        //   var fetchedRides = await fetchRecentRidesUseCase.call(childId);
        //   recentBookings = fetchedRides
        //       .map((rideJson) => Booking.fromJson(rideJson))
        //       .toList();

        //   recentBookings =
        //       recentBookings.where((ride) => ride.status != 'ongoing').toList();
        //   recentBookings.sort((a, b) => b.startDate.compareTo(a.startDate));

        //   await rideBox.put('recentRides', recentBookings);
        //   await rideBox.put(
        //       'lastSyncTimestamp', DateTime.now().millisecondsSinceEpoch);
        // } else {
        //   recentBookings = rideBox.get('recentRides', defaultValue: []);
        // }

        var fetchedRides = await fetchRecentRidesUseCase.call(childId);
        print('fetchedRides');
        print(fetchedRides);
        recentBookings =
            fetchedRides.map((rideJson) => Booking.fromJson(rideJson)).toList();

        recentBookings =
            recentBookings.where((ride) => ride.status != 'ongoing').toList();
        recentBookings.sort((a, b) => b.startDate.compareTo(a.startDate));
        recentRides.assignAll(recentBookings);
      } catch (e) {
        print("Error fetching recent rides here: $e");
        Get.snackbar(
          'Error',
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        EasyLoading.dismiss();
      }
    } else {
      Get.offAll(const Login());
    }
  }
}

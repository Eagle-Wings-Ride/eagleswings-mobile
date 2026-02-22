import 'dart:convert';

import 'package:eaglerides/domain/usecases/add_child_usecase.dart';
import 'package:eaglerides/domain/usecases/book_ride_usecase.dart';
import 'package:eaglerides/domain/usecases/eagle_rides_auth_check_user_usecase.dart';
import 'package:eaglerides/domain/usecases/eagle_rides_auth_is_signed_in_usecase.dart';
import 'package:eaglerides/domain/usecases/eagle_rides_auth_otp_verification_usecase.dart';
import 'package:eaglerides/domain/usecases/eagle_rides_auth_sign_out_usecase.dart';
import 'package:eaglerides/domain/usecases/fetch_children_usecase.dart';
import 'package:eaglerides/domain/usecases/fetch_rates_usecase.dart';
import 'package:eaglerides/domain/usecases/fetch_recent_rides_usecase.dart';
import 'package:eaglerides/domain/usecases/delete_user_usecase.dart';
import 'package:eaglerides/domain/usecases/getUserUseCase.dart';
import 'package:eaglerides/domain/usecases/register.dart';
import 'package:eaglerides/presentation/screens/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../data/datasource/auth_remote_data_source.dart';
import '../../../data/models/book_rides_model.dart';
import '../../../data/models/child_model.dart';
import '../../../data/models/child_upsert_request.dart';
import '../../../data/models/payment_models.dart';
import '../../../data/models/user_model.dart';
import '../../../domain/usecases/fetch_all_rides_usecase.dart';
import '../../../domain/usecases/login_user.dart';
import '../../../navigation_page.dart';
import '../../../widgets/global_loader.dart';
import '../../../widgets/widgets.dart';
import '../../screens/auth/verify_email.dart';
import '../../screens/ride/payment_screen.dart';

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
  final BookRideUseCase bookRideUseCase;
  final FetchRatesUsecase fetchRatesUsecase;
  final FetchAllRidesUseCase fetchAllRidesUseCase;
  final DeleteUserUseCase deleteUserUseCase;
  // final CancelRideUseCase cancelRideUseCase;

  var user = Rx<UserModel?>(null);
  RxList<Child> children = <Child>[].obs;
  var recentRides = <Booking>[].obs;

  var isSignIn = false.obs;

  var rates = Rxn<Map<String, dynamic>>(); // Use Rxn (nullable observable)

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
    required this.bookRideUseCase,
    required this.fetchRatesUsecase,
    required this.fetchAllRidesUseCase,
    required this.deleteUserUseCase,
    // required this.cancelRideUseCase,
    // required this.eagleRidesAuthGetUserUidUseCase,
  });

  final RxBool isLoadingRides = false.obs;

  Future<String?> getToken() async {
    final box = await Hive.openBox('authBox');
    return box.get('auth_token'); // Retrieve the token from storage
  }

  checkIsSignIn() async {
    bool eagleRideAuthIsSignIn = await eagleRidesAuthIsSignInUseCase.call();
    isSignIn.value = eagleRideAuthIsSignIn;
  }

  Future<bool> checkUserStatus() async {
    try {
      var box = await Hive.openBox('authBox');
      final token = box.get('auth_token');

      // If no token, user is not logged in
      if (token == null) {
        print('No auth token found, user not signed in.');
        return false;
      }

      // Token exists, try to fetch user data to validate it
      final userResponse = await getUserUsecase.call();
      if (userResponse.isNotEmpty) {
        // User data fetched successfully, token is valid
        final userInfo = UserModel.fromMap(userResponse);
        user.value = userInfo;

        // Store user info in local storage for future use
        await box.put('user_info', userResponse);

        update();
        print('User status valid: ${userInfo.name}');
        return true;
      } else {
        print('Could not fetch user data, clearing auth.');
        await box.delete('auth_token');
        return false;
      }
    } catch (e) {
      print('Error checking user status: $e');
      // If token is invalid, the API will throw and we should log out
      var box = await Hive.openBox('authBox');
      await box.delete('auth_token');
      return false;
    }
  }

  loginUser(String email, String password, context) async {
    final box = await Hive.openBox('authBox');
    // Clear token and navigate to login
    await box.delete('auth_token'); // Explicitly delete the auth token
    await box.clear();
    user.value = null;
    user.refresh();
    try {
      GlobalLoader().show();

      final token = await eagleRidesLoginUserUseCase.call(email, password);
      print(token);
      await loadUser();
      // Save token or navigate to another page
      GlobalLoader().hide();

      Get.offAll(const NavigationPage());
    } catch (e) {
      GlobalLoader().hide();
      // EasyLoading.dismiss();
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
      GlobalLoader().show();

      await eagleRidesAuthSignOutUseCase.call();
      final box = await Hive.openBox('authBox');
      final rateBox = await Hive.openBox('rateBox');
      final childrenBox = await Hive.openBox('childrenBox');
      await box.clear();
      await rateBox.clear();
      await childrenBox.clear();
      user.value = null;
      user.refresh();

      // Ensure token is cleared before navigating
      final token = box.get('auth_token');
      print('Token after logout: $token'); // Ensure it's null or removed
      print('User state after logout: ${user.value}');
      print('Token after logout: ${box.get("auth_token")}');

      GlobalLoader().hide();
      // EasyLoading.dismiss();
      Get.offAll(const Login());
    } catch (e) {
      // print(e);
      GlobalLoader().hide();
      // EasyLoading.dismiss();
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
      GlobalLoader().show();

      final response = await eagleRidesRegisterUseCase.call(requestBody);
      debugPrint(response);
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.success(
          message: 'Registration Successful',
        ),
      );
      GlobalLoader().hide();
      // EasyLoading.dismiss();
      Get.to(
        VerifyEmail(
          email: requestBody['email'],
        ),
      );
    } catch (e) {
      print(e);
      GlobalLoader().hide();
      // EasyLoading.dismiss();
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: e.toString(),
        ),
      );
      // Get.snackbar('Registration Failed', e.toString());
    }
  }

  Future<void> addChild(
      ChildUpsertRequest requestBody, BuildContext context) async {
    print('requestBody');
    print(requestBody);
    try {
      GlobalLoader().show();

      await addChildUseCase.call(requestBody);
      await refreshChildren();
      // debugPrint(response);
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.success(
          message: 'Child Registration Successful',
        ),
      );
      GlobalLoader().hide();
      // EasyLoading.dismiss();
      Get.back();
    } catch (e) {
      print(e);
      GlobalLoader().hide();
      // EasyLoading.dismiss();
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
      GlobalLoader().show();
      // EasyLoading.show(
      //   indicator: const CustomLoader(),
      //   maskType: EasyLoadingMaskType.clear,
      //   dismissOnTap: false,
      // );
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
      GlobalLoader().hide();
      // EasyLoading.dismiss();

      customSuccessDialog(context);
      // Get.to(const NavigationPage());
    } catch (e) {
      print(e);
      GlobalLoader().hide();
      // EasyLoading.dismiss();
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
      GlobalLoader().show();
      // EasyLoading.show(
      //   indicator: const CustomLoader(),
      //   maskType: EasyLoadingMaskType.clear,
      //   dismissOnTap: false,
      // );
      final userInfo = await getUserUsecase.call();
      print(userInfo);
      UserModel userModel = UserModel.fromJson(userInfo);
      setUser(userModel);
      GlobalLoader().hide();
      // EasyLoading.dismiss();
    } catch (e) {
      GlobalLoader().hide();
      // EasyLoading.dismiss();
      print(e);
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> fetchRatesData() async {
    try {
      final newRates = await fetchRatesUsecase.call();
      rates.value = newRates; // Update observable
      saveRatesToHive(newRates); // Save to Hive
    } catch (e) {
      print('Error fetching rates: $e');
    }
  }

  void saveRatesToHive(Map<String, dynamic> newRates) async {
    var box = await Hive.openBox('ratesBox');
    box.put('rates', newRates);
    box.put('createdAt', newRates['createdAt']);
  }

  void loadRatesFromHive() async {
    var box = await Hive.openBox('ratesBox');
    final storedRates = box.get('rates');
    final storedCreatedAt = box.get('createdAt');

    if (storedRates != null && storedCreatedAt != null) {
      rates.value = storedRates; // Use existing stored data
    } else {
      await fetchRatesData(); // Fetch new data if not found
    }
  }

  Future<void> fetchChildren() async {
    var box = await Hive.openBox('authBox');
    String? token = box.get('auth_token');
    var childrenBox = await Hive.openBox('childrenBox');

    if (token != null) {
      var cachedChildren = childrenBox.get('children');

      if (cachedChildren != null && cachedChildren is List) {
        // Load cached children for instant UI update
        List<Child> cachedList = cachedChildren
            .map<Child>((childJson) =>
                Child.fromJson(Map<String, dynamic>.from(childJson)))
            .toList();

        children.assignAll(cachedList);
        update();
      } else {
        // If no cached data, fetch from API immediately
        await refreshChildren();
      }
    } else {
      Get.offAll(const Login());
    }
  }

// 🔹 Call this after creating a new child to refresh the list
  Future<void> refreshChildren() async {
    try {
      GlobalLoader().show();

      await Hive.deleteBoxFromDisk('childrenBox'); // Clear outdated local data
      var childrenBox = await Hive.openBox('childrenBox');

      // Fetch new children from API
      final fetchedChildren = await fetchChildrenUseCase.call();
      List<Child> newChildrenList = fetchedChildren
          .map<Child>((childJson) => Child.fromJson(childJson))
          .toList();

      // Save the updated children list to Hivexx
      await childrenBox.put('children', fetchedChildren);

      // Update UI with the new data
      children.assignAll(newChildrenList);
      update();
    } catch (e) {
      print("Error refreshing children: $e");
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      GlobalLoader().hide();
      // EasyLoading.dismiss();
    }
  }

  Future<void> fetchRecentRides(String childId) async {
    // var rideBox = await Hive.openBox('ridesBox');
    var box = await Hive.openBox('authBox');
    String? token = box.get('auth_token');

    if (token != null) {
      try {
        GlobalLoader().show();

        List<Booking> recentBookings = [];

        var fetchedRides = await fetchRecentRidesUseCase.call(childId);
        print('fetchedRides');
        print(fetchedRides);
        recentBookings = fetchedRides
            .map((rideJson) => Booking.fromJson(rideJson))
            .where((ride) => ride.status != 'ongoing')
            .toList();

        // recentBookings =
        //     recentBookings.where((ride) => ride.status != 'ongoing').toList();
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
        GlobalLoader().hide();
        // EasyLoading.dismiss();
      }
    } else {
      Get.offAll(const Login());
    }
  }

// REPLACE YOUR bookRide METHOD WITH THIS IN auth_controller.dart

  bookRide(Map<String, dynamic> requestBody, String childId, context) async {
    print('requestBody');
    print(requestBody);
    print(childId);
    try {
      GlobalLoader().show();

      final response = await bookRideUseCase.call(requestBody, childId);
      debugPrint(response);

      // ⭐ Parse the response
      final responseData = json.decode(response);

      GlobalLoader().hide();

      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.success(
          message: 'Booking Successful',
        ),
      );

      // ⭐ Extract booking data
      final booking = responseData['booking'] as Map<String, dynamic>;
      final bookingId = booking['_id']?.toString() ?? '';
      if (bookingId.isEmpty) {
        throw Exception('Booking was created but no booking ID was returned.');
      }
      final childValue = booking['child'];
      final childName = childValue is Map<String, dynamic>
          ? (childValue['fullname']?.toString() ?? 'N/A')
          : childValue?.toString() ?? 'N/A';

      // ⭐ Calculate amount from rates
      final amount = _calculateAmount(
        booking['ride_type']?.toString() ?? '',
        booking['trip_type']?.toString() ?? '',
        booking['schedule_type']?.toString() ?? '',
      );

      // ⭐ Navigate to payment screen
      Get.to(() => PaymentScreen(
            amount: amount,
            bookingId: bookingId,
            bookingDetails: {
              'childName': childName,
              'tripType': booking['trip_type']?.toString() ?? 'N/A',
              'schedule': booking['schedule_type']?.toString() ?? 'N/A',
              'startDate': booking['start_date']?.toString() ?? 'N/A',
            },
          ));
    } catch (e) {
      print(e);
      GlobalLoader().hide();

      final errorMessage = e.toString().toLowerCase();

      // Check if it's a pending booking conflict
      if (errorMessage.contains('pending booking already exists')) {
        // Show dialog with options
        Get.dialog(
          AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Icon(Icons.warning_amber_rounded,
                    color: const Color(0xffFF5500), size: 28),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Pending Booking Found',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            content: const Text(
              'You already have a pending booking for this child. Would you like to view it or cancel it to create a new one?',
              style: TextStyle(fontSize: 14),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  'Close',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.back(); // Close dialog
                  Get.back(); // Go back from confirm booking
                  Get.back(); // Go back from book ride
                  // Navigate to rides tab (index 1) using the new initialTab parameter
                  Get.offAll(() => const NavigationPage(initialTab: 1));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffFF5500),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'View Pending',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          barrierDismissible: false,
        );
      } else {
        // Show regular error snackbar
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: e.toString().replaceAll('Exception: ', ''),
          ),
        );
      }
    }
  }

  // ⭐ ADD THIS NEW HELPER METHOD
  double _calculateAmount(
      String rideType, String tripType, String scheduleType) {
    try {
      final ratesData = rates.value;

      if (ratesData == null) {
        return 0.0;
      }

      String driverKey =
          rideType == 'inhouse' ? 'in_house_drivers' : 'freelance_drivers';

      String scheduleKey = scheduleType == '2 weeks'
          ? 'bi_weekly'
          : scheduleType == '1 month'
              ? 'monthly'
              : 'daily';

      String tripKey = tripType == 'return' ? 'return' : 'one_way';

      final price = ratesData[driverKey]?[scheduleKey]?[tripKey];

      return price?.toDouble() ?? 0.0;
    } catch (e) {
      print('Error calculating amount: $e');
      return 0.0;
    }
  }

  Future<void> fetchRidesByUser() async {
    try {
      isLoadingRides.value = true;

      final fetchedRides = await fetchAllRidesUseCase.call();

      List<Booking> bookings =
          fetchedRides.map((rideJson) => Booking.fromJson(rideJson)).toList();

      // Sort by date (newest first)
      bookings.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      recentRides.assignAll(bookings);
      update();

      print('✅ Fetched ${bookings.length} rides');
    } catch (e) {
      print('Error fetching rides: $e');
      Get.snackbar(
        'Error',
        'Failed to refresh rides',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xffFF5500),
        colorText: Colors.white,
      );
    } finally {
      isLoadingRides.value = false;
    }
  }

  // ============================================
  // NEW: Payment Methods
  // ============================================

  Future<PaymentResponseModel> makePayment({
    required String bookingId,
    required String currency,
  }) async {
    try {
      final dataSource = GetIt.instance<EagleRidesAuthDataSource>();
      return await dataSource.makePayment(
        PaymentRequestModel(
          bookingId: bookingId,
          currency: currency,
        ),
      );
    } catch (e) {
      print('Error making payment: $e');
      rethrow;
    }
  }

  Future<PaymentResponseModel> renewPayment({
    required String bookingId,
    required String currency,
  }) async {
    try {
      final dataSource = GetIt.instance<EagleRidesAuthDataSource>();
      return await dataSource.renewPayment(
        PaymentRequestModel(
          bookingId: bookingId,
          currency: currency,
        ),
      );
    } catch (e) {
      print('Error renewing payment: $e');
      rethrow;
    }
  }

  Future<PaymentStatusResult> refreshPaymentStatus(String bookingId) async {
    await fetchRidesByUser();
    final matchingRide = recentRides.firstWhereOrNull((r) => r.id == bookingId);
    return PaymentStatusResult(
      bookingId: bookingId,
      status: matchingRide?.status,
    );
  }

  // ============================================
  // NEW: Password Reset Methods
  // ============================================

  Future<String> forgotPassword({
    required String email,
    String? oldPassword,
    String? newPassword,
  }) async {
    try {
      GlobalLoader().show();
      final dataSource = GetIt.instance<EagleRidesAuthDataSource>();
      final result = await dataSource.forgotPassword(
        email: email,
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
      GlobalLoader().hide();

      Get.snackbar(
        'Success',
        result,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xffFF5500),
        colorText: Colors.white,
      );

      return result;
    } catch (e) {
      GlobalLoader().hide();
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xffFF5500),
        colorText: Colors.white,
      );
      rethrow;
    }
  }

  Future<String> verifyPasswordResetOtp({
    required String email,
    required String otp,
  }) async {
    try {
      GlobalLoader().show();
      final dataSource = GetIt.instance<EagleRidesAuthDataSource>();
      final result = await dataSource.eagleridesAuthOtpVerification(email, otp);
      GlobalLoader().hide();

      Get.snackbar(
        'Success',
        result,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xffFF5500),
        colorText: Colors.white,
      );
      return result;
    } catch (e) {
      GlobalLoader().hide();
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xffFF5500),
        colorText: Colors.white,
      );
      rethrow;
    }
  }

  Future<String> setForgotPassword({
    required String email,
    required String newPassword,
  }) async {
    return forgotPassword(
      email: email,
      newPassword: newPassword,
    );
  }

  Future<String> resendOtp(String email) async {
    try {
      GlobalLoader().show();
      final dataSource = GetIt.instance<EagleRidesAuthDataSource>();
      final result = await dataSource.resendOtp(email);
      GlobalLoader().hide();

      Get.snackbar(
        'OTP Sent',
        result,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xffFF5500),
        colorText: Colors.white,
      );

      return result;
    } catch (e) {
      GlobalLoader().hide();
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xffFF5500),
        colorText: Colors.white,
      );
      rethrow;
    }
  }

  // ============================================
  // NEW: User Profile Methods
  // ============================================

  Future<Map<String, dynamic>?> updateUserProfile(
      Map<String, dynamic> updates) async {
    try {
      GlobalLoader().show();
      final dataSource = GetIt.instance<EagleRidesAuthDataSource>();
      final userId = _resolveUserIdOrThrow();
      final payload = _buildUserProfileUpdatePayload(updates);
      final result = await dataSource.updateUserProfile(userId, payload);

      // Refresh user data
      await loadUser();

      GlobalLoader().hide();
      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xffFF5500),
        colorText: Colors.white,
      );

      return result;
    } catch (e) {
      GlobalLoader().hide();
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xffFF5500),
        colorText: Colors.white,
      );
      rethrow;
    }
  }

  // ============================================
  // NEW: Child Management Methods
  // ============================================

  Future<Map<String, dynamic>?> updateChild(
      String childId, ChildUpsertRequest updates) async {
    try {
      GlobalLoader().show();
      final dataSource = GetIt.instance<EagleRidesAuthDataSource>();
      final result = await dataSource.updateChild(childId, updates);

      // Refresh children list
      await fetchChildren();

      GlobalLoader().hide();
      Get.snackbar(
        'Success',
        'Child updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xffFF5500),
        colorText: Colors.white,
      );

      return result;
    } catch (e) {
      GlobalLoader().hide();
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xffFF5500),
        colorText: Colors.white,
      );
      rethrow;
    }
  }

  Future<void> deleteChild(String childId) async {
    try {
      GlobalLoader().show();
      final dataSource = GetIt.instance<EagleRidesAuthDataSource>();
      await dataSource.deleteChild(childId);

      // Refresh children list
      await fetchChildren();

      GlobalLoader().hide();
      Get.snackbar(
        'Success',
        'Child deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xffFF5500),
        colorText: Colors.white,
      );
    } catch (e) {
      GlobalLoader().hide();
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xffFF5500),
        colorText: Colors.white,
      );
      rethrow;
    }
  }

  Future<void> deleteAccount() async {
    try {
      final userId = _resolveUserIdOrThrow();

      GlobalLoader().show();

      // 1. Call API to delete user
      await deleteUserUseCase.call(userId);

      // 2. Clear all local storage
      var authBox = await Hive.openBox('authBox');
      var childrenBox = await Hive.openBox('childrenBox');
      var ratesBox = await Hive.openBox('ratesBox');

      await authBox.clear();
      await childrenBox.clear();
      await ratesBox.clear();

      // 3. Reset local state
      user.value = null;
      children.clear();
      recentRides.clear();
      isSignIn.value = false;

      GlobalLoader().hide();

      Get.snackbar(
        'Success',
        'Your account has been deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xffFF5500),
        colorText: Colors.white,
      );

      // 4. Redirect to login
      Get.offAll(const Login());
    } catch (e) {
      GlobalLoader().hide();
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  String _resolveUserIdOrThrow() {
    final userId = user.value?.id.trim() ?? '';
    if (userId.isEmpty) {
      throw Exception(
        'Unable to resolve your user ID. Please sign out and sign in again.',
      );
    }
    return userId;
  }

  Map<String, dynamic> _buildUserProfileUpdatePayload(
      Map<String, dynamic> updates) {
    final currentUser = user.value;

    final fullname = _firstNonEmptyString([
      updates['fullname'],
      updates['fullName'],
      currentUser?.name,
    ]);
    final email = _firstNonEmptyString([
      updates['email'],
      currentUser?.email,
    ]);
    final phoneNumber = _firstNonEmptyString([
      updates['phone_number'],
      updates['phoneNumber'],
      currentUser?.number,
    ]);
    final address = _firstNonEmptyString([
      updates['address'],
      updates['home_address'],
      currentUser?.address,
    ]);

    if (fullname.isEmpty ||
        email.isEmpty ||
        phoneNumber.isEmpty ||
        address.isEmpty) {
      throw Exception(
        'Full name, email, phone number and address are required.',
      );
    }

    final nameParts = fullname
        .split(RegExp(r'\s+'))
        .where((part) => part.trim().isNotEmpty)
        .toList();
    final firstName = nameParts.isNotEmpty ? nameParts.first : fullname;
    final lastName = nameParts.length > 1
        ? nameParts.sublist(1).join(' ')
        : (nameParts.isNotEmpty ? nameParts.first : fullname);

    return {
      'fullname': fullname,
      'fullName': fullname,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone_number': phoneNumber,
      'phoneNumber': phoneNumber,
      'address': address,
      'home_address': address,
    };
  }

  String _firstNonEmptyString(Iterable<dynamic> values) {
    for (final value in values) {
      final text = value?.toString().trim() ?? '';
      if (text.isNotEmpty) {
        return text;
      }
    }
    return '';
  }
}

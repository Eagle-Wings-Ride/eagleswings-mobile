import '../datasource/auth_remote_data_source.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/child_upsert_request.dart';
import '../models/payment_models.dart';

class EagleRidesAuthRepositoryImpl extends EagleRidesAuthRepository {
  final EagleRidesAuthDataSource eagleRidesAuthDataSource;
  // final AuthenticationLocalDataSource authenticationLocalDataSource;

  EagleRidesAuthRepositoryImpl({
    required this.eagleRidesAuthDataSource,
  }
      // this.authenticationLocalDataSource,
      );

  @override
  Future<String> loginUser(String email, String password) async {
    return await eagleRidesAuthDataSource.loginUser(email, password);
  }

  @override
  Future<String> register(Map<String, dynamic> requestBody) async {
    return await eagleRidesAuthDataSource.register(requestBody);
  }

  @override
  Future<String> bookRide(
      Map<String, dynamic> requestBody, String childId) async {
    return await eagleRidesAuthDataSource.bookRide(requestBody, childId);
  }

  @override
  Future<String> addChild(ChildUpsertRequest requestBody) async {
    return await eagleRidesAuthDataSource.addChild(requestBody);
  }

  @override
  Future<List<dynamic>> fetchChildren() async {
    return await eagleRidesAuthDataSource.fetchChildren();
  }

  @override
  Future<bool> eagleRidesAuthIsSignIn() async {
    return await eagleRidesAuthDataSource.eagleridesAuthIsSignIn();
  }

  @override
  Future<void> eagleRidesAuthPhoneVerification(String phoneNumber) async {
    return await eagleRidesAuthDataSource
        .eagleridesAuthPhoneVerification(phoneNumber);
  }

  @override
  Future<String> eagleRidesAuthOtpVerification(String email, String otp) async {
    return await eagleRidesAuthDataSource.eagleridesAuthOtpVerification(
        email, otp);
  }

  @override
  Future<String> eagleRidesAuthGetUserUid() async {
    return await eagleRidesAuthDataSource.eagleridesAuthGetUserUid();
  }

  @override
  Future<Map<String, dynamic>> getUser() async {
    return await eagleRidesAuthDataSource.getUser();
  }

  @override
  Future<Map<String, dynamic>> fetchRates() async {
    return await eagleRidesAuthDataSource.fetchRates();
  }

  @override
  Future<List<Map<String, dynamic>>> fetchRecentRides(String childId) async {
    return await eagleRidesAuthDataSource.fetchRecentRides(childId);
  }

  @override
  Future<bool> eagleRidesAuthCheckUserStatus(String userId) async {
    return await eagleRidesAuthDataSource.eagleridesAuthCheckUserStatus(userId);
  }

  @override
  Future<void> eagleRidesAuthSignOut() async {
    return await eagleRidesAuthDataSource.eagleridesAuthSignOut();
  }

  @override
  Future<String> eagleRidesAddProfileImg(String riderId) async {
    return await eagleRidesAuthDataSource.eagleridesAddProfileImg(riderId);
  }

  @override
  Future<List<dynamic>> fetchAllRides() async {
    try {
      return await eagleRidesAuthDataSource.fetchAllRides();
    } catch (e) {
      throw Exception('Failed to fetch rides: $e');
    }
  }

  @override
  Future<String> cancelRide(String bookingId, String cancelReason) async {
    try {
      return await eagleRidesAuthDataSource.cancelRide(bookingId, cancelReason);
    } catch (e) {
      throw Exception('Failed to cancel ride: $e');
    }
  }

  // ============================================
  // NEW: Payment Methods
  // ============================================

  @override
  Future<PaymentResponseModel> makePayment(PaymentRequestModel request) async {
    return await eagleRidesAuthDataSource.makePayment(request);
  }

  @override
  Future<PaymentResponseModel> renewPayment(PaymentRequestModel request) async {
    return await eagleRidesAuthDataSource.renewPayment(request);
  }

  // ============================================
  // NEW: Ride Status Methods
  // ============================================

  @override
  Future<List<dynamic>> fetchRidesByStatus(
      String childId, String status) async {
    return await eagleRidesAuthDataSource.fetchRidesByStatus(childId, status);
  }

  @override
  Future<Map<String, dynamic>> updateRideStatus(
      String bookingId, String status) async {
    return await eagleRidesAuthDataSource.updateRideStatus(bookingId, status);
  }

  // ============================================
  // NEW: User Management Methods
  // ============================================

  @override
  Future<Map<String, dynamic>> updateUserProfile(
      String userId, Map<String, dynamic> updates) async {
    return await eagleRidesAuthDataSource.updateUserProfile(userId, updates);
  }

  @override
  Future<void> deleteUser(String userId) async {
    await eagleRidesAuthDataSource.deleteUser(userId);
  }

  // ============================================
  // NEW: Child Management Methods
  // ============================================

  @override
  Future<Map<String, dynamic>> updateChild(
      String childId, ChildUpsertRequest updates) async {
    return await eagleRidesAuthDataSource.updateChild(childId, updates);
  }

  @override
  Future<void> deleteChild(String childId) async {
    await eagleRidesAuthDataSource.deleteChild(childId);
  }

  // ============================================
  // NEW: Password Reset Methods
  // ============================================

  @override
  Future<String> forgotPassword({
    required String email,
    String? oldPassword,
    String? newPassword,
  }) async {
    return await eagleRidesAuthDataSource.forgotPassword(
      email: email,
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
  }

  @override
  Future<String> resendOtp(String email) async {
    return await eagleRidesAuthDataSource.resendOtp(email);
  }
}

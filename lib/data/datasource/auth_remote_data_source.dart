import '../models/child_upsert_request.dart';
import '../models/payment_models.dart';

abstract class EagleRidesAuthDataSource {
  Future<bool> eagleridesAuthIsSignIn();

  Future<void> eagleridesAuthPhoneVerification(String phoneNumber);

  Future<String> eagleridesAuthOtpVerification(String email, String otp);

  Future<String> eagleridesAuthGetUserUid();

  Future<bool> eagleridesAuthCheckUserStatus(String userId);

  Future<void> eagleridesAuthSignOut();

  Future<String> eagleridesAddProfileImg(String riderId);

  Future<String> loginUser(String email, String password);
  Future<String> register(Map<String, dynamic> requestBody);
  Future<Map<String, dynamic>> getUser();
  Future<List<Map<String, dynamic>>> fetchRecentRides(String childId);
  Future<String> addChild(ChildUpsertRequest requestBody);
  Future<List<dynamic>> fetchChildren();
  Future<Map<String, dynamic>> fetchRates();
  Future<String> bookRide(Map<String, dynamic> requestBody, String childId);
  Future<List<dynamic>> fetchAllRides();
  Future<String> cancelRide(String bookingId, String cancelReason);

  // NEW: Payment endpoints
  Future<PaymentResponseModel> makePayment(PaymentRequestModel request);
  Future<PaymentResponseModel> renewPayment(PaymentRequestModel request);

  // NEW: Ride status endpoints
  Future<List<dynamic>> fetchRidesByStatus(String childId, String status);
  Future<Map<String, dynamic>> updateRideStatus(
      String bookingId, String status);

  // NEW: User management endpoints
  Future<Map<String, dynamic>> updateUserProfile(
      String userId, Map<String, dynamic> updates);
  Future<void> deleteUser(String userId);

  // NEW: Child management endpoints
  Future<Map<String, dynamic>> updateChild(
      String childId, ChildUpsertRequest updates);
  Future<void> deleteChild(String childId);

  // NEW: Password reset endpoints
  Future<String> forgotPassword({
    required String email,
    String? oldPassword,
    String? newPassword,
  });
  Future<String> resendOtp(String email);
}

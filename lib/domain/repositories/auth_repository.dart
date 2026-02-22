import '../../data/models/child_model.dart';
import '../../data/models/child_upsert_request.dart';
import '../../data/models/payment_models.dart';

abstract class EagleRidesAuthRepository {
  Future<bool> eagleRidesAuthIsSignIn();

  Future<void> eagleRidesAuthPhoneVerification(String phoneNumber);

  Future<String> eagleRidesAuthOtpVerification(String email, String otp);

  Future<String> eagleRidesAuthGetUserUid();

  Future<bool> eagleRidesAuthCheckUserStatus(String userId);

  Future<void> eagleRidesAuthSignOut();

  Future<String> eagleRidesAddProfileImg(String riderId);
  Future<String> loginUser(String email, String password);
  Future<String> register(Map<String, dynamic> requestBody);

  Future<Map<String, dynamic>> getUser();
  Future<Map<String, dynamic>> fetchRates();

  Future<String> addChild(ChildUpsertRequest requestBody);
  Future<List<dynamic>> fetchChildren();
  Future<List<Map<String, dynamic>>> fetchRecentRides(String childId);
  Future<String> bookRide(Map<String, dynamic> requestBody, String childId);
  Future<List<dynamic>> fetchAllRides();
  Future<String> cancelRide(String bookingId, String cancelReason);

  // Payment endpoints
  Future<PaymentResponseModel> makePayment(PaymentRequestModel request);
  Future<PaymentResponseModel> renewPayment(PaymentRequestModel request);

  // Ride status endpoints
  Future<List<dynamic>> fetchRidesByStatus(String childId, String status);
  Future<Map<String, dynamic>> updateRideStatus(
      String bookingId, String status);

  // User management endpoints
  Future<Map<String, dynamic>> updateUserProfile(
      String userId, Map<String, dynamic> updates);
  Future<void> deleteUser(String userId);

  // Child management endpoints
  Future<Map<String, dynamic>> updateChild(
      String childId, ChildUpsertRequest updates);
  Future<void> deleteChild(String childId);

  // Password reset endpoints
  Future<String> forgotPassword({
    required String email,
    String? oldPassword,
    String? newPassword,
  });
  Future<String> resendOtp(String email);
}

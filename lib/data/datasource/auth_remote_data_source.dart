import '../models/child_model.dart';

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
  Future<String> addChild(Map<String, dynamic> requestBody);
  Future<List<dynamic>> fetchChildren(String userId);
  Future<String> bookRide(Map<String, dynamic> requestBody, String childId);
}

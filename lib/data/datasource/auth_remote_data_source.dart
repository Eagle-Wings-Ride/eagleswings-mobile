import 'package:eaglerides/data/models/response_model.dart';

abstract class EagleRidesAuthDataSource {
  Future<bool> eagleridesAuthIsSignIn();

  Future<void> eagleridesAuthPhoneVerification(String phoneNumber);

  Future<void> eagleridesAuthOtpVerification(String otp);

  Future<String> eagleridesAuthGetUserUid();

  Future<bool> eagleridesAuthCheckUserStatus(String userId);

  Future<void> eagleridesAuthSignOut();

  Future<String> eagleridesAddProfileImg(String riderId);

  Future<String> loginUser(String email, String password);
}

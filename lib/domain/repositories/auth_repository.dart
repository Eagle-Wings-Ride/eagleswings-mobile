import 'package:dartz/dartz.dart';
import 'package:eaglerides/domain/entities/app_error.dart';

abstract class EagleRidesAuthRepository {
  Future<bool> eagleRidesAuthIsSignIn();

  Future<void> eagleRidesAuthPhoneVerification(String phoneNumber);

  Future<void> eagleRidesAuthOtpVerification(String otp);

  Future<String> eagleRidesAuthGetUserUid();

  Future<bool> eagleRidesAuthCheckUserStatus(String userId);

  Future<void> eagleRidesAuthSignOut();

  Future<String> eagleRidesAddProfileImg(String riderId);
  Future<String> loginUser(String email, String password);
}

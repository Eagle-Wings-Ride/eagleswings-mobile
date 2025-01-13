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
}

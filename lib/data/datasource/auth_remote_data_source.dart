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
}

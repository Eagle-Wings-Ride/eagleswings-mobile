import '../repositories/auth_repository.dart';

class EagleRidesAuthOtpVerificationUseCase {
  final EagleRidesAuthRepository eagleRidesAuthRepository;

  EagleRidesAuthOtpVerificationUseCase(
      {required this.eagleRidesAuthRepository});

  Future<String> call(String email, String otp) async {
    return await eagleRidesAuthRepository.eagleRidesAuthOtpVerification(email, otp);
  }
}

import '../repositories/auth_repository.dart';

class EagleRidesAuthOtpVerificationUseCase {
  final EagleRidesAuthRepository eagleRidesAuthRepository;

  EagleRidesAuthOtpVerificationUseCase(
      {required this.eagleRidesAuthRepository});

  Future<void> call(String otp) async {
    return await eagleRidesAuthRepository.eagleRidesAuthOtpVerification(otp);
  }
}

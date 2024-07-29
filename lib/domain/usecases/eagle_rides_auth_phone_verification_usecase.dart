import '../repositories/auth_repository.dart';

class EagleRidesAuthPhoneVerificationUseCase {
  final EagleRidesAuthRepository eagleRidesAuthRepository;

  EagleRidesAuthPhoneVerificationUseCase(
      {required this.eagleRidesAuthRepository});

  Future<void> call(String phoneNumber) async {
    return await eagleRidesAuthRepository
        .eagleRidesAuthPhoneVerification(phoneNumber);
  }
}

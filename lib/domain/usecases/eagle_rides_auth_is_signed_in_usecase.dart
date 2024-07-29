import '../repositories/auth_repository.dart';

class EagleRidesAuthIsSignInUseCase {
  final EagleRidesAuthRepository eagleRidesAuthRepository;

  EagleRidesAuthIsSignInUseCase({required this.eagleRidesAuthRepository});

  Future<bool> call() async {
    return await eagleRidesAuthRepository.eagleRidesAuthIsSignIn();
  }
}

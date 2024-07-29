import '../repositories/auth_repository.dart';

class EagleRidesAuthSignOutUseCase {
  final EagleRidesAuthRepository eagleRidesAuthRepository;

  EagleRidesAuthSignOutUseCase({required this.eagleRidesAuthRepository});

  Future<void> call() async {
    return await eagleRidesAuthRepository.eagleRidesAuthSignOut();
  }
}

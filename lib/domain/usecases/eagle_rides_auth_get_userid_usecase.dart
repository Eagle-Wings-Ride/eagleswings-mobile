import '../repositories/auth_repository.dart';

class EagleRidesAuthGetUserUidUseCase {
  final EagleRidesAuthRepository eagleRidesAuthRepository;

  EagleRidesAuthGetUserUidUseCase({required this.eagleRidesAuthRepository});

  Future<String> call() async {
    return await eagleRidesAuthRepository.eagleRidesAuthGetUserUid();
  }
}

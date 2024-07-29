import 'package:eaglerides/domain/repositories/auth_repository.dart';

class EagleRidesAuthCheckUserUseCase {
  final EagleRidesAuthRepository eagleRidesAuthRepository;

  EagleRidesAuthCheckUserUseCase({required this.eagleRidesAuthRepository});

  Future<bool> call(String userId) async {
    return await eagleRidesAuthRepository.eagleRidesAuthCheckUserStatus(userId);
  }
}

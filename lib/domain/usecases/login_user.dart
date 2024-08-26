import '../repositories/auth_repository.dart';

class EagleRidesLoginUserUseCase {
  final EagleRidesAuthRepository eagleRidesAuthRepository;

  EagleRidesLoginUserUseCase({required this.eagleRidesAuthRepository});

  Future<String> call(String email, String password) async {
    return await eagleRidesAuthRepository.loginUser(email, password);
  }
}

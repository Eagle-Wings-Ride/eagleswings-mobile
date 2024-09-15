import 'package:eaglerides/domain/repositories/auth_repository.dart';

class EagleRidesRegisterUseCase {
  final EagleRidesAuthRepository eagleRidesAuthRepository;

  EagleRidesRegisterUseCase({required this.eagleRidesAuthRepository});

  Future<String> call(Map<String, dynamic> requestBody) async {
    return await eagleRidesAuthRepository.register(requestBody);
  }
}

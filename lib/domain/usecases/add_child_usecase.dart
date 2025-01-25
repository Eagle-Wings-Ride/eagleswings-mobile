import 'package:eaglerides/domain/repositories/auth_repository.dart';

class AddChildUseCase {
  final EagleRidesAuthRepository eagleRidesAuthRepository;

  AddChildUseCase({required this.eagleRidesAuthRepository});

  Future<String> call(Map<String, dynamic> requestBody) async {
    return await eagleRidesAuthRepository.addChild(requestBody);
  }
}

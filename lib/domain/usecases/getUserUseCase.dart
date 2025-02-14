import 'package:eaglerides/domain/repositories/auth_repository.dart';


class GetUserUsecase {
  final EagleRidesAuthRepository eagleRidesAuthRepository;

  GetUserUsecase({required this.eagleRidesAuthRepository});

  Future<Map<String, dynamic>> call() async {
    return await eagleRidesAuthRepository.getUser();
  }
}

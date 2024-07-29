import 'package:dartz/dartz.dart';

import '../entities/app_error.dart';
import '../entities/login_request_params.dart';
import '../repositories/auth_repository.dart';

class EagleRidesLoginUserUseCase {
  final EagleRidesAuthRepository eagleRidesAuthRepository;

  EagleRidesLoginUserUseCase({required this.eagleRidesAuthRepository});

  Future<String> call(String email, String password) async {
    return await eagleRidesAuthRepository.loginUser(email, password);
  }
}

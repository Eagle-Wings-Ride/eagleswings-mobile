import 'package:eaglerides/domain/repositories/auth_repository.dart';
import 'package:geolocator/geolocator.dart';

import '../repositories/user_current_location_repository.dart';

class GetUserUsecase {
  final EagleRidesAuthRepository eagleRidesAuthRepository;

  GetUserUsecase({required this.eagleRidesAuthRepository});

  Future<Map<String, dynamic>> call() async {
    return await eagleRidesAuthRepository.getUser();
  }
}

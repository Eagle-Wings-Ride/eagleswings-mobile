import 'package:eaglerides/domain/repositories/auth_repository.dart';
import 'package:geolocator/geolocator.dart';


class FetchRatesUsecase {
  final EagleRidesAuthRepository eagleRidesAuthRepository;

  FetchRatesUsecase({required this.eagleRidesAuthRepository});

  Future<Map<String, dynamic>>  call() async {
    return await eagleRidesAuthRepository.fetchRates();
  }
}

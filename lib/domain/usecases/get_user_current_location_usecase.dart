import 'package:geolocator/geolocator.dart';

import '../repositories/user_current_location_repository.dart';

class GetUserCurrentLocationUsecase {
  final UserCurrentLocationRepository userCurrentLocationRepository;

  GetUserCurrentLocationUsecase({required this.userCurrentLocationRepository});

  Future<Position> call() async {
    return await userCurrentLocationRepository.getUserCurrentLocation();
  }
}

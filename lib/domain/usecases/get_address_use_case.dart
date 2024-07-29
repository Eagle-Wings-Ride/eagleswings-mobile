import 'package:geolocator/geolocator.dart';

import '../../data/models/location_model.dart';
import '../repositories/user_current_location_repository.dart';

class GetUserCurrentAddressUsecase {
  final UserCurrentLocationRepository userCurrentLocationRepository;

  GetUserCurrentAddressUsecase({required this.userCurrentLocationRepository});

  Future<LocationModel> call() async {
    return await userCurrentLocationRepository.getCurrentLocationAndAddress();
  }
}

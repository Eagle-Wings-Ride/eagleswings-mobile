import 'package:geolocator/geolocator.dart';

import '../../data/models/location_model.dart';

abstract class UserCurrentLocationRepository {
  Future<Position> getUserCurrentLocation();
   Future<LocationModel> getCurrentLocationAndAddress();
}

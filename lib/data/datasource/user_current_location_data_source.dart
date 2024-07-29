import 'package:eaglerides/data/models/location_model.dart';
import 'package:geolocator/geolocator.dart';

abstract class UserCurrentLocationDataSource {
  Future<Position> getUserCurrentLocation();
  Future<LocationModel> getCurrentLocationAndAddress();
}

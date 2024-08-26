// import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

// import 'package:geocoding/geocoding.dart';
// import 'package:location/location.dart';

import '../../domain/repositories/user_current_location_repository.dart';
import '../datasource/user_current_location_data_source.dart';
import '../models/location_model.dart';

class UserCurrentLocationRepositoryImpl extends UserCurrentLocationRepository {
  final UserCurrentLocationDataSource userCurrentLocationDataSource;

  UserCurrentLocationRepositoryImpl(
      {required this.userCurrentLocationDataSource});

  @override
  Future<Position> getUserCurrentLocation() async {
    return await userCurrentLocationDataSource.getUserCurrentLocation();
  }

  @override
  Future<LocationModel> getCurrentLocationAndAddress() async {
    return await userCurrentLocationDataSource.getCurrentLocationAndAddress();
  }
}

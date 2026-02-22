import 'dart:convert';

import 'package:eaglerides/data/models/location_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../config/map_api_key.dart';
import 'user_current_location_data_source.dart';

class UserCurrentLocationDataSourceImpl extends UserCurrentLocationDataSource {
  Position? _currentPosition;

  @override
  Future<Position> getUserCurrentLocation() async {
    return await Geolocator.getCurrentPosition();
  }

  @override
  Future<LocationModel> getCurrentLocationAndAddress() async {
    // print('getting');
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar(
          "Location permissions are denied",
          "Allow location permissions to use live tracking",
          snackPosition: SnackPosition.BOTTOM,
        );
        throw Exception('Location permissions are denied');
      }
    } else if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
        "Alert",
        "Location permissions are permanently denied. Please enable them from the app settings.",
        snackPosition: SnackPosition.BOTTOM,
      );
      throw Exception('Location permissions are permanently denied');
    }

    try {
      String host = 'https://maps.google.com/maps/api/geocode/json';

      _currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      final url =
          '$host?key=$apiKey&language=en&latlng=${_currentPosition!.latitude}, ${_currentPosition!.longitude}';
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        // print(data);
        String formattedAddress = data['results'][0]['formatted_address'];
        // print("response ===== $formattedAddress");
        // sourcePlaceController.text = _formattedAddress;
        return LocationModel(
          latitude: _currentPosition!.latitude,
          longitude: _currentPosition!.longitude,
          address: formattedAddress,
        );
      } else {
        print(response.body);
        return LocationModel(
          latitude: _currentPosition!.latitude,
          longitude: _currentPosition!.longitude,
          address: 'Address not found',
        );
      }
    } catch (e) {
      print(e);
      return LocationModel(
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
        address: 'Address not found',
      );
    }
  }
}

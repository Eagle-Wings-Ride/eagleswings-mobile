import 'dart:convert';

import 'package:eaglerides/data/models/location_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
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

    // try {
    //   _currentPosition = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.high,
    //   );
    //   print('Current Position: $_currentPosition');

    //   final placemarks = await placemarkFromCoordinates(
    //     _currentPosition!.latitude,
    //     _currentPosition!.longitude,
    //   );

    //   if (placemarks.isNotEmpty) {
    //     final place = placemarks.first;
    //     final addressArray = [
    //       place.street,
    //       place.subLocality,
    //       place.subAdministrativeArea,
    //       place.postalCode,
    //       place.country,
    //     ].where((part) => part != null && part.isNotEmpty).join(', ');

    //     print('Address: $addressArray');

    //     return LocationModel(
    //       latitude: _currentPosition!.latitude,
    //       longitude: _currentPosition!.longitude,
    //       address: addressArray,
    //     );
    //   } else {
    //     print('No placemarks found');
    //     return LocationModel(
    //       latitude: _currentPosition!.latitude,
    //       longitude: _currentPosition!.longitude,
    //       address: 'Address not found',
    //     );
    //   }
    // } catch (e) {
    //   print('Error fetching location or address: $e');
    //   throw Exception('Error fetching location or address');
    // }
  }
}

    // bool serviceEnabled = await _location.serviceEnabled();
    // print(serviceEnabled);
    // if (!serviceEnabled) {
    //   serviceEnabled = await _location.requestService();
    //   if (!serviceEnabled) {
    //     throw Exception('Location service not enabled');
    //   }
    // }

    // loc.PermissionStatus permissionGranted = await _location.hasPermission();
    // if (permissionGranted == loc.PermissionStatus.denied) {
    //   permissionGranted = await _location.requestPermission();
    //   if (permissionGranted != loc.PermissionStatus.granted) {
    //     throw Exception('Location permission not granted');
    //   }
    // }
    // print('permissionGranted');
    // print(permissionGranted);

    // print('getting location...');
    // print(_location);
    // try {
    //    locationData = await _location.getLocation();
    //   _location.enableBackgroundMode(enable: true);
    //   print(locationData);
    //   final latitude = locationData!.latitude ?? 0.0;
    //   final longitude = locationData!.longitude ?? 0.0;
    //   print(latitude);
    //   print(longitude);

    //   final List<geo.Placemark> placemarks =
    //       await geo.placemarkFromCoordinates(latitude, longitude);
    //   print(placemarks);
    //   final geo.Placemark place =
    //       placemarks.isNotEmpty ? placemarks[0] : const geo.Placemark();
    //   print(place);
    //   final address =
    //       '${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}';
    //   print(address);

    //   return LocationModel(
    //     latitude: latitude,
    //     longitude: longitude,
    //     address: address,
    //   );
    // } catch (e) {
    //   print('Error fetching location or address: $e');
    //   return LocationModel(
    //     latitude: 0.0,
    //     longitude: 0.0,
    //     address: 'Unable to fetch address',
    //   );
    // }
  
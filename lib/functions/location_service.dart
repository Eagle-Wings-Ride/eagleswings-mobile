// import 'dart:async';

// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// import '../pages/onTripPage/map_page.dart';
// import 'function.dart';

// class LocationService {
//   final StreamController<LatLng> _locationController =
//       StreamController<LatLng>.broadcast();

//   Stream<LatLng> get locationStream => _locationController.stream;

//   LocationService() {
//     getCurrentLocation();
//   }
//   // Mock method to simulate location updates
//   getCurrentLocation() {
//     print('current..');
//     timerLocation = Timer.periodic(const Duration(seconds: 5), (timer) async {
//       var loc = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.medium);
//       print('loc');
//       print(loc);

//       currentLocation = LatLng(loc.latitude, loc.longitude);
//     });
//   }

//   void dispose() {
//     _locationController.close();
//   }
// }

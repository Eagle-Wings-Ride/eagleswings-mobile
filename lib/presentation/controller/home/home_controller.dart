import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';

import '../../../domain/usecases/get_address_use_case.dart';
import '../../../domain/usecases/get_user_current_location_usecase.dart';

class HomeController extends GetxController {
  final GetUserCurrentLocationUsecase getUserCurrentLocationUsecase;
  final GetUserCurrentAddressUsecase getUserCurrentAddressUsecase;
  // Location location = new Location();
  // LocationData? _locationData;
  late Timer _locationUpdateTimer;
  var currentLat = 0.0.obs;
  var currentLng = 0.0.obs;
  Position? currentPosition;
  // var address = 'Fetching address...'.obs;
  RxString address = ''.obs;
  Position? _previousPosition;
  final Completer<GoogleMapController> controller = Completer();

  // @override
  // void onInit() {
  //   getUserCurrentLocation();
  //   super.onInit();
  // }
  HomeController(
      {required this.getUserCurrentLocationUsecase,
      required this.getUserCurrentAddressUsecase});

  @override
  void onInit() {
    super.onInit();
    startLocationUpdates();
  }

  getUserCurrentLocation() async {
    animateCamera();
    LocationPermission permission;
    await Geolocator.requestPermission();
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar(
          "Alert",
          "Location permissions are denied",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
        "Alert",
        "Location permissions are permanently denied,please enable it from app setting",
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      animateCamera();
    }
  }

  animateCamera() async {
    await getUserCurrentLocationUsecase.call().then((value) {
      currentLat.value = value.latitude;
      currentLng.value = value.longitude;
    });
    final GoogleMapController _controller = await controller.future;
    CameraPosition _newCameraPos = CameraPosition(
      target: LatLng(currentLat.value, currentLng.value),
      zoom: 14.4746,
    );
    _controller.animateCamera(CameraUpdate.newCameraPosition(_newCameraPos));
  }

  // startLocationUpdates() async {
  //   _locationUpdateTimer =
  //       Timer.periodic(const Duration(seconds: 5), (timer) async {
  //     print('fetching');
  //     await getUserCurrentAddressUsecase.call().then((value) {
  //       address.value = value.address;
  //     });
  //   });
  // }
  startLocationUpdates() async {
    _locationUpdateTimer =
        Timer.periodic(const Duration(seconds: 5), (timer) async {
      Position newPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);

      if (_previousPosition == null ||
          hasLocationChanged(_previousPosition!, newPosition)) {
        _previousPosition = newPosition;
        await getUserCurrentAddressUsecase.call().then((value) {
          address.value = value.address;
        });
      }
    });
  }

  bool hasLocationChanged(Position oldPosition, Position newPosition) {
    // Define your own logic for significant change, here we use 0.001 degree
    const double threshold = 0.001;
    double latDifference = (oldPosition.latitude - newPosition.latitude).abs();
    double lngDifference =
        (oldPosition.longitude - newPosition.longitude).abs();
    return latDifference > threshold || lngDifference > threshold;
  }

  @override
  void onClose() {
    _locationUpdateTimer
        .cancel(); // Cancel the timer when the controller is disposed
    super.onClose();
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../domain/usecases/get_address_use_case.dart';
import '../../../domain/usecases/get_user_current_location_usecase.dart';
import '../../../styles/styles.dart';

class HomeController extends GetxController {
  final GetUserCurrentLocationUsecase getUserCurrentLocationUsecase;
  final GetUserCurrentAddressUsecase getUserCurrentAddressUsecase;

  // Observables
  var currentLat = 0.0.obs;
  var currentLng = 0.0.obs;
  var address = ''.obs;
  var isLoadingLocation = true.obs;
  var locationError = Rxn<String>();

  // Private variables
  Position? currentPosition;
  Position? _previousPosition;
  Timer? _locationUpdateTimer;
  final Completer<GoogleMapController> controller = Completer();

  // Location update interval in seconds
  static const int _locationUpdateInterval = 5;
  // Threshold for location change detection (in degrees)
  static const double _locationChangeThreshold = 0.001;

  HomeController({
    required this.getUserCurrentLocationUsecase,
    required this.getUserCurrentAddressUsecase,
  });

  @override
  void onInit() {
    super.onInit();
    _initializeLocation();
  }

  @override
  void onClose() {
    _stopLocationUpdates();
    super.onClose();
  }

  /// Initialize location services
  Future<void> _initializeLocation() async {
    try {
      isLoadingLocation.value = true;
      locationError.value = null;

      await getUserCurrentLocation();
      await _startLocationUpdates();

      isLoadingLocation.value = false;
    } catch (e) {
      isLoadingLocation.value = false;
      locationError.value = 'Failed to initialize location: $e';
      _handleLocationError(e.toString());
    }
  }

  /// Request and handle location permissions
  Future<void> getUserCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      // Handle denied permission
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied) {
          _showPermissionDeniedSnackbar();
          throw Exception('Location permissions are denied');
        }
      }

      // Handle permanently denied permission
      if (permission == LocationPermission.deniedForever) {
        _showPermanentlyDeniedSnackbar();
        throw Exception('Location permissions are permanently denied');
      }

      // Permission granted, get initial location
      await _updateCurrentLocation();
      await animateCamera();
    } catch (e) {
      locationError.value = e.toString();
      rethrow;
    }
  }

  /// Update current location and address
  Future<void> _updateCurrentLocation() async {
    try {
      final locationData = await getUserCurrentAddressUsecase.call();

      currentLat.value = locationData.latitude;
      currentLng.value = locationData.longitude;
      address.value = locationData.address;

      currentPosition = Position(
        latitude: locationData.latitude,
        longitude: locationData.longitude,
        timestamp: DateTime.now(),
        accuracy: 0.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
        altitudeAccuracy: 0.0,
        headingAccuracy: 0.0,
      );
    } catch (e) {
      locationError.value = 'Failed to update location: $e';
      rethrow;
    }
  }

  /// Animate camera to current location
  Future<void> animateCamera() async {
    try {
      if (currentLat.value == 0.0 && currentLng.value == 0.0) {
        return;
      }

      final GoogleMapController mapController = await controller.future;
      final CameraPosition newCameraPos = CameraPosition(
        target: LatLng(currentLat.value, currentLng.value),
        zoom: 14.4746,
      );

      await mapController.animateCamera(
        CameraUpdate.newCameraPosition(newCameraPos),
      );
    } catch (e) {
      print('Error animating camera: $e');
    }
  }

  /// Start periodic location updates
  Future<void> _startLocationUpdates() async {
    _locationUpdateTimer?.cancel();

    _locationUpdateTimer = Timer.periodic(
      const Duration(seconds: _locationUpdateInterval),
      (_) => _periodicLocationUpdate(),
    );
  }

  /// Stop location updates
  void _stopLocationUpdates() {
    _locationUpdateTimer?.cancel();
    _locationUpdateTimer = null;
  }

  /// Periodic location update handler
  Future<void> _periodicLocationUpdate() async {
    try {
      final Position newPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );

      // Only update if location has changed significantly
      if (_previousPosition == null ||
          _hasLocationChanged(_previousPosition!, newPosition)) {
        _previousPosition = newPosition;
        currentLat.value = newPosition.latitude;
        currentLng.value = newPosition.longitude;

        // Update address
        await _updateAddress();
      }
    } catch (e) {
      print('Error in periodic location update: $e');
      locationError.value = 'Failed to update location';
    }
  }

  /// Update address based on current location
  Future<void> _updateAddress() async {
    try {
      final locationData = await getUserCurrentAddressUsecase.call();
      address.value = locationData.address;
    } catch (e) {
      print('Error updating address: $e');
    }
  }

  /// Check if location has changed significantly
  bool _hasLocationChanged(Position oldPosition, Position newPosition) {
    final double latDifference =
        (oldPosition.latitude - newPosition.latitude).abs();
    final double lngDifference =
        (oldPosition.longitude - newPosition.longitude).abs();

    return latDifference > _locationChangeThreshold ||
        lngDifference > _locationChangeThreshold;
  }

  /// Manually refresh location
  Future<void> refreshLocation() async {
    try {
      isLoadingLocation.value = true;
      await _updateCurrentLocation();
      await animateCamera();
      isLoadingLocation.value = false;
    } catch (e) {
      isLoadingLocation.value = false;
      _handleLocationError('Failed to refresh location');
    }
  }

  /// Handle location errors
  void _handleLocationError(String error) {
    Get.snackbar(
      'Location Error',
      error,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  /// Show permission denied snackbar
  void _showPermissionDeniedSnackbar() {
    Get.snackbar(
      'Permission Denied',
      'Location permissions are required to use this feature',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange.withOpacity(0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  /// Show permanently denied permission snackbar
  void _showPermanentlyDeniedSnackbar() {
    Get.snackbar(
      isDismissible: false,
      'Permission Required',
      'Please enable location permissions in app settings',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      duration: const Duration(seconds: 5),
      mainButton: TextButton(
        onPressed: () {
          Geolocator.openAppSettings();
          Get.back();
        },
        child: Text(
          'Open Settings',
          style: GoogleFonts.poppins(
            color: buttonText,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
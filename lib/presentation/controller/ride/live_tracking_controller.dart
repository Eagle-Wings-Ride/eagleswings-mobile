import 'dart:async';
import 'dart:ui' as ui;

import 'package:eaglerides/domain/entities/ride_map_direction_entity.dart';
import 'package:eaglerides/domain/usecases/direction_usecase.dart';
import 'package:eaglerides/domain/usecases/trip_payment_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../styles/styles.dart';

class LiveTrackingController extends GetxController {
  var liveLocLatitude = 0.0.obs;
  var liveLocLongitude = 0.0.obs;
  var destinationLat = 0.0.obs;
  var destinationLng = 0.0.obs;
  var vehicleTypeName = ''.obs;

  final RideMapDirectionUsecase rideMapDirectionUsecase;
  final TripPaymentUseCase tripPaymentUseCase;
  var uberMapDirectionData = <RideMapDirectionEntity>[].obs;
  var isLoading = true.obs;
  var markers = <Marker>[].obs;

  var isPaymentBottomSheetOpen = false.obs;
  var isPaymentDone = false.obs;

  var polylineCoordinates = <LatLng>[].obs;
  PolylinePoints polylinePoints = PolylinePoints();

  final Completer<GoogleMapController> controller = Completer();
  // final UberTripsHistoryController _uberTripsHistoryController = Get.find();

  LiveTrackingController({
    required this.rideMapDirectionUsecase,
    required this.tripPaymentUseCase,
  });

  getDirectionData(int index) async {
    // checkTripCompletionStatus(index);
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    // await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar(
          "Location permissions are denied",
          "Allow to use live tracking",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
        isDismissible: false,
        "Alert",
        "Location permissions are permanently denied. Please enable it in app settings.",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
        mainButton: TextButton(
          onPressed: () {
            Geolocator.openAppSettings();
          },
          child: Text(
            "Open Settings",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: buttonText,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    } else {
      if (liveLocLatitude.value == 0.0) {
        Get.snackbar(
          "Alert",
          "Turn on Location to use Live Tracking",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      Position position = await Geolocator.getCurrentPosition();
      liveLocLatitude.value = position.latitude;
      liveLocLongitude.value = position.longitude;
      // final driverId = _uberTripsHistoryController
      //     .tripsHistory.value[index].driverId!.path
      //     .split("/")
      //     .last
      //     .trim();
      // destinationLat.value = _uberTripsHistoryController
      //     .tripsHistory.value[index].destinationLocation!.latitude;
      // destinationLng.value = _uberTripsHistoryController
      //     .tripsHistory.value[index].destinationLocation!.longitude;
      // vehicleTypeName.value = _uberTripsHistoryController
      //     .tripDrivers.value[driverId]!.vehicle!.path
      //     .split("/")
      //     .first
      //     .trim();
      // await rideMapDirectionUsecase
      //     .call(
      //         position.latitude,
      //         position.longitude,
      //         _uberTripsHistoryController
      //             .tripsHistory.value[index].destinationLocation!.latitude,
      //         _uberTripsHistoryController
      //             .tripsHistory.value[index].destinationLocation!.longitude)
      //     .then((directionData) {
      //   uberMapDirectionData.value = directionData;
      //   isLoading.value = false;
      // });
      addMarkers(
          BitmapDescriptor.bytes(await getBytesFromAsset(
              vehicleTypeName.value == "cars"
                  ? 'assets/car.png'
                  : vehicleTypeName.value == "bikes"
                      ? 'assets/bike.png'
                      : 'assets/auto.png',
              85)),
          "live_marker",
          liveLocLatitude.value,
          liveLocLongitude.value,
          "Your Location");
      addMarkers(
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          "destination_marker",
          destinationLat.value,
          destinationLng.value,
          "Destination Location");
      addPolyLine();
    }
  }

  addPolyLine() async {
    List<PointLatLng> result = polylinePoints
        .decodePolyline(uberMapDirectionData[0].enCodedPoints.toString());
    polylineCoordinates.clear();
    for (var point in result) {
      polylineCoordinates.value.add(LatLng(point.latitude, point.longitude));
    }
    final GoogleMapController _controller = await controller.future;
    CameraPosition liveLoc = CameraPosition(
      target: LatLng(liveLocLatitude.value, liveLocLongitude.value),
      zoom: 16,
    );
    _controller.animateCamera(CameraUpdate.newCameraPosition(liveLoc));
  }

  // checkTripCompletionStatus(int index) {
  //   bool? isCompleted =
  //       _uberTripsHistoryController.tripsHistory.value[index].isCompleted;
  //   if (isCompleted == true) {
  //     isPaymentBottomSheetOpen.value = true;
  //     // Get.bottomSheet(
  //     //     SizedBox(
  //     //         height: 300,
  //     //         child: UberPaymentBottomSheet(
  //     //             tripHistoryEntity:
  //     //                 _uberTripsHistoryController.tripsHistory.value[index])),
  //     //     isDismissible: false,
  //     //     enableDrag: false);
  //   }
  // }

  makePayment(String riderId, String driverId, int tripAmount, String tripId,
      String payMode) async {
    String res = await tripPaymentUseCase.call(
        riderId, driverId, tripAmount, tripId, payMode);
    if (res == "done") {
      isPaymentDone.value = true;
      Get.snackbar('Done', "Payment successful");
    }
    return res;
  }

  addMarkers(
      icon, String markerId, double lat, double lng, String infoWindow) async {
    Marker marker = Marker(
        icon: icon,
        markerId: MarkerId(markerId),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: infoWindow));
    markers.add(marker);
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}

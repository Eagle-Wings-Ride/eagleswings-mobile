import 'dart:async';
import 'dart:ui' as ui;

import 'package:eaglerides/domain/entities/get_drivers_entity.dart';
import 'package:eaglerides/domain/entities/map_prediction_entity.dart';
import 'package:eaglerides/domain/entities/ride_map_direction_entity.dart';
import 'package:eaglerides/domain/usecases/cancel_trip_usecase.dart';
import 'package:eaglerides/domain/usecases/direction_usecase.dart';
import 'package:eaglerides/domain/usecases/generate_rental_charges_usecase.dart';
import 'package:eaglerides/domain/usecases/generate_trip_usecase.dart';
import 'package:eaglerides/domain/usecases/ride_map_prediction_usecase.dart';
import 'package:eaglerides/domain/usecases/vwhicle_detail_usecase.dart';
import 'package:eaglerides/presentation/screens/home/home.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../data/models/generate_trip_model.dart';

class RideController extends GetxController {
  final MapPredictionUsecase mapPredictionUsecase;
  final RideMapDirectionUsecase rideMapDirectionUsecase;
  // final GetDriversUsecase getDriversUsecase;
  final GetRentalChargesUseCase getRentalChargesUseCase;
  final GenerateTripUseCase generateTripUseCase;
  final GetVehicleDetailsUseCase getVehicleDetailsUseCase;
  final CancelTripUseCase cancelTripUseCase;

  var uberMapPredictionData = <MapPredictionEntity>[].obs;

  var uberMapDirectionData = <RideMapDirectionEntity>[].obs;
  var sourcePlaceName = "".obs;
  var destinationPlaceName = "".obs;
  var predictionListType = "source".obs;

  RxDouble sourceLatitude = 0.0.obs;
  RxDouble sourceLongitude = 0.0.obs;

  RxDouble destinationLatitude = 0.0.obs;
  RxDouble destinationLongitude = 0.0.obs;
  var availableDriversList = <DriverEntity>[].obs;

  // polyline
  var polylineCoordinates = <LatLng>[].obs;
  var polylineCoordinatesforacptDriver = <LatLng>[].obs;
  PolylinePoints polylinePoints = PolylinePoints();

  //markers
  // var markers = <String, Marker>{}.obs;
  var markers = <Marker>[].obs;

  var isPoliLineDraw = false.obs;
  var isReadyToDisplayAvlDriver = false.obs;

  var freelanceRent = 0.obs;
  var inHouseRent = 0.obs;
  var oneWayRent = 0.obs;
  var returnTripRent = 0.obs;
  var isDriverLoading = false.obs;
  var findDriverLoading = false.obs;
  var prevTripId = "xyz".obs;

  var reqAccepted = false.obs;

  var req_accepted_driver_and_vehicle_data = <String, String>{};

  final Completer<GoogleMapController> controller = Completer();
  late StreamSubscription subscription;

  RideController({
    required this.mapPredictionUsecase,
    required this.rideMapDirectionUsecase,
    // required this.getDriversusecase,
    required this.getRentalChargesUseCase,
    required this.generateTripUseCase,
    required this.getVehicleDetailsUseCase,
    required this.cancelTripUseCase,
    // required this.uberAuthGetUserUidUseCase,
  });

  getPredictions(String placeName, String predictiontype) async {
    uberMapPredictionData.clear();
    predictionListType.value = predictiontype;
    if (placeName != sourcePlaceName.value ||
        placeName != destinationPlaceName.value) {
      final predictionData = await mapPredictionUsecase.call(placeName);
      uberMapPredictionData.value = predictionData;
    }
  }

  setPlaceAndGetLocationDeatailsAndDirection(
      {required String sourcePlace, required String destinationPlace}) async {
    uberMapPredictionData.clear(); // clear list of suggestions
    // if (sourcePlace == "") {
    //   availableDriversList.clear();
    //   destinationPlaceName.value = destinationPlace;
    //   List<Location> destinationLocations =
    //       await locationFromAddress(destinationPlace); //get destination latlng
    //   print(destinationLocations);
    //   destinationLatitude.value = destinationLocations[0].latitude;
    //   destinationLongitude.value = destinationLocations[0].longitude;
    //   addMarkers(
    //       destinationLocations[0].latitude,
    //       destinationLocations[0].longitude,
    //       "destination_marker",
    //       BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    //       "default",
    //       "Destination Location");
    //   animateCamera(
    //       destinationLocations[0].latitude, destinationLocations[0].longitude);
    // } else {
    //   availableDriversList.clear();
    //   sourcePlaceName.value = sourcePlace;
    //   List<Location> sourceLocations =
    //       await locationFromAddress(sourcePlace); //get source latlng
    //   print(sourceLocations);
    //   sourceLatitude.value = sourceLocations[0].latitude;
    //   sourceLongitude.value = sourceLocations[0].longitude;
    //   addMarkers(
    //       sourceLocations[0].latitude,
    //       sourceLocations[0].longitude,
    //       "source_marker",
    //       BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    //       "default",
    //       "Source Location");
    //   animateCamera(sourceLocations[0].latitude, sourceLocations[0].longitude);
    // }
    // set place in textfield
    // if (sourcePlaceName.value.isNotEmpty &&
    //     destinationPlaceName.value.isNotEmpty) {
    // if (sourcePlaceName.value != destinationPlaceName.value) {
    //   getDirection();
    // } //get direction data
    // else {
    //   Get.snackbar("error", "both location can't be same!");
    // }
    // }
    if (sourcePlace.isEmpty) {
      await _handleDestinationPlace(destinationPlace);
    } else {
      await _handleSourcePlace(sourcePlace);
    }

    // set place in textfield
    if (sourcePlaceName.value.isNotEmpty &&
        destinationPlaceName.value.isNotEmpty) {
      if (sourcePlaceName.value != destinationPlaceName.value) {
        await getDirection();
      } else {
        Get.snackbar("Error", "Both locations can't be the same!");
      }
    }
  }

  Future<void> _handleDestinationPlace(String destinationPlace) async {
    availableDriversList.clear();
    destinationPlaceName.value = destinationPlace;

    try {
      List<Location> destinationLocations =
          await locationFromAddress(destinationPlace); // get destination latlng

      destinationLatitude.value = destinationLocations[0].latitude;
      destinationLongitude.value = destinationLocations[0].longitude;

      addMarkers(
        destinationLocations[0].latitude,
        destinationLocations[0].longitude,
        "destination_marker",
           "assets/images/secondMarker.png",
        "img",
        "Destination Location",
      );
      animateCamera(
        destinationLocations[0].latitude,
        destinationLocations[0].longitude,
      );
    } catch (e) {
      print('Error finding destination location: $e');
      Get.snackbar("Error", "Unable to find destination location");
    }
  }

  Future<void> _handleSourcePlace(String sourcePlace) async {
    availableDriversList.clear();
    sourcePlaceName.value = sourcePlace;

    try {
      List<Location> sourceLocations =
          await locationFromAddress(sourcePlace); // get source latlng

      sourceLatitude.value = sourceLocations[0].latitude;
      sourceLongitude.value = sourceLocations[0].longitude;

      addMarkers(
        sourceLocations[0].latitude,
        sourceLocations[0].longitude,
        "source_marker",
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        "default",
        "Source Location",
      );
      animateCamera(
        sourceLocations[0].latitude,
        sourceLocations[0].longitude,
      );
    } catch (e) {
      print('Error finding source location: $e');
      Get.snackbar("Error", "Unable to find source location");
    }
  }

  getDirection() async {
    availableDriversList.clear();
    final directionData = await rideMapDirectionUsecase.call(
        sourceLatitude.value,
        sourceLongitude.value,
        destinationLatitude.value,
        destinationLongitude.value);
    uberMapDirectionData.value = directionData;

    // get drivers
    isDriverLoading.value = true;
    // Stream<List<DriverEntity>> availableDriversData =
    //     getDriversUseCase.call();
    // availableDriversList.clear();
    // subscription = availableDriversData.listen((driverData) {
    //   // if (availableDriversList.length <= driverData.length) {
    //   availableDriversList.clear();
    //   if (markers.length > 2) {
    //     markers.removeRange(2, markers.length - 1);
    //   }
    //   for (int i = 0; i < driverData.length; i++) {
    //     if (Geolocator.distanceBetween(
    //             sourceLatitude.value,
    //             sourceLongitude.value,
    //             driverData[i].currentLocation!.latitude,
    //             driverData[i].currentLocation!.longitude) <
    //         5000) {
    //       availableDriversList.add(driverData[i]);
    //       addMarkers(
    //           driverData[i].currentLocation!.latitude,
    //           driverData[i].currentLocation!.longitude,
    //           i.toString(),
    //           driverData[i].vehicle!.path.split('/').first == "cars"
    //               ? 'assets/car.png'
    //               : driverData[i].vehicle!.path.split('/').first == "inHouses"
    //                   ? 'assets/inHouse.png'
    //                   : 'assets/oneWay.png',
    //           "img",
    //           "Driver Location");
    //     }
    //   }
    //   // }
    //   isDriverLoading.value = false;
    //   if (availableDriversList.isNotEmpty) {
    //     getRentalCharges();
    //     isPoliLineDraw.value = true;
    //   } else {
    //     isPoliLineDraw.value = false;
    //     Get.snackbar(
    //       "Sorry !",
    //       "No Rides available",
    //       snackPosition: SnackPosition.BOTTOM,
    //     );
    //     isReadyToDisplayAvlDriver.value = false;
    //   }
    // });

    animateCameraPolyline();
    getPolyLine();
  }

  getPolyLine() async {
    List<PointLatLng> result = polylinePoints
        .decodePolyline(uberMapDirectionData[0].enCodedPoints.toString());
    polylineCoordinates.clear();
    result.forEach((PointLatLng point) {
      polylineCoordinates.value.add(LatLng(point.latitude, point.longitude));
    });
    isPoliLineDraw.value = true;
  }

  addMarkers(double latitude, double longitude, String markerId, icon,
      String type, String infoWindow) async {
    Marker marker = Marker(
        icon: type == "img"
            ? BitmapDescriptor.fromBytes(await getBytesFromAsset(icon, 85))
            : icon,
        markerId: MarkerId(markerId),
        infoWindow: InfoWindow(title: infoWindow),
        position: LatLng(latitude, longitude));
    //markers[markerId] = marker;
    markers.add(marker);
  }

  getRentalCharges() async {
    final rentCharge = await getRentalChargesUseCase
        .call(uberMapDirectionData[0].distanceValue! / 1000.toDouble());
    freelanceRent.value = rentCharge.freelance.round();
    inHouseRent.value = rentCharge.inHouse.round();
    oneWayRent.value = rentCharge.oneWay.round();
    returnTripRent.value = rentCharge.returnTrip.round();
    isReadyToDisplayAvlDriver.value = true;
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

  animateCameraPolyline() async {
    animateCamera(sourceLatitude.value, sourceLongitude.value);
    final GoogleMapController _controller = await controller.future;

    _controller.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
            southwest: LatLng(sourceLatitude.value, sourceLongitude.value),
            northeast:
                LatLng(destinationLatitude.value, destinationLongitude.value)),
        50));
    animateCamera(sourceLatitude.value, sourceLongitude.value);
  }

  animateCamera(double lat, double lng) async {
    final GoogleMapController _controller = await controller.future;
    CameraPosition newPos = CameraPosition(
      target: LatLng(lat, lng),
      zoom: 17,
    );
    _controller.animateCamera(CameraUpdate.newCameraPosition(newPos));
  }

  generateTrip(DriverEntity driverData, int index) async {
    cancelTripUseCase.call(prevTripId.value, true); // if canceled
    subscription.pause();
    String vehicleType = driverData.vehicle!.path.split('/').first;
    String driverId = driverData.driverId.toString();
    String riderId = 'sdfdjgkfdsjfjfdbjkvskj';
    // String riderId = await uberAuthGetUserUidUseCase.call();
    // DocumentReference driverIdRef =
    //     FirebaseFirestore.instance.doc("/drivers/${driverId.trim()}");
    // DocumentReference riderIdRef =
    //     FirebaseFirestore.instance.doc("/riders/$riderId");
    var tripId = const Uuid().v4();
    prevTripId.value = tripId;
    final generateTripModel = GenerateTripModel(
        sourcePlaceName.value,
        destinationPlaceName.value,
        LatLng(sourceLatitude.value, sourceLongitude.value),
        LatLng(destinationLatitude.value, destinationLongitude.value),
        uberMapDirectionData[0].distanceValue! / 1000.roundToDouble(),
        uberMapDirectionData[0].durationText,
        false,
        DateTime.now().toString(),
        'driverIdRef',
        'riderIdRef',
        0.0,
        false,
        vehicleType == 'cars'
            ? freelanceRent.value
            : vehicleType == 'oneWay'
                ? oneWayRent.value
                : vehicleType == 'inHouse'
                    ? inHouseRent.value
                    : returnTripRent.value,
        false,
        false,
        tripId);
    Stream reqStatusData = generateTripUseCase.call(generateTripModel);
    findDriverLoading.value = true;
    late StreamSubscription tripSubscription;
    tripSubscription = reqStatusData.listen((data) async {
      final reqStatus = data.data()['ready_for_trip'];
      if (reqStatus) {
        subscription.cancel();
      }
      if (reqStatus && findDriverLoading.value) {
        subscription.cancel();
        final req_accepted_driver_vehicle_data = await getVehicleDetailsUseCase
            .call(vehicleType, driverId); // get vehicldata if req accepted
        req_accepted_driver_and_vehicle_data["name"] =
            driverData.name.toString();
        req_accepted_driver_and_vehicle_data["mobile"] =
            driverData.mobile.toString();
        req_accepted_driver_and_vehicle_data["vehicle_color"] =
            req_accepted_driver_vehicle_data.color;
        req_accepted_driver_and_vehicle_data["vehicle_model"] =
            req_accepted_driver_vehicle_data.model;
        req_accepted_driver_and_vehicle_data["vehicle_company"] =
            req_accepted_driver_vehicle_data.company;
        req_accepted_driver_and_vehicle_data["vehicle_number_plate"] =
            req_accepted_driver_vehicle_data.numberPlate.toString();
        req_accepted_driver_and_vehicle_data["profile_img"] =
            driverData.profile_img.toString();
        req_accepted_driver_and_vehicle_data["overall_rating"] =
            driverData.overall_rating.toString();
        if (markers.length > 2) {
          markers.removeRange(2, markers.length - 1);
        } // clear extra marker
        addMarkers(
            driverData.currentLocation!.latitude,
            driverData.currentLocation!.longitude,
            "acpt_driver_marker",
            driverData.vehicle!.path.split('/').first == "cars"
                ? 'assets/car.png'
                : driverData.vehicle!.path.split('/').first == "inHouses"
                    ? 'assets/inHouse.png'
                    : 'assets/oneWay.png',
            "img",
            "Driver Location"); // add only acpt_driver_marker

        // draw path from acpt_driver to consumer
        final directionData = await rideMapDirectionUsecase.call(
            driverData.currentLocation!.latitude,
            driverData.currentLocation!.longitude,
            sourceLatitude.value,
            sourceLongitude.value);
        List<PointLatLng> result = polylinePoints
            .decodePolyline(directionData[0].enCodedPoints.toString());
        polylineCoordinatesforacptDriver.clear();
        result.forEach((PointLatLng point) {
          polylineCoordinatesforacptDriver.value
              .add(LatLng(point.latitude, point.longitude));
        });
        if (findDriverLoading.value && reqAccepted.value == false) {
          findDriverLoading.value = false;
          Get.snackbar(
            "Yahoo!",
            "request accepted by driver,driver will arrive within 10 min",
          );
          reqAccepted.value = true;
        }
      } else if (data.data()['is_arrived'] && !data.data()['is_completed']) {
        Get.snackbar(
            "driver arrived!", "Now you can track from tripHistory page!",
            snackPosition: SnackPosition.BOTTOM);
        tripSubscription.cancel();
        Get.off(() => const HomePage());
      }
      Timer(const Duration(seconds: 60), () {
        if (reqStatus == false && findDriverLoading.value) {
          tripSubscription.cancel();
          cancelTripUseCase.call(tripId, false);
          // availableDriversList.value.removeAt(index);
          Get.snackbar(
              "Sorry !", "request denied by driver,please choose other driver",
              snackPosition: SnackPosition.BOTTOM);
          subscription.resume();
          findDriverLoading.value = false;
        }
      });
    });
  }
}

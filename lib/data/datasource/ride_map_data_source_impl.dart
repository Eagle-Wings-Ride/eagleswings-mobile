import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../config/map_api_key.dart';
import '../models/generate_trip_model.dart';
import '../models/ride_map_direction_model.dart';
import '../models/ride_prediction_model.dart';
import '../models/vehicle_details_model.dart';
import '../models/ride_charges_model.dart';
import 'ride_map_data_source.dart';

class RideMapDataSourceImpl extends RideMapDataSource {
  final http.Client client;
  static const baseUrl = 'maps.googleapis.com';

  RideMapDataSourceImpl({required this.client});

  @override
  Future<PredictionsList> getUberMapPrediction(String placeName) async {
    final autoCompleteUrl = Uri.https(
        baseUrl,
        '/maps/api/place/autocomplete/json',
        {'input': placeName, 'types': 'geocode', 'key': apiKey});
    final response = await client.get(
      autoCompleteUrl,
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return PredictionsList.fromJson(json.decode(response.body));
    } else {
      throw Exception();
    }
  }

  @override
  // Future<Direction?> getMapDirection(String origin, String destination) async {
  //   final url =
  //       'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$googleMapsApiKey';
  //   final response = await http.get(Uri.parse(url));

  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     print("API Response: $data"); // Debugging line

  //     if (data["status"] == "OK") {
  //       return Direction.fromJson(data);
  //     } else {
  //       print("Error in API response: ${data['status']}"); // Debugging line
  //     }
  //   } else {
  //     print(
  //         "Failed to fetch directions: ${response.statusCode}"); // Debugging line
  //   }

  //   return null;
  // }

  Future<Direction?> getMapDirection(double sourceLat, double sourceLng,
      double destinationLat, double destinationLng) async {
    final directionUrl = Uri.https(baseUrl, '/maps/api/directions/json', {
      'origin': "$sourceLat,$sourceLng",
      'destination': "$destinationLat, $destinationLng",
      'key': apiKey
    });
    final response = await client.get(
      directionUrl,
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("API Response: $data"); // Debugging line

      if (data["status"] == "OK") {
        return Direction.fromJson(data);
        // return Direction.fromJson(json.decode(response.body));
      } else {
        print("Error in API response: ${data['status']}"); // Debugging line
        // return null;
      }
    } else {
      print("Failed to fetch directions: ${response.statusCode}");
      // throw Exception();
    }
    return null;
  }

  // @override
  // Stream<List<DriverModel>> getAvailableDrivers() {
  //   final driverCollectionRef =
  //       firestore.collection("drivers").where('is_online', isEqualTo: true);
  //   //.where('city', isEqualTo: sourcePlaceName);

  //   return driverCollectionRef.snapshots().map((querySnap) {
  //     return querySnap.docs
  //         .map((docSnap) => DriverModel.fromSnapshot(docSnap))
  //         .toList();
  //   });
  // }

  @override
  Future<RentalChargeModel> getRentalChargeForVehicle(double kms) async {
    // final pricesCollection = firestore.collection("prices");
    // DocumentSnapshot charges = await pricesCollection.doc("vehicles").get();
    // //fetch per km charge from prices collection and multiply by kms
    // final double rickShawRent = kms * charges.get("auto_rickshaw");
    // final double carRent = kms * charges.get("car");
    // final double bikeRent = kms * charges.get("bike");

    // final vehicleRent = RentalChargeModel(
    //     freelance: rickShawRent, car: carRent, bike: bikeRent);
    // print(vehicleRent.car);
    final vehicleRent =
        RentalChargeModel(freelance: 0, inHouse: 0, oneWay: 0, returnTrip: 0);
    return vehicleRent;
  }

  @override
  Stream<void> generateTrip(GenerateTripModel generateTripModel) {
    // final genarateTripCollection = firestore.collection("trips");
    // genarateTripCollection.doc(generateTripModel.tripId).set({
    //   //isArrived
    //   'trip_id': generateTripModel.tripId,
    //   'destination': generateTripModel.destination,
    //   'destination_location': generateTripModel.destinationLocation,
    //   'distance': generateTripModel.distance,
    //   'driver_id': generateTripModel.driverId,
    //   'is_completed': generateTripModel.isCompleted,
    //   'trip_date': generateTripModel.tripDate,
    //   'rating': generateTripModel.rating,
    //   'rider_id': generateTripModel.riderId,
    //   'source': generateTripModel.source,
    //   'source_location': generateTripModel.sourceLocation,
    //   'travelling_time': generateTripModel.travellingTime,
    //   'ready_for_trip': generateTripModel.readyForTrip,
    //   'trip_amount': generateTripModel.tripAmount,
    //   'is_arrived': generateTripModel.isArrived,
    //   'is_payment_done': generateTripModel.isPaymentDone
    // });

    // return genarateTripCollection.doc(generateTripModel.tripId).snapshots();
    // return GenerateTripModel(
    //     'Lagos',
    //     'Ikeja',
    //     'Lagos',
    //     'ikeja',
    //     24.0,
    //     '12:00',
    //     true,
    //     'December',
    //     'driverId',
    //     'riderId',
    //     2.4,
    //     true,
    //     200,
    //     true,
    //     true,
    //     'tripId');
    return Stream.empty();
  }

  @override
  Future<VehicleModel> getVehicleDetails(
      String vehicleType, String driverId) async {
    // final vehicleCollectionRef = firestore.collection(vehicleType);

    // return vehicleCollectionRef
    //     .doc(driverId)
    //     .get()
    //     .then((value) => VehicleModel.fromMap(value.data()));
    return VehicleModel(color: 'color', company: 'company', model: 'model');
  }

  @override
  Future<void> cancelTrip(String tripId, bool isNewTripGeneration) async {
    // try {
    //   final genarateTripCollection = firestore.collection("trips");
    //   if (!isNewTripGeneration) {
    //     await genarateTripCollection.doc(tripId).update({'driver_id': null});
    //   } else {
    //     await genarateTripCollection.doc(tripId).get().then((value) async {
    //       if (value.data()!['ready_for_trip'] == false) {
    //         await genarateTripCollection.doc(tripId).delete();
    //       }
    //     });
    //   }
    // } on FirebaseException catch (e) {
    //   Get.snackbar("Error", e.code.toString());
    // }
  }

  @override
  Future<String> tripPayment(String riderId, String driverId, int tripAmount,
      String tripId, String payMode) async {
    // var res = "".obs;
    // var riderAmt = 0.obs;
    // var driverAmt = 0.obs;
    // if (payMode == "wallet") {
    //   await firestore.collection("riders").doc(riderId).get().then((value) {
    //     riderAmt.value = value.get('wallet');
    //   }).whenComplete(() async {
    //     await firestore.collection("drivers").doc(driverId).get().then((value) {
    //       driverAmt.value = value.get('wallet').round();
    //     });
    //   }).whenComplete(() async {
    //     if (riderAmt.value < tripAmount) {
    //       res.value = "low_balance";
    //     } else {
    //       await firestore.collection("riders").doc(riderId).update(
    //           {'wallet': riderAmt.value - tripAmount}).whenComplete(() async {
    //         await firestore
    //             .collection("drivers")
    //             .doc(driverId)
    //             .update({'wallet': driverAmt.value + tripAmount}).whenComplete(
    //                 () async {
    //           await firestore
    //               .collection("trips")
    //               .doc(tripId)
    //               .update({'is_payment_done': true}).whenComplete(() {
    //             res.value = "done";
    //           });
    //         });
    //       });
    //     }
    //   });
    // } else {
    //   await firestore
    //       .collection("trips")
    //       .doc(tripId)
    //       .update({'is_payment_done': true}).whenComplete(() {
    //     res.value = "done";
    //   });
    // }
    // return Future.value(res.value);
    return '';
  }
}

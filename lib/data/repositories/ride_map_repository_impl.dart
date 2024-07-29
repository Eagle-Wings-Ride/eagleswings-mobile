import 'package:eaglerides/data/datasource/ride_map_data_source.dart';

import '../../domain/entities/map_prediction_entity.dart';
import '../../domain/entities/ride_map_direction_entity.dart';
import '../../domain/repositories/ride_map_repository.dart';
import '../models/generate_trip_model.dart';
import '../models/ride_charges_model.dart';
import '../models/vehicle_details_model.dart';

class RideMapRepositoryImpl extends RideMapRepository {
  final RideMapDataSource rideMapDataSource;

  RideMapRepositoryImpl({required this.rideMapDataSource});

  @override
  Future<List<MapPredictionEntity>> getUberMapPrediction(
      String placeName) async {
    final predictionsList =
        await rideMapDataSource.getUberMapPrediction(placeName);
    List<MapPredictionEntity> mapPredictionEntityList = [];
    for (int i = 0; i < predictionsList.predictions!.length; i++) {
      final data = MapPredictionEntity(
          secondaryText: predictionsList
              .predictions![i].structuredFormatting!.secondaryText,
          mainText:
              predictionsList.predictions![i].structuredFormatting!.mainText,
          placeId: predictionsList.predictions![i].placeId);
      mapPredictionEntityList.add(data);
    }
    return mapPredictionEntityList;
  }

  @override
  Future<List<RideMapDirectionEntity>> getMapDirection(double sourceLat,
      double sourceLng, double destinationLat, double destinationLng) async {
    final directionList = await rideMapDataSource.getMapDirection(
        sourceLat, sourceLng, destinationLat, destinationLng);
    List<RideMapDirectionEntity> rideMapDirectionEntityList = [];
    for (int i = 0; i < directionList!.routes!.length; i++) {
      final directionData = RideMapDirectionEntity(
          distanceValue: directionList.routes![0].legs![0].distance!.value,
          durationValue: directionList.routes![0].legs![0].duration!.value,
          distanceText: directionList.routes![0].legs![0].distance!.text,
          durationText: directionList.routes![0].legs![0].duration!.text,
          enCodedPoints: directionList.routes![0].overviewPolyline!.points);
      rideMapDirectionEntityList.add(directionData);
    }

    return rideMapDirectionEntityList;
  }

  // @override
  // Stream<List<DriverModel>> getAvailableDrivers() {
  //   return rideMapDataSource.getAvailableDrivers();
  // }

  @override
  Future<RentalChargeModel> getRentalChargeForVehicle(double kms) async {
    return await rideMapDataSource.getRentalChargeForVehicle(kms);
  }

  @override
  Stream generateTrip(GenerateTripModel generateTripModel) {
    return rideMapDataSource.generateTrip(generateTripModel);
  }

  @override
  Future<VehicleModel> getVehicleDetails(
      String vehicleType, String driverId) async {
    return await rideMapDataSource.getVehicleDetails(vehicleType, driverId);
  }

  @override
  Future<void> cancelTrip(String tripId, bool isNewTripGeneration) async {
    return await rideMapDataSource.cancelTrip(tripId, isNewTripGeneration);
  }

  @override
  Future<String> tripPayment(String riderId, String driverId, int tripAmount,
      String tripId, String payMode) async {
    return await rideMapDataSource.tripPayment(
        riderId, driverId, tripAmount, tripId, payMode);
  }
}

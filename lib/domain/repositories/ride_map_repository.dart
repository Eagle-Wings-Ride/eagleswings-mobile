import '../../data/models/generate_trip_model.dart';
import '../../data/models/ride_charges_model.dart';
import '../../data/models/vehicle_details_model.dart';
import '../entities/map_prediction_entity.dart';
import '../entities/ride_map_direction_entity.dart';

abstract class RideMapRepository {
  Future<List<MapPredictionEntity>> getUberMapPrediction(String placeName);

  Future<List<RideMapDirectionEntity>> getMapDirection(double sourceLat,
      double sourceLng, double destinationLat, double destinationLng);

  // Stream<List<DriverEntity>> getAvailableDrivers();

  Future<RentalChargeModel> getRentalChargeForVehicle(double kms);

  Stream generateTrip(GenerateTripModel generateTripModel);

  Future<VehicleModel> getVehicleDetails(String vehicleType, String driverId);

  Future<void> cancelTrip(String tripId, bool isNewTripGeneration);

  Future<String> tripPayment(String riderId, String driverId, int tripAmount,
      String tripId, String payMode);
}

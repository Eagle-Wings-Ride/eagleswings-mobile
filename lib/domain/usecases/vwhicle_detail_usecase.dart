import '../../data/models/vehicle_details_model.dart';
import '../repositories/ride_map_repository.dart';

class GetVehicleDetailsUseCase {
  final RideMapRepository rideMapRepository;

  GetVehicleDetailsUseCase({required this.rideMapRepository});

  Future<VehicleModel> call(String vehicleType, String driverId) {
    return rideMapRepository.getVehicleDetails(vehicleType, driverId);
  }
}

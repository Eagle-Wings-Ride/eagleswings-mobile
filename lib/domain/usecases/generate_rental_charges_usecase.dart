import '../../data/models/ride_charges_model.dart';
import '../repositories/ride_map_repository.dart';

class GetRentalChargesUseCase {
  final RideMapRepository rideMapRepository;

  GetRentalChargesUseCase({required this.rideMapRepository});

  Future<RentalChargeModel> call(double kms) async {
    return await rideMapRepository.getRentalChargeForVehicle(kms);
  }
}

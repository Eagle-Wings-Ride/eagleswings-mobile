import '../../data/models/generate_trip_model.dart';
import '../repositories/ride_map_repository.dart';

class GenerateTripUseCase {
  final RideMapRepository rideMapRepository;

  GenerateTripUseCase({required this.rideMapRepository});

  Stream call(GenerateTripModel generateTripModel) {
    return rideMapRepository.generateTrip(generateTripModel);
  }
}

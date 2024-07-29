
import 'package:eaglerides/domain/repositories/ride_map_repository.dart';

class CancelTripUseCase {
  final RideMapRepository rideMapRepository;

  CancelTripUseCase({required this.rideMapRepository});

  Future<void> call(String tripId, bool isNewTripGeneration) async {
    return await rideMapRepository.cancelTrip(tripId, isNewTripGeneration);
  }
}

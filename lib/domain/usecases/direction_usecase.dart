import '../entities/ride_map_direction_entity.dart';
import '../repositories/ride_map_repository.dart';

class RideMapDirectionUsecase {
  final RideMapRepository rideMapRepository;

  RideMapDirectionUsecase({required this.rideMapRepository});

  Future<List<RideMapDirectionEntity>> call(double sourceLat, double sourceLng,
      double destinationLat, double destinationLng) async {
    return await rideMapRepository.getMapDirection(
        sourceLat, sourceLng, destinationLat, destinationLng);
  }
}

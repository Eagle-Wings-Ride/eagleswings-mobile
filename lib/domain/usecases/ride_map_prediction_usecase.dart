import '../entities/map_prediction_entity.dart';
import '../repositories/ride_map_repository.dart';

class MapPredictionUsecase {
  final RideMapRepository rideMapRepository;

  MapPredictionUsecase({required this.rideMapRepository});

  Future<List<MapPredictionEntity>> call(String placeName) async {
    return await rideMapRepository.getUberMapPrediction(placeName);
  }
}

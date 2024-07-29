import '../repositories/ride_map_repository.dart';

class TripPaymentUseCase {
  final RideMapRepository rideMapRepository;

  TripPaymentUseCase({required this.rideMapRepository});

  Future<String> call(String riderId, String driverId, int tripAmount,
      String tripId, String payMode) async {
    return await rideMapRepository.tripPayment(
        riderId, driverId, tripAmount, tripId, payMode);
  }
}

import 'package:eaglerides/domain/repositories/auth_repository.dart';

class FetchRecentRidesUseCase {
  final EagleRidesAuthRepository eagleRidesAuthRepository;

  FetchRecentRidesUseCase({required this.eagleRidesAuthRepository});

  Future<List<Map<String, dynamic>>> call(String childId) async {
    return await eagleRidesAuthRepository.fetchRecentRides(childId);
  }
}

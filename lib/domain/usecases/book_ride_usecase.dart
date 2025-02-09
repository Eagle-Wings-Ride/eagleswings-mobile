import 'package:eaglerides/domain/repositories/auth_repository.dart';

class BookRideUseCase {
  final EagleRidesAuthRepository eagleRidesAuthRepository;

  BookRideUseCase({required this.eagleRidesAuthRepository});

  Future<String> call(Map<String, dynamic> requestBody, String childId) async {
    return await eagleRidesAuthRepository.bookRide(requestBody, childId);
  }
}

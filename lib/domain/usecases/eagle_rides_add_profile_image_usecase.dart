import '../repositories/auth_repository.dart';

class EagleRidesAddProfileImgUseCase {
  final EagleRidesAuthRepository eagleRidesAuthRepository;

  EagleRidesAddProfileImgUseCase({required this.eagleRidesAuthRepository});

  Future<String> call(String riderId) async {
    return await eagleRidesAuthRepository.eagleRidesAddProfileImg(riderId);
  }
}

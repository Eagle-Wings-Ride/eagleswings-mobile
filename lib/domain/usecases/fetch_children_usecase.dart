import 'package:eaglerides/domain/repositories/auth_repository.dart';

class FetchChildrenUseCase {
  final EagleRidesAuthRepository eagleRidesAuthRepository;

  FetchChildrenUseCase({required this.eagleRidesAuthRepository});

  Future<List<dynamic>> call() async {
    return await eagleRidesAuthRepository.fetchChildren();
  }
}

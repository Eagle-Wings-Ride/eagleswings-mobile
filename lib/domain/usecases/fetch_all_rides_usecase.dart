import '../repositories/auth_repository.dart';

class FetchAllRidesUseCase {
  final EagleRidesAuthRepository repository;

  FetchAllRidesUseCase(this.repository);

  Future<List<dynamic>> call() async {
    return await repository.fetchAllRides();
  }
}
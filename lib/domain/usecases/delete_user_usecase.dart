import '../repositories/auth_repository.dart';

class DeleteUserUseCase {
  final EagleRidesAuthRepository repository;

  DeleteUserUseCase(this.repository);

  Future<void> call(String userId) async {
    await repository.deleteUser(userId);
  }
}

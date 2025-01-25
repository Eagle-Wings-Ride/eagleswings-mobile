import 'package:eaglerides/domain/repositories/auth_repository.dart';

import '../../data/models/child_model.dart';

class FetchChildrenUseCase {
  final EagleRidesAuthRepository eagleRidesAuthRepository;

  FetchChildrenUseCase({required this.eagleRidesAuthRepository});

  Future<List<dynamic>> call(String userId) async {
    return await eagleRidesAuthRepository.fetchChildren(userId);
  }
}

import 'package:eaglerides/domain/repositories/auth_repository.dart';
import 'package:eaglerides/data/models/child_upsert_request.dart';

class AddChildUseCase {
  final EagleRidesAuthRepository eagleRidesAuthRepository;

  AddChildUseCase({required this.eagleRidesAuthRepository});

  Future<String> call(ChildUpsertRequest requestBody) async {
    return await eagleRidesAuthRepository.addChild(requestBody);
  }
}

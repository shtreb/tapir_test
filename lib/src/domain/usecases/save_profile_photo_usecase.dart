import 'package:injectable/injectable.dart';
import 'package:tapir_test/src/domain/entities/user_entity.dart';
import 'package:tapir_test/src/domain/repositories/auth_repository_interface.dart';

@injectable
class SaveProfilePhotoUseCase {
  const SaveProfilePhotoUseCase(this._repository);

  final IAuthRepository _repository;

  Future<UserEntity> call(UserEntity user, String photoPath) async {
    final updated = user.copyWith(photoPath: photoPath);
    await _repository.saveUser(updated);
    return updated;
  }
}

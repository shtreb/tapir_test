import 'package:injectable/injectable.dart';
import 'package:tapir_test/src/domain/entities/user_entity.dart';
import 'package:tapir_test/src/domain/repositories/auth_repository_interface.dart';

@injectable
class RestoreSessionUseCase {
  const RestoreSessionUseCase(this._repository);

  final IAuthRepository _repository;

  UserEntity? call() {
    return _repository.getCurrentUser();
  }
}

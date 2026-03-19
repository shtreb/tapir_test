import 'package:injectable/injectable.dart';
import 'package:tapir_test/src/domain/repositories/auth_repository_interface.dart';

@injectable
class LogoutUserUseCase {
  const LogoutUserUseCase(this._repository);

  final IAuthRepository _repository;

  Future<void> call() async {
    await _repository.clearUser();
  }
}

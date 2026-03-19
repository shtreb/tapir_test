import 'package:injectable/injectable.dart';
import 'package:tapir_test/src/domain/entities/user_entity.dart';
import 'package:tapir_test/src/domain/repositories/auth_repository_interface.dart';

@injectable
class LoginWithCredentialsUseCase {
  const LoginWithCredentialsUseCase(this._repository);

  final IAuthRepository _repository;

  Future<UserEntity?> call(String email, String code) async {
    return await _repository.loginWithEmailAndCode(email, code);
  }
}

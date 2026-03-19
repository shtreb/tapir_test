import 'package:injectable/injectable.dart';
import 'package:tapir_test/src/domain/repositories/auth_repository_interface.dart';

@injectable
class VerifyRegistrationCodeUseCase {
  const VerifyRegistrationCodeUseCase(this._repository);

  final IAuthRepository _repository;

  Future<bool> call(String code) async {
    return await _repository.verifyRegistrationCode(code);
  }
}

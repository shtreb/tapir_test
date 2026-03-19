import 'package:injectable/injectable.dart';
import 'package:tapir_test/src/domain/repositories/auth_repository_interface.dart';

@injectable
class GeneratePairCodeUseCase {
  const GeneratePairCodeUseCase(this._repository);

  final IAuthRepository _repository;

  String call() {
    return _repository.generatePairCode();
  }
}

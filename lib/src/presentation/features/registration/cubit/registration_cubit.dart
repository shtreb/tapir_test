import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tapir_test/src/core/validators/age_validator.dart';
import 'package:tapir_test/src/core/validators/email_validator.dart';
import 'package:tapir_test/src/core/validators/name_validator.dart';
import 'package:tapir_test/src/domain/entities/user_entity.dart';
import 'package:tapir_test/src/domain/usecases/generate_pair_code_usecase.dart';
import 'package:tapir_test/src/domain/usecases/verify_registration_code_usecase.dart';

part 'registration_state.dart';

@injectable
class RegistrationCubit extends Cubit<RegistrationState> {
  RegistrationCubit(
    this._verifyRegistrationCodeUseCase,
    this._generatePairCodeUseCase,
  ) : super(const RegistrationState());

  final VerifyRegistrationCodeUseCase _verifyRegistrationCodeUseCase;
  final GeneratePairCodeUseCase _generatePairCodeUseCase;

  void nextStep() => emit(state.copyWith(step: state.step + 1));
  
  void previousStep() => emit(state.copyWith(step: state.step > 0 ? state.step - 1 : 0));
  
  void setGender(String gender) => emit(state.copyWith(gender: gender));
  
  void setName(String name) => emit(state.copyWith(name: name));
  
  void setEmail(String email) => emit(state.copyWith(email: email));
  
  void setBirthDate(DateTime date) => emit(state.copyWith(birthDate: date));
  
  void setCode(String code) => emit(state.copyWith(code: code));

  Future<bool> verifyCode() async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      final isValid = await _verifyRegistrationCodeUseCase(state.code);
      emit(state.copyWith(isLoading: false));
      
      if (!isValid) {
        emit(state.copyWith(error: 'Неверный код подтверждения'));
      }
      
      return isValid;
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
      return false;
    }
  }

  UserEntity buildUser() {
    final birthDate = state.birthDate ?? DateTime(1990);
    return UserEntity(
      email: state.email.trim(),
      name: state.name.trim(),
      birthDate: birthDate,
      gender: state.gender,
      code: _generatePairCodeUseCase(),
    );
  }
}

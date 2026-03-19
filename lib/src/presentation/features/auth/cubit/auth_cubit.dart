import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tapir_test/src/domain/entities/user_entity.dart';
import 'package:tapir_test/src/domain/usecases/authorize_user_usecase.dart';
import 'package:tapir_test/src/domain/usecases/login_with_credentials_usecase.dart';
import 'package:tapir_test/src/domain/usecases/logout_user_usecase.dart';
import 'package:tapir_test/src/domain/usecases/restore_session_usecase.dart';

part 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(
    this._restoreSessionUseCase,
    this._authorizeUserUseCase,
    this._loginWithCredentialsUseCase,
    this._logoutUserUseCase,
  ) : super(AuthLoading()) {
    bootstrap();
  }

  final RestoreSessionUseCase _restoreSessionUseCase;
  final AuthorizeUserUseCase _authorizeUserUseCase;
  final LoginWithCredentialsUseCase _loginWithCredentialsUseCase;
  final LogoutUserUseCase _logoutUserUseCase;

  Future<void> bootstrap() async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      final user = _restoreSessionUseCase();
      if (user == null) {
        emit(Unauthorized());
        return;
      }
      emit(Authorized(user));
    } catch (e) {
      emit(Unauthorized());
    }
  }

  Future<void> authorize(UserEntity user) async {
    try {
      await _authorizeUserUseCase(user);
      emit(Authorized(user));
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> loginWithEmailAndCode(String email, String code) async {
    try {
      final user = await _loginWithCredentialsUseCase(email, code);
      if (user != null) {
        emit(Authorized(user));
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _logoutUserUseCase();
      emit(Unauthorized());
    } catch (e) {
      rethrow;
    }
  }
}

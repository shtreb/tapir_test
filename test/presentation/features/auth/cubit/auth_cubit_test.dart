import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tapir_test/src/domain/entities/user_entity.dart';
import 'package:tapir_test/src/domain/usecases/authorize_user_usecase.dart';
import 'package:tapir_test/src/domain/usecases/login_with_credentials_usecase.dart';
import 'package:tapir_test/src/domain/usecases/logout_user_usecase.dart';
import 'package:tapir_test/src/domain/usecases/restore_session_usecase.dart';
import 'package:tapir_test/src/presentation/features/auth/cubit/auth_cubit.dart';

class MockRestoreSessionUseCase extends Mock implements RestoreSessionUseCase {}
class MockAuthorizeUserUseCase extends Mock implements AuthorizeUserUseCase {}
class MockLoginWithCredentialsUseCase extends Mock implements LoginWithCredentialsUseCase {}
class MockLogoutUserUseCase extends Mock implements LogoutUserUseCase {}

void main() {
  late AuthCubit authCubit;
  late MockRestoreSessionUseCase mockRestoreSession;
  late MockAuthorizeUserUseCase mockAuthorizeUser;
  late MockLoginWithCredentialsUseCase mockLoginWithCredentials;
  late MockLogoutUserUseCase mockLogoutUser;

  setUp(() {
    mockRestoreSession = MockRestoreSessionUseCase();
    mockAuthorizeUser = MockAuthorizeUserUseCase();
    mockLoginWithCredentials = MockLoginWithCredentialsUseCase();
    mockLogoutUser = MockLogoutUserUseCase();
  });

  setUpAll(() {
    registerFallbackValue(UserEntity(
      email: 'test@example.com',
      name: 'Test',
      birthDate: DateTime(1990),
      gender: 'female',
      code: 'ABC123',
    ));
  });

  group('AuthCubit', () {
    final testUser = UserEntity(
      email: 'test@example.com',
      name: 'Test User',
      birthDate: DateTime(1990, 1, 1),
      gender: 'female',
      code: 'ABC123',
    );

    test('начальное состояние должно быть AuthLoading', () {
      when(() => mockRestoreSession()).thenReturn(null);
      
      authCubit = AuthCubit(
        mockRestoreSession,
        mockAuthorizeUser,
        mockLoginWithCredentials,
        mockLogoutUser,
      );

      expect(authCubit.state, isA<AuthLoading>());
    });

    blocTest<AuthCubit, AuthState>(
      'bootstrap должен emit Unauthorized если нет сохраненного пользователя',
      build: () {
        when(() => mockRestoreSession()).thenReturn(null);
        return AuthCubit(
          mockRestoreSession,
          mockAuthorizeUser,
          mockLoginWithCredentials,
          mockLogoutUser,
        );
      },
      wait: const Duration(milliseconds: 200),
      expect: () => <AuthState>[Unauthorized()],
    );

    blocTest<AuthCubit, AuthState>(
      'bootstrap должен emit Authorized если есть сохраненный пользователь',
      build: () {
        when(() => mockRestoreSession()).thenReturn(testUser);
        return AuthCubit(
          mockRestoreSession,
          mockAuthorizeUser,
          mockLoginWithCredentials,
          mockLogoutUser,
        );
      },
      wait: const Duration(milliseconds: 200),
      expect: () => <AuthState>[Authorized(testUser)],
    );

    blocTest<AuthCubit, AuthState>(
      'authorize должен сохранить пользователя и emit Authorized',
      build: () {
        when(() => mockRestoreSession()).thenReturn(null);
        when(() => mockAuthorizeUser(any())).thenAnswer((_) async {});
        return AuthCubit(
          mockRestoreSession,
          mockAuthorizeUser,
          mockLoginWithCredentials,
          mockLogoutUser,
        );
      },
      act: (cubit) async {
        await Future<void>.delayed(const Duration(milliseconds: 200));
        await cubit.authorize(testUser);
      },
      expect: () => <AuthState>[
        Unauthorized(),
        Authorized(testUser),
      ],
      verify: (_) {
        verify(() => mockAuthorizeUser(testUser)).called(1);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'loginWithEmailAndCode должен вернуть true и emit Authorized при успехе',
      build: () {
        when(() => mockRestoreSession()).thenReturn(null);
        when(() => mockLoginWithCredentials(any(), any())).thenAnswer((_) async => testUser);
        return AuthCubit(
          mockRestoreSession,
          mockAuthorizeUser,
          mockLoginWithCredentials,
          mockLogoutUser,
        );
      },
      act: (cubit) async {
        await Future<void>.delayed(const Duration(milliseconds: 200));
        return await cubit.loginWithEmailAndCode('test@example.com', 'ABC123');
      },
      expect: () => <AuthState>[
        Unauthorized(),
        Authorized(testUser),
      ],
      verify: (_) {
        verify(() => mockLoginWithCredentials('test@example.com', 'ABC123')).called(1);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'logout должен очистить данные и emit Unauthorized',
      build: () {
        when(() => mockRestoreSession()).thenReturn(testUser);
        when(() => mockLogoutUser()).thenAnswer((_) async {});
        return AuthCubit(
          mockRestoreSession,
          mockAuthorizeUser,
          mockLoginWithCredentials,
          mockLogoutUser,
        );
      },
      act: (cubit) async {
        await Future<void>.delayed(const Duration(milliseconds: 200));
        await cubit.logout();
      },
      expect: () => <AuthState>[
        Authorized(testUser),
        Unauthorized(),
      ],
      verify: (_) {
        verify(() => mockLogoutUser()).called(1);
      },
    );
  });
}

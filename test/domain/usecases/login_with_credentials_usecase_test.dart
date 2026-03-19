import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tapir_test/src/domain/entities/user_entity.dart';
import 'package:tapir_test/src/domain/repositories/auth_repository_interface.dart';
import 'package:tapir_test/src/domain/usecases/login_with_credentials_usecase.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late LoginWithCredentialsUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginWithCredentialsUseCase(mockRepository);
  });

  group('LoginWithCredentialsUseCase', () {
    const testEmail = 'test@example.com';
    const testCode = 'ABC123';
    final testUser = UserEntity(
      email: testEmail,
      name: 'Test User',
      birthDate: DateTime(1990, 1, 1),
      gender: 'female',
      code: testCode,
    );

    test('должен вернуть пользователя при правильных credentials', () async {
      // Arrange
      when(() => mockRepository.loginWithEmailAndCode(testEmail, testCode))
          .thenAnswer((_) async => testUser);

      // Act
      final result = await useCase(testEmail, testCode);

      // Assert
      expect(result, equals(testUser));
      verify(() => mockRepository.loginWithEmailAndCode(testEmail, testCode)).called(1);
    });

    test('должен вернуть null при неправильных credentials', () async {
      // Arrange
      when(() => mockRepository.loginWithEmailAndCode(testEmail, 'WRONG'))
          .thenAnswer((_) async => null);

      // Act
      final result = await useCase(testEmail, 'WRONG');

      // Assert
      expect(result, isNull);
      verify(() => mockRepository.loginWithEmailAndCode(testEmail, 'WRONG')).called(1);
    });
  });
}

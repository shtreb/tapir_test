import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tapir_test/src/domain/entities/user_entity.dart';
import 'package:tapir_test/src/domain/repositories/auth_repository_interface.dart';
import 'package:tapir_test/src/domain/usecases/restore_session_usecase.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late RestoreSessionUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = RestoreSessionUseCase(mockRepository);
  });

  group('RestoreSessionUseCase', () {
    final testUser = UserEntity(
      email: 'test@example.com',
      name: 'Test User',
      birthDate: DateTime(1990, 1, 1),
      gender: 'female',
      code: 'ABC123',
      photoPath: '/path/to/photo.jpg',
    );

    test('должен вернуть пользователя, если сессия существует', () {
      // Arrange
      when(() => mockRepository.getCurrentUser()).thenReturn(testUser);

      // Act
      final result = useCase();

      // Assert
      expect(result, equals(testUser));
      verify(() => mockRepository.getCurrentUser()).called(1);
    });

    test('должен вернуть null, если сессия не существует', () {
      // Arrange
      when(() => mockRepository.getCurrentUser()).thenReturn(null);

      // Act
      final result = useCase();

      // Assert
      expect(result, isNull);
      verify(() => mockRepository.getCurrentUser()).called(1);
    });
  });
}

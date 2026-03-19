import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tapir_test/src/domain/usecases/generate_pair_code_usecase.dart';
import 'package:tapir_test/src/domain/usecases/verify_registration_code_usecase.dart';
import 'package:tapir_test/src/presentation/features/registration/cubit/registration_cubit.dart';

class MockVerifyRegistrationCodeUseCase extends Mock implements VerifyRegistrationCodeUseCase {}
class MockGeneratePairCodeUseCase extends Mock implements GeneratePairCodeUseCase {}

void main() {
  late RegistrationCubit registrationCubit;
  late MockVerifyRegistrationCodeUseCase mockVerifyCode;
  late MockGeneratePairCodeUseCase mockGenerateCode;

  setUp(() {
    mockVerifyCode = MockVerifyRegistrationCodeUseCase();
    mockGenerateCode = MockGeneratePairCodeUseCase();
    registrationCubit = RegistrationCubit(mockVerifyCode, mockGenerateCode);
  });

  group('RegistrationCubit', () {
    test('начальное состояние должно быть пустым', () {
      expect(registrationCubit.state, equals(const RegistrationState()));
    });

    blocTest<RegistrationCubit, RegistrationState>(
      'setEmail должен обновить email в состоянии',
      build: () => registrationCubit,
      act: (cubit) => cubit.setEmail('test@example.com'),
      expect: () => <RegistrationState>[
        const RegistrationState(email: 'test@example.com'),
      ],
    );

    blocTest<RegistrationCubit, RegistrationState>(
      'setName должен обновить name в состоянии',
      build: () => registrationCubit,
      act: (cubit) => cubit.setName('John Doe'),
      expect: () => <RegistrationState>[
        const RegistrationState(name: 'John Doe'),
      ],
    );

    blocTest<RegistrationCubit, RegistrationState>(
      'nextStep должен увеличить step',
      build: () => registrationCubit,
      act: (cubit) => cubit.nextStep(),
      expect: () => <RegistrationState>[
        const RegistrationState(step: 1),
      ],
    );

    blocTest<RegistrationCubit, RegistrationState>(
      'previousStep должен уменьшить step',
      build: () => registrationCubit,
      seed: () => const RegistrationState(step: 2),
      act: (cubit) => cubit.previousStep(),
      expect: () => <RegistrationState>[
        const RegistrationState(step: 1),
      ],
    );

    blocTest<RegistrationCubit, RegistrationState>(
      'verifyCode должен вернуть true при валидном коде',
      build: () {
        when(() => mockVerifyCode(any())).thenAnswer((_) async => true);
        return registrationCubit;
      },
      seed: () => const RegistrationState(code: 'ABC123'),
      act: (cubit) => cubit.verifyCode(),
      expect: () => <RegistrationState>[
        const RegistrationState(code: 'ABC123', isLoading: true, error: null),
        const RegistrationState(code: 'ABC123', isLoading: false),
      ],
      verify: (_) {
        verify(() => mockVerifyCode('ABC123')).called(1);
      },
    );

    blocTest<RegistrationCubit, RegistrationState>(
      'verifyCode должен вернуть false и установить ошибку при невалидном коде',
      build: () {
        when(() => mockVerifyCode(any())).thenAnswer((_) async => false);
        return registrationCubit;
      },
      seed: () => const RegistrationState(code: 'INVALID'),
      act: (cubit) => cubit.verifyCode(),
      expect: () => <RegistrationState>[
        const RegistrationState(code: 'INVALID', isLoading: true, error: null),
        const RegistrationState(code: 'INVALID', isLoading: false),
        const RegistrationState(code: 'INVALID', error: 'Неверный код подтверждения'),
      ],
    );

    test('buildUser должен создать UserEntity с данными из состояния', () {
      // Arrange
      when(() => mockGenerateCode()).thenReturn('GEN123');
      final cubit = RegistrationCubit(mockVerifyCode, mockGenerateCode);
      final birthDate = DateTime(1990, 5, 15);
      
      cubit.setEmail('test@example.com');
      cubit.setName('John Doe');
      cubit.setBirthDate(birthDate);
      cubit.setGender('male');

      // Act
      final user = cubit.buildUser();

      // Assert
      expect(user.email, equals('test@example.com'));
      expect(user.name, equals('John Doe'));
      expect(user.birthDate, equals(birthDate));
      expect(user.gender, equals('male'));
      expect(user.code, equals('GEN123'));
      verify(() => mockGenerateCode()).called(1);
    });
  });
}

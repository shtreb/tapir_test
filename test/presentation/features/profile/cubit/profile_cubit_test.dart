import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tapir_test/src/domain/entities/user_entity.dart';
import 'package:tapir_test/src/domain/usecases/save_profile_photo_usecase.dart';
import 'package:tapir_test/src/presentation/features/profile/cubit/profile_cubit.dart';

class MockSaveProfilePhotoUseCase extends Mock implements SaveProfilePhotoUseCase {}

void main() {
  late ProfileCubit profileCubit;
  late MockSaveProfilePhotoUseCase mockSavePhoto;

  setUp(() {
    mockSavePhoto = MockSaveProfilePhotoUseCase();
    profileCubit = ProfileCubit(mockSavePhoto);
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

  group('ProfileCubit', () {
    final testUser = UserEntity(
      email: 'test@example.com',
      name: 'Test User',
      birthDate: DateTime(1990, 1, 1),
      gender: 'female',
      code: 'ABC123',
    );

    test('начальное состояние должно быть ProfileInitial', () {
      expect(profileCubit.state, isA<ProfileInitial>());
    });

    blocTest<ProfileCubit, ProfileState>(
      'setUser должен emit ProfileLoaded',
      build: () => profileCubit,
      act: (cubit) => cubit.setUser(testUser),
      expect: () => <ProfileState>[
        ProfileLoaded(testUser),
      ],
    );

    blocTest<ProfileCubit, ProfileState>(
      'updatePhoto должен обновить пользователя и emit ProfileLoaded',
      build: () {
        final updatedUser = testUser.copyWith(photoPath: '/new/path.jpg');
        when(() => mockSavePhoto(any(), any())).thenAnswer((_) async => updatedUser);
        return profileCubit;
      },
      seed: () => ProfileLoaded(testUser),
      act: (cubit) => cubit.updatePhoto('/new/path.jpg'),
      expect: () => <ProfileState>[
        ProfileLoading(),
        ProfileLoaded(testUser.copyWith(photoPath: '/new/path.jpg')),
      ],
      verify: (_) {
        verify(() => mockSavePhoto(testUser, '/new/path.jpg')).called(1);
      },
    );

    blocTest<ProfileCubit, ProfileState>(
      'updatePhoto должен emit ProfileError при ошибке',
      build: () {
        when(() => mockSavePhoto(any(), any())).thenThrow(Exception('Save failed'));
        return profileCubit;
      },
      seed: () => ProfileLoaded(testUser),
      act: (cubit) async {
        try {
          await cubit.updatePhoto('/new/path.jpg');
        } catch (_) {}
      },
      expect: () => <ProfileState>[
        ProfileLoading(),
        ProfileError('Exception: Save failed'),
      ],
    );
  });
}

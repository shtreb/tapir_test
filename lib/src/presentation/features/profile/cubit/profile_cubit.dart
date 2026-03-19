import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tapir_test/src/domain/entities/user_entity.dart';
import 'package:tapir_test/src/domain/usecases/save_profile_photo_usecase.dart';

part 'profile_state.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._saveProfilePhotoUseCase) : super(ProfileInitial());

  final SaveProfilePhotoUseCase _saveProfilePhotoUseCase;

  void setUser(UserEntity user) => emit(ProfileLoaded(user));

  Future<UserEntity> updatePhoto(String path) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) {
      throw StateError('User is not loaded');
    }

    try {
      emit(ProfileLoading());
      final updated = await _saveProfilePhotoUseCase(currentState.user, path);
      emit(ProfileLoaded(updated));
      return updated;
    } catch (e) {
      emit(ProfileError(e.toString()));
      rethrow;
    }
  }
}

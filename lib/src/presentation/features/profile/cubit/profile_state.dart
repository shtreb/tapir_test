part of 'profile_cubit.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => <Object?>[];
}

final class ProfileInitial extends ProfileState {}

final class ProfileLoaded extends ProfileState {
  const ProfileLoaded(this.user);
  final UserEntity user;

  @override
  List<Object?> get props => <Object?>[user];
}

final class ProfileLoading extends ProfileState {}

final class ProfileError extends ProfileState {
  const ProfileError(this.message);
  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}

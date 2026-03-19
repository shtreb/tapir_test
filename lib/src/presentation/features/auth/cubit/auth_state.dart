part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => <Object?>[];
}

final class AuthLoading extends AuthState {}

final class Unauthorized extends AuthState {}

final class Authorized extends AuthState {
  const Authorized(this.user);
  final UserEntity user;

  @override
  List<Object?> get props => <Object?>[user];
}

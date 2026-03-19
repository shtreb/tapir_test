import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.email,
    required this.name,
    required this.birthDate,
    required this.gender,
    required this.code,
    this.photoPath,
  });

  final String email;
  final String name;
  final DateTime birthDate;
  final String gender;
  final String code;
  final String? photoPath;

  UserEntity copyWith({
    String? email,
    String? name,
    DateTime? birthDate,
    String? gender,
    String? code,
    String? photoPath,
  }) {
    return UserEntity(
      email: email ?? this.email,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      code: code ?? this.code,
      photoPath: photoPath ?? this.photoPath,
    );
  }

  @override
  List<Object?> get props => <Object?>[email, name, birthDate, gender, code, photoPath];
}

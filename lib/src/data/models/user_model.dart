import 'dart:convert';

import 'package:tapir_test/src/domain/entities/user_entity.dart';

class UserModel {
  const UserModel({
    required this.email,
    required this.name,
    required this.birthDateIso,
    required this.gender,
    required this.code,
    this.photoPath,
  });

  final String email;
  final String name;
  final String birthDateIso;
  final String gender;
  final String code;
  final String? photoPath;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'email': email,
      'name': name,
      'birthDateIso': birthDateIso,
      'gender': gender,
      'code': code,
      'photoPath': photoPath,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] as String,
      name: json['name'] as String,
      birthDateIso: json['birthDateIso'] as String,
      gender: json['gender'] as String,
      code: json['code'] as String,
      photoPath: json['photoPath'] as String?,
    );
  }

  String encode() => jsonEncode(toJson());

  factory UserModel.decode(String value) {
    return UserModel.fromJson(jsonDecode(value) as Map<String, dynamic>);
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      email: entity.email,
      name: entity.name,
      birthDateIso: entity.birthDate.toIso8601String(),
      gender: entity.gender,
      code: entity.code,
      photoPath: entity.photoPath,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      email: email,
      name: name,
      birthDate: DateTime.parse(birthDateIso),
      gender: gender,
      code: code,
      photoPath: photoPath,
    );
  }
}

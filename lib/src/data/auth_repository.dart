import 'dart:math';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tapir_test/src/core/constants/app_constants.dart';
import 'package:tapir_test/src/data/models/user_model.dart';
import 'package:tapir_test/src/domain/entities/user_entity.dart';
import 'package:tapir_test/src/domain/repositories/auth_repository_interface.dart';

@LazySingleton(as: IAuthRepository)
class AuthRepository implements IAuthRepository {
  AuthRepository(this._preferences);

  final SharedPreferences _preferences;

  @override
  UserEntity? getCurrentUser() {
    try {
      final raw = _preferences.getString(AppConstants.userProfileKey);
      if (raw == null || raw.isEmpty) return null;
      
      try {
        return UserModel.decode(raw).toEntity();
      } catch (e) {
        _preferences.remove(AppConstants.userProfileKey);
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveUser(UserEntity user) async {
    try {
      final model = UserModel.fromEntity(user);
      final success = await _preferences.setString(
        AppConstants.userProfileKey,
        model.encode(),
      );
      
      if (!success) {
        throw Exception('Failed to save user data');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> clearUser() async {
    try {
      await _preferences.remove(AppConstants.userProfileKey);
    } catch (e) {
      rethrow;
    }
  }

  @override
  String generatePairCode() {
    const alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final random = Random();
    return List<String>.generate(
      AppConstants.codeLength,
      (_) => alphabet[random.nextInt(alphabet.length)],
    ).join();
  }

  @override
  Future<UserEntity?> loginWithEmailAndCode(String email, String code) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    if (code != 'QWERTY') {
      return null;
    }

    return UserEntity(email: email, name: '', birthDate: DateTime.now(), gender: '', code: code);
  }

  @override
  Future<bool> verifyRegistrationCode(String code) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    
    if (code.trim().length != AppConstants.codeLength) {
      return false;
    }

    const validChars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final upperCode = code.toUpperCase().trim();
    
    for (int i = 0; i < upperCode.length; i++) {
      if (!validChars.contains(upperCode[i])) {
        return false;
      }
    }

    return true;
  }
}

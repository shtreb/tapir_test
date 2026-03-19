import 'package:tapir_test/src/domain/entities/user_entity.dart';

abstract interface class IAuthRepository {
  UserEntity? getCurrentUser();
  Future<void> saveUser(UserEntity user);
  Future<void> clearUser();
  String generatePairCode();
  Future<UserEntity?> loginWithEmailAndCode(String email, String code);
  Future<bool> verifyRegistrationCode(String code);
}

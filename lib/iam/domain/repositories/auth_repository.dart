// iam/domain/repositories/auth_repository.dart
import '../entities/user.dart';
import '../value_objects/email.dart';
import '../value_objects/password.dart';

abstract class AuthRepository {
  Future<User> signUp(Email email, Password password);
  Future<User> signIn(Email email, Password password);
  Future<User> validateToken(String token);
  Future<User> refreshToken(String refreshToken);
  Future<User?> currentUser();
  Future<void> logout();
}
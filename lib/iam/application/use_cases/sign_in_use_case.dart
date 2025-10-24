// iam/application/use_cases/sign_in_use_case.dart
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';
import '../../domain/value_objects/email.dart';
import '../../domain/value_objects/password.dart';

class SignInUseCase {
  final AuthRepository repo;
  SignInUseCase(this.repo);

  Future<User> execute({required String email, required String password}) {
    return repo.signIn(Email(email), Password(password));
  }
}
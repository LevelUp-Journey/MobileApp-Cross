// iam/application/use_cases/sign_up_use_case.dart
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';
import '../../domain/value_objects/email.dart';
import '../../domain/value_objects/password.dart';

class SignUpUseCase {
  final AuthRepository repo;
  SignUpUseCase(this.repo);

  Future<User> execute({required String email, required String password}) {
    return repo.signUp(Email(email), Password(password));
  }
}
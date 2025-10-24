// iam/application/use_cases/validate_token_use_case.dart
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';

class ValidateTokenUseCase {
  final AuthRepository repo;
  ValidateTokenUseCase(this.repo);

  Future<User> execute({required String token}) {
    return repo.validateToken(token);
  }
}
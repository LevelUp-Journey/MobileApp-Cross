// iam/application/use_cases/refresh_token_use_case.dart
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';

class RefreshTokenUseCase {
  final AuthRepository repo;
  RefreshTokenUseCase(this.repo);

  Future<User> execute({required String refreshToken}) {
    return repo.refreshToken(refreshToken);
  }
}
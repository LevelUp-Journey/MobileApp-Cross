import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  Future<Profile> execute(String userId, {required String token}) {
    return repository.getProfileByUserId(userId, token: token);
  }
}

import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<Profile> execute(Profile profile, {required String token}) {
    return repository.updateProfile(profile, token: token);
  }
}

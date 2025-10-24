import '../entities/profile.dart';

abstract class ProfileRepository {
  Future<Profile> getProfileByUserId(String userId, {required String token});
}

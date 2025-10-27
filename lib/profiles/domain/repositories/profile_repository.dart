import '../entities/profile.dart';

abstract class ProfileRepository {
  Future<Profile> getProfileByUserId(String userId, {required String token});
  Future<Profile> updateProfile(Profile profile, {required String token});
}

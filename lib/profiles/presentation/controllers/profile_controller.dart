import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../iam/presentation/controllers/providers.dart';
import '../../application/use_cases/get_profile_use_case.dart';
import 'profile_state.dart';
import 'providers.dart';

class ProfileController extends Notifier<ProfileState> {
  @override
  ProfileState build() {
    return const ProfileState();
  }

  Future<void> fetchProfile() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final getProfile = ref.read(getProfileUseCaseProvider);
      final authState = ref.read(authControllerProvider);
      final userId = authState.user?.id;
      final token = authState.user?.token;

      if (userId == null || token == null) {
        throw Exception('User not authenticated or token not found');
      }

      final profile = await getProfile.execute(userId, token: token);
      state = ProfileState(profile: profile);
    } catch (e) {
      state = ProfileState(error: e.toString());
    }
  }
}

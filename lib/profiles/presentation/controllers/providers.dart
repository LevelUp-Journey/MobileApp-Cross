import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../iam/presentation/controllers/providers.dart';
import '../../application/use_cases/get_profile_use_case.dart';
import '../../application/use_cases/update_profile_use_case.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../infrastructure/repositories/rest_profile_repository.dart';
import 'profile_controller.dart';
import 'profile_state.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final client = ref.watch(httpClientProvider);
  return RestProfileRepository(client);
});

final getProfileUseCaseProvider = Provider<GetProfileUseCase>((ref) {
  final repo = ref.watch(profileRepositoryProvider);
  return GetProfileUseCase(repo);
});

final updateProfileUseCaseProvider = Provider<UpdateProfileUseCase>((ref) {
  final repo = ref.watch(profileRepositoryProvider);
  return UpdateProfileUseCase(repo);
});

final profileControllerProvider =
    NotifierProvider<ProfileController, ProfileState>(() {
  return ProfileController();
});

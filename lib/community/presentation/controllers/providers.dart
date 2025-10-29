// community/presentation/controllers/providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../../shared/environments/environment.dart';
import '../../domain/repositories/community_repository.dart';
import '../../infrastructure/repositories_impl/rest_community_repository.dart';
import '../../application/use_cases/get_all_communities_use_case.dart';
import '../../application/use_cases/get_community_by_id_use_case.dart';
import '../../application/use_cases/create_community_use_case.dart';
import '../../application/use_cases/update_community_use_case.dart';
import 'community_controller.dart';
import 'community_state.dart';

// HTTP Client Provider
final httpClientProvider = Provider<http.Client>((ref) => http.Client());

// Community Repository Provider
final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  final client = ref.watch(httpClientProvider);
  return RestCommunityRepository(
    client,
    baseUrl: Environment.communityserverBaseUrl,
  );
});

// Use Case Providers
final getAllCommunitiesUseCaseProvider = Provider<GetAllCommunitiesUseCase>((ref) {
  final repo = ref.watch(communityRepositoryProvider);
  return GetAllCommunitiesUseCase(repo);
});

final getCommunityByIdUseCaseProvider = Provider<GetCommunityByIdUseCase>((ref) {
  final repo = ref.watch(communityRepositoryProvider);
  return GetCommunityByIdUseCase(repo);
});

final createCommunityUseCaseProvider = Provider<CreateCommunityUseCase>((ref) {
  final repo = ref.watch(communityRepositoryProvider);
  return CreateCommunityUseCase(repo);
});

final updateCommunityUseCaseProvider = Provider<UpdateCommunityUseCase>((ref) {
  final repo = ref.watch(communityRepositoryProvider);
  return UpdateCommunityUseCase(repo);
});

// Community Controller Provider
final communityControllerProvider = NotifierProvider<CommunityController, CommunityState>(() {
  return CommunityController();
});

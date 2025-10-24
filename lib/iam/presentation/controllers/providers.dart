// iam/presentation/controllers/providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../shared/config.dart';
import '../../application/use_cases/sign_in_use_case.dart';
import '../../application/use_cases/sign_up_use_case.dart';
import '../../infrastructure/repositories_impl/rest_auth_repository.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_controller.dart';
import 'auth_state.dart';

final httpClientProvider = Provider<http.Client>((ref) => http.Client());
final baseUrlProvider = Provider<String>((ref) => Config.baseUrl);

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final client = ref.watch(httpClientProvider);
  final base = ref.watch(baseUrlProvider);
  return RestAuthRepository(client, baseUrl: base);
});

final signInUseCaseProvider = Provider<SignInUseCase>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return SignInUseCase(repo);
});

final signUpUseCaseProvider = Provider<SignUpUseCase>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return SignUpUseCase(repo);
});

final authControllerProvider =
    NotifierProvider<AuthController, AuthState>(() {
  return AuthController()
    ..setDependencies(
      SignInUseCase(RestAuthRepository(http.Client(), baseUrl: Config.baseUrl)),
      SignUpUseCase(RestAuthRepository(http.Client(), baseUrl: Config.baseUrl)),
    );
});
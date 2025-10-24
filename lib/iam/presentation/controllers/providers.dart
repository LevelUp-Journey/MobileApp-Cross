// iam/presentation/controllers/providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../application/use_cases/sign_in_use_case.dart';
import '../../application/use_cases/sign_up_use_case.dart';
import '../../infrastructure/repositories_impl/rest_auth_repository.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_controller.dart';
import 'auth_state.dart';

final httpClientProvider = Provider<http.Client>((ref) => http.Client());
final baseUrlProvider = Provider<String>((ref) => dotenv.env['BASE_URL'] ?? 'http://localhost:8081');

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
      SignInUseCase(RestAuthRepository(http.Client(), baseUrl: 'http://localhost:8081')),
      SignUpUseCase(RestAuthRepository(http.Client(), baseUrl: 'http://localhost:8081')),
    );
});
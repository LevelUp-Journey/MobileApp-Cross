// iam/presentation/controllers/auth_state.dart
import '../../domain/entities/user.dart';

class AuthState {
  final bool loading;
  final User? user;
  final String? error;
  final bool isAuthenticated;

  const AuthState({
    this.loading = false,
    this.user,
    this.error,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    bool? loading,
    User? user,
    String? error,
    bool? isAuthenticated,
  }) =>
      AuthState(
        loading: loading ?? this.loading,
        user: user ?? this.user,
        error: error ?? this.error,
        isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      );
}
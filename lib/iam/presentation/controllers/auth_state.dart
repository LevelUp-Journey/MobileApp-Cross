// iam/presentation/controllers/auth_state.dart
import '../../domain/entities/user.dart';

class AuthState {
  final bool loading;
  final User? user;
  final String? error;
  final bool isAuthenticated;
  final String? token;

  const AuthState({
    this.loading = false,
    this.user,
    this.error,
    this.isAuthenticated = false,
    this.token,
  });

  AuthState copyWith({
    bool? loading,
    User? user,
    String? error,
    bool? isAuthenticated,
    String? token,
  }) =>
      AuthState(
        loading: loading ?? this.loading,
        user: user ?? this.user,
        error: error ?? this.error,
        isAuthenticated: isAuthenticated ?? this.isAuthenticated,
        token: token ?? this.token,
      );
}
// iam/presentation/controllers/auth_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/use_cases/sign_in_use_case.dart';
import '../../application/use_cases/sign_up_use_case.dart';
import 'auth_state.dart';

class AuthController extends Notifier<AuthState> {
  late final SignInUseCase _signIn;
  late final SignUpUseCase _signUp;

  @override
  AuthState build() {
    return const AuthState();
  }

  void setDependencies(SignInUseCase signIn, SignUpUseCase signUp) {
    _signIn = signIn;
    _signUp = signUp;
  }

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final user = await _signIn.execute(email: email, password: password);
      state = AuthState(
        user: user,
        isAuthenticated: true,
        token: user.token,
        roles: user.roles,
      );
    } catch (e) {
      state = AuthState(error: e.toString());
    }
  }

  Future<void> signUp(String email, String password) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final user = await _signUp.execute(email: email, password: password);
      state = AuthState(
        user: user,
        isAuthenticated: true,
        token: user.token,
        roles: user.roles,
      );
    } catch (e) {
      state = AuthState(error: e.toString());
    }
  }

  void logout() {
    state = const AuthState();
  }
}
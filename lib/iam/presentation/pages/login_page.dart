// iam/presentation/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/providers.dart';
import '../../../shared/components/iam/logo_widget.dart';
import '../../../shared/components/iam/auth_form.dart';
import '../../../public/pages/home/home_page.dart';
import 'welcome_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _hasNavigated = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final authNotifier = ref.read(authControllerProvider.notifier);

    // Navigate to home if authenticated
    if (authState.isAuthenticated && authState.user != null && !authState.loading && !_hasNavigated) {
      _hasNavigated = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
          (route) => false,
        );
      });
    }

      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const WelcomePage()));
            },
            tooltip: 'Back',
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                const LogoWidget(size: 120),
                const SizedBox(height: 24),
                AuthForm(
                  isRegister: false,
                  emailController: emailController,
                  passwordController: passwordController,
                  loading: authState.loading,
                  errorText: authState.error,
                  showSwitch: false,
                  onSubmit: () => authNotifier.signIn(emailController.text.trim(), passwordController.text),
                  onSwitch: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
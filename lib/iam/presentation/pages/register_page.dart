// iam/presentation/pages/register_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/providers.dart';
import '../../../shared/components/iam/logo_widget.dart';
import '../../../shared/components/iam/auth_form.dart';
// import 'login_page.dart'; // switched link hidden in auth form
import 'home_page.dart';
import 'welcome_page.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _hasNavigated = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
                  isRegister: true,
                  emailController: emailController,
                  passwordController: passwordController,
                  confirmController: confirmPasswordController,
                  loading: authState.loading,
                  errorText: authState.error,
                  showSwitch: false,
                  onSubmit: () {
                    // Validate quickly before calling notifier
                    if (emailController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter your email'), backgroundColor: Colors.red));
                      return;
                    }
                    if (passwordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter your password'), backgroundColor: Colors.red));
                      return;
                    }
                    if (confirmPasswordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please confirm your password'), backgroundColor: Colors.red));
                      return;
                    }
                    if (passwordController.text != confirmPasswordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwords do not match'), backgroundColor: Colors.red));
                      return;
                    }
                    authNotifier.signUp(emailController.text.trim(), passwordController.text);
                  },
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
import 'package:flutter/material.dart';

typedef SubmitCallback = void Function();

class AuthForm extends StatelessWidget {
  final bool isRegister;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController? confirmController;
  final bool loading;
  final String? errorText;
  final SubmitCallback onSubmit;
  final VoidCallback onSwitch;

  const AuthForm({
    super.key,
    required this.isRegister,
    required this.emailController,
    required this.passwordController,
    this.confirmController,
    required this.loading,
    this.errorText,
    required this.onSubmit,
    required this.onSwitch,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            prefixIcon: const Icon(Icons.email),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: const Icon(Icons.lock),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          obscureText: true,
        ),
        if (isRegister) ...[
          const SizedBox(height: 16),
          TextField(
            controller: confirmController,
            decoration: InputDecoration(
              labelText: 'Confirm password',
              prefixIcon: const Icon(Icons.lock_outline),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            obscureText: true,
          ),
        ],
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: loading ? null : onSubmit,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: isRegister ? Colors.green : Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
          ),
          child: loading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                )
              : Text(
                  isRegister ? 'Sign Up' : 'Sign In',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red[200]!),
            ),
            child: Row(
              children: [
                const Icon(Icons.error, color: Colors.red),
                const SizedBox(width: 8),
                Expanded(child: Text(errorText!, style: const TextStyle(color: Colors.red))),
              ],
            ),
          ),
        ],
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(isRegister ? 'Already have an account?' : "Don't have an account?"),
            TextButton(onPressed: onSwitch, child: Text(isRegister ? 'Sign in' : 'Sign up', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue))),
          ],
        ),
      ],
    );
  }
}

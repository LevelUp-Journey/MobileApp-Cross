import 'package:flutter/material.dart';
import '../ui/primary_button.dart';

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
  final bool showSwitch;
  final Color? buttonColor;

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
    this.showSwitch = true,
    this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(color: Colors.black),
          cursorColor: Colors.black,
          decoration: InputDecoration(
            labelText: 'Email',
            labelStyle: const TextStyle(color: Colors.black),
            floatingLabelStyle: const TextStyle(color: Colors.black),
            prefixIcon: const Icon(Icons.email, color: Colors.black),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black26)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black)),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: passwordController,
          obscureText: true,
          style: const TextStyle(color: Colors.black),
          cursorColor: Colors.black,
          decoration: InputDecoration(
            labelText: 'Password',
            labelStyle: const TextStyle(color: Colors.black),
            floatingLabelStyle: const TextStyle(color: Colors.black),
            prefixIcon: const Icon(Icons.lock, color: Colors.black),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black26)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black)),
          ),
        ),
        if (isRegister) ...[
          const SizedBox(height: 16),
          TextField(
            controller: confirmController,
            obscureText: true,
            style: const TextStyle(color: Colors.black),
            cursorColor: Colors.black,
            decoration: InputDecoration(
              labelText: 'Confirm password',
              labelStyle: const TextStyle(color: Colors.black),
              floatingLabelStyle: const TextStyle(color: Colors.black),
              prefixIcon: const Icon(Icons.lock_outline, color: Colors.black),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black26)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black)),
            ),
          ),
        ],
        const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                onPressed: loading ? null : () => onSubmit(),
                child: loading
                    ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text(isRegister ? 'Sign Up' : 'Sign In', style: const TextStyle(color: Colors.white, fontSize: 16)),
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
        if (showSwitch) const SizedBox(height: 24),
        if (showSwitch)
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

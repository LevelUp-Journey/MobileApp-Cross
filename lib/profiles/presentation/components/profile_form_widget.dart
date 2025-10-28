import 'package:flutter/material.dart';

class ProfileFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;

  const ProfileFormWidget({
    super.key,
    required this.formKey,
    required this.usernameController,
    required this.firstNameController,
    required this.lastNameController,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
              labelStyle: TextStyle(color: Colors.black),
              prefixIcon: Icon(Icons.person_outline, color: Colors.black),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black54),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your username';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: firstNameController,
            decoration: const InputDecoration(
              labelText: 'First Name',
              labelStyle: TextStyle(color: Colors.black),
              prefixIcon: Icon(Icons.badge_outlined, color: Colors.black),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black54),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your first name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: lastNameController,
            decoration: const InputDecoration(
              labelText: 'Last Name',
              labelStyle: TextStyle(color: Colors.black),
              prefixIcon: Icon(Icons.badge_outlined, color: Colors.black),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black54),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
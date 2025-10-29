import 'package:flutter/material.dart';

class RolesWidget extends StatelessWidget {
  final List<String> roles;

  const RolesWidget({super.key, required this.roles});

  @override
  Widget build(BuildContext context) {
    if (roles.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: roles.map((role) {
            // Remove "ROLE_" prefix if present for cleaner display
            final displayRole = role.startsWith('ROLE_')
                ? role.substring(5)
                : role;

            return Chip(
              label: Text(
                displayRole,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            );
          }).toList(),
        ),
      ],
    );
  }
}

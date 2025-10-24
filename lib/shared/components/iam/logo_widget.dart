import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  final double size;
  final String? semanticLabel;

  const LogoWidget({super.key, this.size = 120, this.semanticLabel});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/level-cat-logo.png',
          width: size,
          height: size,
          fit: BoxFit.contain,
          semanticLabel: semanticLabel ?? 'App logo',
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../../components/appbar_widget.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderWidget(
        title: 'Settings',
        showLeading: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Application Settings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            // Here you can add configuration options
            Text('Coming soon: Theme, Language, Notifications, etc.'),
          ],
        ),
      ),
    );
  }
}

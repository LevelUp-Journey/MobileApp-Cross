import 'package:flutter/material.dart';
import '../../../shared/components/appbar_widget.dart';
import '../../../shared/components/bottom_navigation_widget.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderWidget(
        title: 'Community Admin',
        showLeading: true,
      ),
      body: const Center(
        child: Text('Community Content'),
      ),
      bottomNavigationBar: BottomNavigationWidget(
        currentIndex: -1, // No active item
        onTap: (index) {
          if (index == 0) {
            Navigator.of(context).pop(); // Go back
          }
          // Other indices do nothing
        },
      ),
    );
  }
}
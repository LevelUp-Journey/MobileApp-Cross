import 'package:flutter/material.dart';

/// Bottom navigation bar matching the provided screenshot:
/// - Three items: Home, Join, Community
/// - Icon above label, centered, tappable
class BottomNavigationWidget extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final Color activeColor;
  final Color inactiveColor;
  final double height;

  const BottomNavigationWidget({
    super.key,
    this.currentIndex = 0,
    this.onTap,
    this.activeColor = Colors.black,
    this.inactiveColor = const Color(0x8A000000), // black54
    this.height = 64,
  });

  Widget _buildItem({required IconData icon, required String label, required int index}) {
    final bool active = index == currentIndex;
    return Expanded(
      child: InkWell(
        onTap: () => onTap?.call(index),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20, color: active ? activeColor : inactiveColor),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(fontSize: 12, color: active ? activeColor : inactiveColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 6,
      child: SizedBox(
        height: height,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildItem(icon: Icons.home_outlined, label: 'Home', index: 0),
            _buildItem(icon: Icons.add_box_outlined, label: 'Join', index: 1),
            _buildItem(icon: Icons.people_outline, label: 'Community', index: 2),
          ],
        ),
      ),
    );
  }
}

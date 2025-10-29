import 'package:flutter/material.dart';

/// A reusable header bar matching the provided screenshot.
///
/// Usage:
/// - As an AppBar: `appBar: const HeaderWidget()`
/// - Or placed at the top of a Column/Stack.
class HeaderWidget extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final bool showLeading;
  final Widget? trailing;
  final String title;
  final double logoSize;
  final Color backgroundColor;
  final double height;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onLeadingTap;

  const HeaderWidget({
    super.key,
    this.leading,
    this.showLeading = true,
    this.trailing,
    this.title = 'Level Up Journey',
    this.logoSize = 36,
    this.backgroundColor = Colors.white,
    this.height = 64,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.onLeadingTap,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final leadingWidget = showLeading
        ? (leading ?? _DefaultLeading(onTap: onLeadingTap))
        : const SizedBox.shrink();

    final trailingWidget = trailing ?? const _DefaultTrailing();

    return Material(
      color: backgroundColor,
      child: SafeArea(
        bottom: false,
        child: Container(
          height: height,
          padding: padding,
          alignment: Alignment.center,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 56, child: Center(child: leadingWidget)),

              // Centered logo + title
              Expanded(
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/level-cat-logo.png',
                        width: logoSize,
                        height: logoSize,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(width: 56, child: Center(child: trailingWidget)),
            ],
          ),
        ),
      ),
    );
  }
}

class _DefaultLeading extends StatelessWidget {
  final VoidCallback? onTap;

  const _DefaultLeading({this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: const Icon(
        Icons.settings,
        color: Colors.black,
      ),
      tooltip: 'Settings',
    );
  }
}

class _DefaultTrailing extends StatelessWidget {
  const _DefaultTrailing();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: const Icon(
        Icons.public_outlined,
        color: Colors.black,
      ),
      tooltip: 'Change language',
    );
  }
}

import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
          color: Colors.teal, // Teal as title color
        ),
      ),
      backgroundColor: Colors.teal.withOpacity(0.1), // Light teal background color
      elevation: 0, // No shadow
      actions: actions,
      iconTheme: IconThemeData(color: Colors.teal), // Teal color for icons
      centerTitle: true, // Center align title
      // Add any other custom styling or functionality
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

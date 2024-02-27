import 'package:flutter/material.dart';
import '../utils/routes.dart';
import '../utils/theme.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BottomAppBar(
      color: theme.bottomAppBarTheme.color, // Using theme color for bottom app bar
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              // Pop until the first route in the stack which is HomeScreen
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () {
              Navigator.of(context).pushNamed(RouteNames.metaAnalysis);
            },
          ),
        ],
      ),
    );
  }
}

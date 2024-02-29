import 'package:flutter/material.dart';

class LoadingIndicator extends StatefulWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  _LoadingIndicatorState createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize your animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // Duration of the spin animation
      vsync: this,
    )..repeat(); // Repeat the animation indefinitely
  }

  @override
  void dispose() {
    _controller.dispose(); // Don't forget to dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      // Use AnimatedBuilder to animate the rotation
      child: AnimatedBuilder(
        animation: _controller,
        child: Image.asset(
          'assets/images/loading.png',
          width: 50.0, // Adjust the width as needed
          height: 50.0, // Adjust the height as needed
        ),
        builder: (BuildContext context, Widget? child) {
          return Transform.rotate(
            angle: _controller.value * 2 * 3.14159265358979323846264338327950288419716939937510582097494459230781640628620899, // Full circle
            child: child,
          );
        },
      ),
    );
  }
}

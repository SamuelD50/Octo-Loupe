import 'package:flutter/material.dart';

class CustomSnackBar extends StatelessWidget {
  final String message;
  final Color backgroundColor;

  const CustomSnackBar({
    super.key,
    required this.message,
    required this.backgroundColor,
  });

  @override
  Widget build(
    BuildContext context
  ) {
    return Material(
      color: backgroundColor, 
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void showSnackBar(
    BuildContext context
  ) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 30,
        left: 30,
        right: 30,
        child: CustomSnackBar(
          message: message,
          backgroundColor: backgroundColor,
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(
      const Duration(seconds: 3), () {
        overlayEntry.remove();
      }
    );
  }
}
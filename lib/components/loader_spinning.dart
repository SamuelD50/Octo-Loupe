import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// This component is a loader that is used when the page loads

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white24,
          ),
        ),
        Center(
          child: SpinKitSpinningLines(
            color: Colors.black,
            size: 60.0,
          ),
        ),
      ],
    );
  }
}
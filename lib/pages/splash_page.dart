/* import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {


  @override

} */

import 'package:flutter/material.dart';
import 'package:octoloupe/main.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _heartbeatController;
  late AnimationController _wavesController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Bat 2x par seconde = 500ms
    _heartbeatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_heartbeatController);

    _wavesController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(); // Onde toutes les 500ms aussi, mais durée + longue pour l’effet

    // Redirection vers la page principale
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _heartbeatController.dispose();
    _wavesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge([_heartbeatController, _wavesController]),
          builder: (context, child) {
            final scale = _scaleAnimation.value;
            return Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  painter: _HeartbeatWavePainter(_wavesController.value),
                  child: const SizedBox(width: 250, height: 250),
                ),
                Transform.scale(
                  scale: scale,
                  child: Image.asset(
                    'assets/images/Octoloupe.webp',
                    height: 100,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _HeartbeatWavePainter extends CustomPainter {
  final double value;

  _HeartbeatWavePainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = const Color(0xFF5B59B4).withOpacity(1 - value)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final waveCount = 3;
    final maxRadius = size.width / 2;

    for (int i = 0; i < waveCount; i++) {
      final progress = (value + i * 0.33) % 1.0;
      final radius = maxRadius * progress;
      if (progress < 1.0) {
        canvas.drawCircle(center, radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _HeartbeatWavePainter oldDelegate) {
    return oldDelegate.value != value;
  }
}


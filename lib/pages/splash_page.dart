import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late final AnimationController _heartbeatController;
  late final AnimationController _wavesController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;
  late final Image _icon;

  @override
  void initState() {
    super.initState();

    _icon = Image.asset(
      'assets/icons/icon_app.webp',
      height: 100,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(_icon.image, context);

      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) {
          context.go('/home');
        }
      });
    });

    _heartbeatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_heartbeatController);

    _wavesController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _heartbeatController,
        curve: Curves.easeIn,
      ),
    );
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
      body: Semantics(
        label: 'Chargement de l\'application Octo\'Loupe',
        liveRegion: true,
        container: true,
        child: Center(
          child: AnimatedBuilder(
            animation: Listenable.merge([_heartbeatController, _wavesController]),
            child: _icon,
            builder: (context, child) {
              final scale = _scaleAnimation.value;
              final waveValue = _wavesController.value;
              return Stack(
                alignment: Alignment.center,
                children: [
                  RepaintBoundary(
                    child: SizedBox(
                      width: 250,
                      height: 250,
                      child: CustomPaint(
                        painter: _HeartbeatWavePainter(waveValue),
                      ),
                    ),
                  ),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Transform.scale(
                      scale: scale,
                      child: child,
                    ),
                    
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _HeartbeatWavePainter extends CustomPainter {
  final double value;
  static final Paint _paint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;

  const _HeartbeatWavePainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    _paint.color = Color.fromRGBO(91, 89, 180, 1.0 - value);

    const waveCount = 3;
    final maxRadius = size.width / 2;

    for (int i = 0; i < waveCount; i++) {
      final progress = (value + i * 0.33) % 1.0;
      final radius = maxRadius * progress;
      if (progress < 1.0) {
        canvas.drawCircle(center, radius, _paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _HeartbeatWavePainter oldDelegate) {
    return oldDelegate.value != value;
  }
}
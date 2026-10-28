import 'dart:math';
import 'package:flutter/material.dart';

// 1. Modelo de cada partícula / fadinha
class FairyParticle {
  double x;
  double y;
  double speedX;
  double speedY;
  double radius;
  double baseAlpha;
  double pulseSpeed;
  double pulseOffset;

  FairyParticle({
    required this.x,
    required this.y,
    required this.speedX,
    required this.speedY,
    required this.radius,
    required this.baseAlpha,
    required this.pulseSpeed,
    required this.pulseOffset,
  });

  factory FairyParticle.random(
    Random random, {
    double minRadius = 1.5,
    double maxRadius = 4.0,
  }) {
    return FairyParticle(
      x: random.nextDouble(),
      y: random.nextDouble(),
      // Velocidade lenta e suave para parecer vagalumes/fadas
      speedX: (random.nextDouble() - 0.5) * 0.0008,
      speedY: (random.nextDouble() - 0.5) * 0.0008,
      radius: minRadius + random.nextDouble() * (maxRadius - minRadius),
      baseAlpha: random.nextDouble() * 0.4 + 0.3,
      pulseSpeed: random.nextDouble() * 2.0 + 1.0,
      pulseOffset: random.nextDouble() * pi * 2,
    );
  }

  void update() {
    x += speedX;
    y += speedY;

    // Faz as partículas darem a volta na tela ao saírem das bordas
    if (x < 0) x = 1.0;
    if (x > 1.0) x = 0.0;
    if (y < 0) y = 1.0;
    if (y > 1.0) y = 0.0;
  }
}

// 2. Widget que gerencia o loop da animação
class FairyLightsBackground extends StatefulWidget {
  final int numberOfParticles;
  final Color glowColor;
  final double minRadius; // Tamanho mínimo do núcleo da luz
  final double maxRadius;

  const FairyLightsBackground({
    super.key,
    this.numberOfParticles = 25, // Quantidade de luzes
    this.glowColor = const Color(0xFFFFF7C2), 
    this.minRadius = 1.5,
    this.maxRadius = 4.0,
  });

  @override
  State<FairyLightsBackground> createState() => _FairyLightsBackgroundState();
}

class _FairyLightsBackgroundState extends State<FairyLightsBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<FairyParticle> _particles;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _particles = List.generate(
      widget.numberOfParticles,
      (_) => FairyParticle.random(
        _random,
        minRadius: widget.minRadius,
        maxRadius: widget.maxRadius,
        ),
  
    );

    // Roda continuamente em loop
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _controller.addListener(() {
      for (var particle in _particles) {
        particle.update();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: _FairyPainter(
            particles: _particles,
            time: DateTime.now().millisecondsSinceEpoch / 1000.0,
            glowColor: widget.glowColor,
          ),
        );
      },
    );
  }
}

// 3. O pintor que desenha as luzes com brilho (glow)
class _FairyPainter extends CustomPainter {
  final List<FairyParticle> particles;
  final double time;
  final Color glowColor;

  _FairyPainter({
    required this.particles,
    required this.time,
    required this.glowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var p in particles) {
      final double posX = p.x * size.width;
      final double posY = p.y * size.height;

      // Efeito de respiração/pulsação da luz
      final double pulse = sin(time * p.pulseSpeed + p.pulseOffset);
      final double currentAlpha = (p.baseAlpha + (pulse * 0.2)).clamp(0.1, 0.9);

      // 1. Brilho suave externo (Glow)
      final glowPaint = Paint()
        ..color = glowColor.withValues(alpha: currentAlpha * 0.35)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, p.radius * 3.5);

      canvas.drawCircle(Offset(posX, posY), p.radius * 2.5, glowPaint);

      // 2. Núcleo brilhante (branquiçado no centro)
      final corePaint = Paint()
        ..color = Colors.white.withValues(alpha: currentAlpha);

      canvas.drawCircle(Offset(posX, posY), p.radius * 0.7, corePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _FairyPainter oldDelegate) => true;
}
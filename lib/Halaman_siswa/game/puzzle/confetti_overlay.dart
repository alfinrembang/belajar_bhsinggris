import 'dart:math';
import 'package:flutter/material.dart';

/// Efek Animasi Partikel Petasan / Konfeti Ringan
/// Berjalan mulus tanpa package tambahan, ringan, dan tidak menghalangi sentuhan (IgnorePointer).
class ConfettiOverlay extends StatefulWidget {
  final Widget child;

  const ConfettiOverlay({super.key, required this.child});

  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<ConfettiOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_ConfettiParticle> _particles = [];
  final Random _random = Random();

  static const List<Color> _colors = [
    Color(0xFFF59E0B), // Emas
    Color(0xFF38BDF8), // Biru Muda
    Color(0xFF10B981), // Hijau Zamrud
    Color(0xFFEC4899), // Pink Cerah
    Color(0xFF8B5CF6), // Ungu
    Color(0xFFF43F5E), // Merah Coral
    Color(0xFFFBBF24), // Kuning
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    )..repeat();

    // Inisialisasi 40 partikel konfeti
    for (int i = 0; i < 40; i++) {
      _particles.add(
        _ConfettiParticle(
          x: _random.nextDouble(),
          y: _random.nextDouble() * 0.4 - 0.2, // Mulai dari atas
          speed: 0.15 + _random.nextDouble() * 0.25,
          angle: _random.nextDouble() * 2 * pi,
          rotationSpeed: (_random.nextDouble() - 0.5) * 6,
          size: 6.0 + _random.nextDouble() * 6.0,
          color: _colors[_random.nextInt(_colors.length)],
          isCircle: _random.nextBool(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,

        // Lapisan partikel di atas tampilan
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: _ConfettiPainter(
                    particles: _particles,
                    progress: _controller.value,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _ConfettiParticle {
  double x;
  double y;
  final double speed;
  double angle;
  final double rotationSpeed;
  final double size;
  final Color color;
  final bool isCircle;

  _ConfettiParticle({
    required this.x,
    required this.y,
    required this.speed,
    required this.angle,
    required this.rotationSpeed,
    required this.size,
    required this.color,
    required this.isCircle,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;
  final double progress;

  _ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      // Hitung posisi saat ini
      final currentY = (p.y + (progress * p.speed * 2.5)) % 1.2;
      final currentX = (p.x + sin(progress * 4 * pi + p.angle) * 0.04) % 1.0;
      final posX = currentX * size.width;
      final posY = currentY * size.height;

      // Efek fade out jika di ujung bawah
      double opacity = 1.0;
      if (currentY > 0.85) {
        opacity = max(0.0, (1.0 - (currentY - 0.85) / 0.15));
      }

      final paint = Paint()
        ..color = p.color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(posX, posY);
      canvas.rotate(p.angle + (progress * p.rotationSpeed));

      if (p.isCircle) {
        canvas.drawCircle(Offset.zero, p.size / 2, paint);
      } else {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset.zero, width: p.size * 1.5, height: p.size * 0.7),
            const Radius.circular(2),
          ),
          paint,
        );
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => true;
}

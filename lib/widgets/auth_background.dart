import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. Background Langit Biru Cerah
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF28B7FF), // Biru langit atas
                  Color(0xFF4AC4FF),
                  Color(0xFF86D6FF),
                  Color(0xFFE2F4FF), // Gradien lembut di bawah
                ],
              ),
            ),
          ),
        ),

        // 2. Gambar Awan Halus (Dioptimasi dengan RepaintBoundary agar bebas jank)
        Positioned(
          top: 40,
          left: 0,
          right: 0,
          height: 380,
          child: RepaintBoundary(
            child: Opacity(
              opacity: 0.45,
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black,
                      Colors.black,
                      Colors.transparent,
                    ],
                    stops: [0.0, 0.35, 0.70, 1.0],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.dstIn,
                child: Image.asset(
                  'assets/images/awan.png',
                  width: double.infinity,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox(),
                ),
              ),
            ),
          ),
        ),

        // 3. Konten Form Utama
        child,
      ],
    );
  }
}

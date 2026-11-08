import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Ilustrasi Ikan Dinamis & Hidup (Pengganti Gambar Rakun di Banner Beranda)
/// Dilengkapi animasi melompat, riak air, cipratan air, dan gelembung udara.
class DynamicFishIllustration extends StatefulWidget {
  final double size;

  const DynamicFishIllustration({super.key, this.size = 90});

  @override
  State<DynamicFishIllustration> createState() => _DynamicFishIllustrationState();
}

class _DynamicFishIllustrationState extends State<DynamicFishIllustration>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _jumpAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _jumpAnimation = Tween<double>(begin: 4.0, end: -8.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOutSine),
    );

    _rotateAnimation = Tween<double>(begin: -0.06, end: 0.08).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // 1. Riak Air & Gelombang Lembut yang Menyatu dengan Danau Banner
              Positioned(
                bottom: 8,
                child: Container(
                  width: widget.size * 0.85,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.cyanAccent.withValues(alpha: 0.25),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),

              // Riak Air Kedua Bergelombang
              Positioned(
                bottom: 12,
                child: Container(
                  width: widget.size * 0.55,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),

              // 2. Butir Tetesan Cipratan Air Dinamis (Water Splash Drops)
              Positioned(
                bottom: 20 + (_jumpAnimation.value.abs() * 0.8),
                left: 12,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.75),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: 24 + (_jumpAnimation.value.abs() * 1.1),
                right: 14,
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.cyanAccent.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // 3. Gelembung Udara Melayang
              Positioned(
                top: 8 + (_jumpAnimation.value * 0.3),
                left: 10,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withValues(alpha: 0.7), width: 1),
                  ),
                ),
              ),

              // 4. Ikan Kartun Lucu & Menggemaskan Melompat Hidup
              Transform.translate(
                offset: Offset(0, _jumpAnimation.value),
                child: Transform.rotate(
                  angle: _rotateAnimation.value,
                  child: SizedBox(
                    width: widget.size * 0.78,
                    height: widget.size * 0.65,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Sirip Ekor Ikan (Kibas Ekor Kartun)
                        Positioned(
                          left: -4,
                          top: widget.size * 0.16,
                          child: Transform.rotate(
                            angle: sin(_animController.value * pi * 2) * 0.18,
                            alignment: Alignment.centerRight,
                            child: Container(
                              width: 22,
                              height: 24,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xFFEA580C), Color(0xFFFBBF24)],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                ),
                                borderRadius: BorderRadius.horizontal(
                                  left: Radius.elliptical(22, 16),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Sirip Atas (Dorsal Fin)
                        Positioned(
                          top: -6,
                          left: widget.size * 0.22,
                          child: Container(
                            width: 20,
                            height: 10,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFEA580C), Color(0xFFF59E0B)],
                              ),
                              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                            ),
                          ),
                        ),

                        // Badan Ikan Utama yang Berisi & Manis
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFFBBF24), // Kuning emas cerah
                                  Color(0xFFF59E0B), // Oranye hangat
                                  Color(0xFFEA580C), // Oranye merah manis
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(28),
                                bottomLeft: Radius.circular(26),
                                topRight: Radius.circular(36),
                                bottomRight: Radius.circular(30),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFEA580C).withValues(alpha: 0.4),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                // Aksen Garis Sisik Berkilau Lembut
                                Positioned(
                                  left: 18,
                                  top: 10,
                                  child: Container(
                                    width: 14,
                                    height: 14,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white.withValues(alpha: 0.45),
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 28,
                                  top: 14,
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white.withValues(alpha: 0.45),
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),

                                // Sirip Dada (Pectoral Fin)
                                Positioned(
                                  left: 20,
                                  bottom: 8,
                                  child: Container(
                                    width: 16,
                                    height: 9,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFDE68A),
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.1),
                                          blurRadius: 3,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Mata Kartun Lucu & Berbinar
                                Positioned(
                                  right: 12,
                                  top: 9,
                                  child: Container(
                                    width: 13,
                                    height: 13,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF0F172A),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          Positioned(
                                            top: 1,
                                            right: 1,
                                            child: Container(
                                              width: 3,
                                              height: 3,
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                // Pipi Merona Manis (Blush)
                                Positioned(
                                  right: 10,
                                  bottom: 9,
                                  child: Container(
                                    width: 8,
                                    height: 5,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEF4444).withValues(alpha: 0.4),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 5. Partikel Bintang Berkilau (Sparkle) di Puncak Lompatan
              Positioned(
                top: 4,
                right: 8,
                child: Text('✨', style: TextStyle(fontSize: widget.size * 0.18)),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Karakter Nelayan Pemancing Asli di Atas Perahu (Pengganti Rakun di Layar Main)
/// Dilengkapi topi pancing (bucket hat), rompi pancing, joran melengkung, dan animasi realistis
class FishermanBoatWidget extends StatefulWidget {
  final bool isReeling;
  final bool isStrike;
  final bool isCasting;

  const FishermanBoatWidget({
    super.key,
    this.isReeling = false,
    this.isStrike = false,
    this.isCasting = false,
  });

  @override
  State<FishermanBoatWidget> createState() => _FishermanBoatWidgetState();
}

class _FishermanBoatWidgetState extends State<FishermanBoatWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _boatController;

  @override
  void initState() {
    super.initState();
    _boatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _boatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _boatController,
      builder: (context, child) {
        // Efek goyang perahu di atas air
        final boatBob = sin(_boatController.value * pi) * 3.0;
        final rodAngle = widget.isStrike || widget.isReeling
            ? 0.38 // Joran melengkung tegang tertarik ikan
            : (widget.isCasting ? -0.4 : 0.15); // Joran saat santai / melempar

        return Transform.translate(
          offset: Offset(0, boatBob),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Karakter Nelayan & Joran Pancing
              SizedBox(
                width: 170,
                height: 100,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Joran Pancing Panjang Melengkung ke Air
                    Positioned(
                      left: 65,
                      bottom: 24,
                      child: Transform.rotate(
                        angle: rodAngle,
                        alignment: Alignment.bottomLeft,
                        child: CustomPaint(
                          size: const Size(90, 70),
                          painter: _FishingRodPainter(
                            isBent: widget.isStrike || widget.isReeling,
                          ),
                        ),
                      ),
                    ),

                    // Nelayan Kartun Ramah & Lucu
                    Positioned(
                      left: 28,
                      bottom: 0,
                      child: _buildFishermanBody(),
                    ),
                  ],
                ),
              ),

              // 2. Perahu Kayu Kartun Bersahabat
              Container(
                width: 154,
                height: 30,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF92400E), Color(0xFFB45309), Color(0xFFD97706)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(22)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  border: Border.all(color: const Color(0xFFFDE68A), width: 1.2),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🛶', style: TextStyle(fontSize: 12)),
                      const SizedBox(width: 4),
                      Text(
                        'Nelayan Pintar',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Membangun karakter nelayan (topi bundar bucket hat, wajah bersahabat, rompi pancing)
  Widget _buildFishermanBody() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Topi Nelayan (Bucket Hat Pemancing)
        Container(
          width: 50,
          height: 12,
          decoration: BoxDecoration(
            color: const Color(0xFFFBBF24), // Kuning cerah
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        Container(
          width: 36,
          height: 18,
          decoration: const BoxDecoration(
            color: Color(0xFFF59E0B),
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: Center(
            child: Container(
              width: 14,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF0284C7),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),

        // Kepala & Wajah Tersenyum
        Container(
          width: 38,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFFFFEDB3), // Warna kulit cerah
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFFDE047), width: 0.8),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Mata Ramah
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(color: Color(0xFF0F172A), shape: BoxShape.circle),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(color: Color(0xFF0F172A), shape: BoxShape.circle),
                ),
              ),
              // Pipi Merona
              Positioned(
                top: 14,
                left: 5,
                child: Container(
                  width: 6,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF87171).withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              Positioned(
                top: 14,
                right: 5,
                child: Container(
                  width: 6,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF87171).withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              // Senyum Lebar
              Positioned(
                bottom: 5,
                child: Container(
                  width: 12,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDC2626),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Rompi Nelayan (Fishing Vest)
        Container(
          width: 44,
          height: 24,
          decoration: const BoxDecoration(
            color: Color(0xFF0284C7), // Rompi biru nelayan
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Saku Rompi Kiri
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: const Color(0xFF0369A1),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              // Kancing
              Container(
                width: 4,
                height: 14,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Saku Rompi Kanan
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: const Color(0xFF0369A1),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Custom Painter untuk Joran Pancing Realistis & Tali Senar ke Air
class _FishingRodPainter extends CustomPainter {
  final bool isBent;

  _FishingRodPainter({required this.isBent});

  @override
  void paint(Canvas canvas, Size size) {
    final rodPaint = Paint()
      ..color = const Color(0xFF78350F) // Kayu joran kokoh
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.9) // Tali senar putih
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;

    // Batang joran melengkung
    final path = Path();
    path.moveTo(0, size.height);
    if (isBent) {
      path.quadraticBezierTo(size.width * 0.4, size.height * 0.2, size.width, 0);
    } else {
      path.lineTo(size.width, 0);
    }
    canvas.drawPath(path, rodPaint);

    // Rol Pancing Emas di Pangkal Joran
    final reelPaint = Paint()..color = const Color(0xFFF59E0B);
    canvas.drawCircle(Offset(10, size.height - 10), 5, reelPaint);

    // Tali Senar Menggantung dari Ujung Joran ke Air
    final linePath = Path();
    linePath.moveTo(size.width, 0);
    if (isBent) {
      // Tali senar tegang saat ditarik
      linePath.lineTo(size.width + 10, size.height + 40);
    } else {
      // Tali senar santai melengkung
      linePath.quadraticBezierTo(size.width + 8, size.height * 0.6, size.width + 12, size.height + 40);
    }
    canvas.drawPath(linePath, linePaint);
  }

  @override
  bool shouldRepaint(covariant _FishingRodPainter oldDelegate) {
    return oldDelegate.isBent != isBent;
  }
}

/// Widget Ikan Akuarium Berenang Hidup & Dinamis (Asset PNG Realistis, Bayangan Kedalaman Air, Squash-Stretch, Gelembung Bernapas)
class OceanSwimmerFishWidget extends StatefulWidget {
  final String species;
  final String? assetPath;
  final double width;
  final double height;
  final bool isFacingRight;
  final bool isCaught;
  final VoidCallback onTap;

  const OceanSwimmerFishWidget({
    super.key,
    required this.species,
    this.assetPath,
    this.width = 86.0,
    this.height = 60.0,
    required this.isFacingRight,
    this.isCaught = false,
    required this.onTap,
  });

  @override
  State<OceanSwimmerFishWidget> createState() => _OceanSwimmerFishWidgetState();
}

class _OceanSwimmerFishWidgetState extends State<OceanSwimmerFishWidget>
    with TickerProviderStateMixin {
  late AnimationController _swimController;
  late AnimationController _bubbleController;
  late AnimationController _tapFeedbackController;

  @override
  void initState() {
    super.initState();
    _swimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat();

    _tapFeedbackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
  }

  @override
  void dispose() {
    _swimController.dispose();
    _bubbleController.dispose();
    _tapFeedbackController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _tapFeedbackController.forward().then((_) {
      if (mounted) _tapFeedbackController.reverse();
    });
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isCaught) return const SizedBox.shrink();

    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _swimController,
          _bubbleController,
          _tapFeedbackController,
        ]),
        builder: (context, child) {
          final swimVal = _swimController.value;
          final tapVal = _tapFeedbackController.value;

          // A. Ayunan kemiringan tubuh ikan (Pitch / Tilt)
          final tilt = sin(swimVal * pi) * 0.08 * (widget.isFacingRight ? 1 : -1);

          // B. Efek otot & pernapasan ikan (Squash & Stretch agar TIDAK FLAT)
          final scaleX = 1.0 + (sin(swimVal * pi) * 0.04) + (tapVal * 0.12);
          final scaleY = 1.0 - (sin(swimVal * pi) * 0.03) + (tapVal * 0.12);

          // C. Efek mengapung vertikal alami (Micro-bobbing di dalam air)
          final bobY = sin(swimVal * pi) * 3.5;

          // D. Gelembung nafas yang keluar dari mulut ikan
          final bubbleProg = _bubbleController.value;
          final bubbleY = -bubbleProg * 36.0;
          final bubbleX = (widget.isFacingRight ? widget.width * 0.40 : -widget.width * 0.40) +
              (sin(bubbleProg * 2 * pi) * 5.0);
          final bubbleOpacity = (1.0 - bubbleProg).clamp(0.0, 1.0) * 0.85;

          return SizedBox(
            width: widget.width + 24,
            height: widget.height + 24,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // 1. Partikel Gelembung Kecil dari Mulut Ikan
                if (bubbleProg > 0.08 && bubbleOpacity > 0.1)
                  Positioned(
                    left: ((widget.width + 24) / 2) + bubbleX,
                    top: ((widget.height + 24) * 0.38) + bubbleY,
                    child: Opacity(
                      opacity: bubbleOpacity,
                      child: Container(
                        width: 6.5 + (bubbleProg * 5.0),
                        height: 6.5 + (bubbleProg * 5.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.7),
                          border: Border.all(
                            color: Colors.cyanAccent.withValues(alpha: 0.85),
                            width: 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.cyanAccent.withValues(alpha: 0.35),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Align(
                          alignment: const Alignment(-0.3, -0.3),
                          child: Container(
                            width: 2.2,
                            height: 2.2,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                // 2. Transformasi Renang Ikan Utama (Ayunan, Bernapas, dan Melayang)
                Transform.translate(
                  offset: Offset(0, bobY),
                  child: Transform.rotate(
                    angle: tilt,
                    child: Transform.scale(
                      scaleX: scaleX,
                      scaleY: scaleY,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // 2A. Bayangan Air (Underwater Depth Shadow) agar ikan berdimensi & tidak flat
                          Transform.translate(
                            offset: const Offset(3.5, 6.5),
                            child: Opacity(
                              opacity: 0.26,
                              child: Transform.flip(
                                flipX: widget.isFacingRight,
                                child: ColorFiltered(
                                  colorFilter: const ColorFilter.mode(
                                    Color(0xFF023E8A),
                                    BlendMode.srcIn,
                                  ),
                                  child: _buildFishImage(),
                                ),
                              ),
                            ),
                          ),

                          // 2B. Gambar Ikan Asli dengan Orientasi Arah Hadap
                          Transform.flip(
                            flipX: widget.isFacingRight,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                _buildFishImage(),

                                // 2C. Efek Kilau Air Transparan (Underwater Caustic Shimmer)
                                Positioned.fill(
                                  child: IgnorePointer(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.white.withValues(alpha: 0.16 * (1.0 - swimVal)),
                                              Colors.transparent,
                                              Colors.cyanAccent.withValues(alpha: 0.10 * swimVal),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFishImage() {
    if (widget.assetPath != null && widget.assetPath!.isNotEmpty) {
      return Image.asset(
        widget.assetPath!,
        width: widget.width,
        height: widget.height,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackBody();
        },
      );
    }
    return _buildFallbackBody();
  }

  Widget _buildFallbackBody() {
    return _buildFishBody(0.0);
  }

  Widget _buildFishBody(double tailWag) {
    switch (widget.species) {
      case 'clownfish':
        return _buildClownfish(tailWag);
      case 'bluetang':
        return _buildBlueTang(tailWag);
      case 'yellowtang':
        return _buildYellowTang(tailWag);
      case 'angelfish':
        return _buildAngelfish(tailWag);
      default:
        return _buildRubyReef(tailWag);
    }
  }

  /// 1. Ikan Badut (Clownfish / Nemo): Oranye cerah, 3 pita putih lengkung bertepi hitam
  Widget _buildClownfish(double tailWag) {
    return SizedBox(
      width: 76,
      height: 46,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Sirip Ekor Berkibas Melambai
          Positioned(
            left: 0,
            child: Transform.rotate(
              angle: tailWag,
              alignment: Alignment.centerRight,
              child: Container(
                width: 20,
                height: 26,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFEA580C), Color(0xFFF97316)],
                  ),
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                  border: Border.all(color: const Color(0xFF0F172A), width: 1.8),
                ),
              ),
            ),
          ),

          // Sirip Punggung Bergelombang
          Positioned(
            top: 1,
            left: 20,
            child: Container(
              width: 32,
              height: 9,
              decoration: BoxDecoration(
                color: const Color(0xFFEA580C),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                border: Border.all(color: const Color(0xFF0F172A), width: 1.2),
              ),
            ),
          ),

          // Badan Utama Ikan Badut
          Positioned(
            left: 12,
            child: Container(
              width: 58,
              height: 38,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFB923C), Color(0xFFEA580C), Color(0xFFC2410C)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(22),
                  bottomLeft: Radius.circular(20),
                  topRight: Radius.circular(28),
                  bottomRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Pita Putih Tengah Khas Nemo
                  Positioned(
                    left: 16,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 9,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.symmetric(
                          vertical: BorderSide(color: Colors.black.withValues(alpha: 0.7), width: 1.4),
                        ),
                      ),
                    ),
                  ),
                  // Pita Putih Kepala
                  Positioned(
                    left: 32,
                    top: 2,
                    bottom: 2,
                    child: Container(
                      width: 8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.symmetric(
                          vertical: BorderSide(color: Colors.black.withValues(alpha: 0.7), width: 1.4),
                        ),
                      ),
                    ),
                  ),
                  // Sirip Dada (Pectoral Fin)
                  Positioned(
                    left: 22,
                    bottom: 5,
                    child: Container(
                      width: 13,
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDBA74),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.black.withValues(alpha: 0.5), width: 1),
                      ),
                    ),
                  ),
                  // Mata Ikan
                  Positioned(
                    right: 8,
                    top: 9,
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: Center(
                        child: Container(
                          width: 5,
                          height: 5,
                          decoration: const BoxDecoration(color: Color(0xFF0F172A), shape: BoxShape.circle),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 2. Ikan Blue Tang (Dory): Biru royal dengan ekor kuning melambai
  Widget _buildBlueTang(double tailWag) {
    return SizedBox(
      width: 76,
      height: 46,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Ekor Segitiga Kuning Melambai
          Positioned(
            left: 0,
            child: Transform.rotate(
              angle: tailWag,
              alignment: Alignment.centerRight,
              child: Container(
                width: 20,
                height: 24,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFFFDE047), Color(0xFFEAB308)]),
                  borderRadius: BorderRadius.horizontal(left: Radius.circular(16)),
                ),
              ),
            ),
          ),

          // Badan Biru Royal Elektrik
          Positioned(
            left: 12,
            child: Container(
              width: 58,
              height: 40,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF38BDF8), Color(0xFF0284C7), Color(0xFF0369A1)],
                ),
                borderRadius: const BorderRadius.all(Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0284C7).withValues(alpha: 0.35),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Pola Hitam Khas Punggung Dory
                  Positioned(
                    top: 5,
                    left: 10,
                    right: 20,
                    height: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  // Sirip Dada Kuning Cerah
                  Positioned(
                    left: 20,
                    bottom: 6,
                    child: Container(
                      width: 14,
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFACC15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  // Mata
                  Positioned(
                    right: 8,
                    top: 10,
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: Center(
                        child: Container(
                          width: 5,
                          height: 5,
                          decoration: const BoxDecoration(color: Color(0xFF0F172A), shape: BoxShape.circle),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 3. Ikan Yellow Tang: Kuning Lemon cerah bentuk pipih anggun
  Widget _buildYellowTang(double tailWag) {
    return SizedBox(
      width: 74,
      height: 50,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Ekor Kuning
          Positioned(
            left: 0,
            child: Transform.rotate(
              angle: tailWag,
              alignment: Alignment.centerRight,
              child: Container(
                width: 18,
                height: 22,
                decoration: const BoxDecoration(
                  color: Color(0xFFEAB308),
                  borderRadius: BorderRadius.horizontal(left: Radius.circular(14)),
                ),
              ),
            ),
          ),

          // Badan Kuning Pipih Tinggi Khas Zebrasoma
          Positioned(
            left: 10,
            child: Container(
              width: 58,
              height: 44,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFEF08A), Color(0xFFFACC15), Color(0xFFEAB308)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(26),
                  bottomLeft: Radius.circular(26),
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(22),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Mata
                  Positioned(
                    right: 8,
                    top: 13,
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: Center(
                        child: Container(
                          width: 5,
                          height: 5,
                          decoration: const BoxDecoration(color: Color(0xFF0F172A), shape: BoxShape.circle),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 4. Ikan Bidadari Karang (Moorish / Angelfish): Sirip Punggung Menjulang Anggun
  Widget _buildAngelfish(double tailWag) {
    return SizedBox(
      width: 76,
      height: 52,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Ekor
          Positioned(
            left: 0,
            child: Transform.rotate(
              angle: tailWag,
              alignment: Alignment.centerRight,
              child: Container(
                width: 18,
                height: 24,
                decoration: const BoxDecoration(
                  color: Color(0xFFF97316),
                  borderRadius: BorderRadius.horizontal(left: Radius.circular(14)),
                ),
              ),
            ),
          ),

          // Sirip Punggung Panjang Menjulang ke Belakang
          Positioned(
            top: 0,
            left: 18,
            child: Container(
              width: 24,
              height: 12,
              decoration: const BoxDecoration(
                color: Color(0xFFFBBF24),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(14)),
              ),
            ),
          ),

          // Badan Ungu Violet Gradasi Oranye
          Positioned(
            left: 10,
            bottom: 2,
            child: Container(
              width: 58,
              height: 42,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9), Color(0xFFEA580C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.all(Radius.circular(22)),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: 8,
                    top: 10,
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: Center(
                        child: Container(
                          width: 5,
                          height: 5,
                          decoration: const BoxDecoration(color: Color(0xFF0F172A), shape: BoxShape.circle),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 5. Ruby Reef Snapper: Merah koral cerah dengan sisik berkilau
  Widget _buildRubyReef(double tailWag) {
    return SizedBox(
      width: 76,
      height: 46,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Ekor
          Positioned(
            left: 0,
            child: Transform.rotate(
              angle: tailWag,
              alignment: Alignment.centerRight,
              child: Container(
                width: 18,
                height: 22,
                decoration: const BoxDecoration(
                  color: Color(0xFFEF4444),
                  borderRadius: BorderRadius.horizontal(left: Radius.circular(14)),
                ),
              ),
            ),
          ),

          // Badan Merah Koral
          Positioned(
            left: 10,
            child: Container(
              width: 58,
              height: 38,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFF87171), Color(0xFFEF4444), Color(0xFFB91C1C)],
                ),
                borderRadius: BorderRadius.all(Radius.circular(22)),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: 8,
                    top: 9,
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: Center(
                        child: Container(
                          width: 5,
                          height: 5,
                          decoration: const BoxDecoration(color: Color(0xFF0F172A), shape: BoxShape.circle),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Animasi Pakan Makanan Ikan di Tengah Laut saat tombol "Beri Makan" ditekan
class FishFoodBaitWidget extends StatelessWidget {
  final int remainingSeconds;

  const FishFoodBaitWidget({super.key, required this.remainingSeconds});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF3C7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF59E0B)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 8,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🦐', style: TextStyle(fontSize: 14)),
              const SizedBox(width: 4),
              Text(
                'Makan Bersama! (${remainingSeconds}s)',
                style: GoogleFonts.poppins(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFB45309),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFF59E0B).withValues(alpha: 0.25),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFFDE68A), width: 1.5),
          ),
          child: const Center(
            child: Text('🦐', style: TextStyle(fontSize: 22)),
          ),
        ),
      ],
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Auth/regis_siswa.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late AnimationController _dotsController;
  Timer? _navigationTimer;
  bool _isImagesPrecached = false;
  bool _showRegis = false;
  bool _isOverlayRemoved = false;

  // Animasi berurutan untuk elemen loading screen
  late Animation<double> _cloudOpacity;
  late Animation<double> _raccoonOpacity;
  late Animation<double> _raccoonScale;
  late Animation<Offset> _raccoonSlide;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;
  late Animation<double> _loadingOpacity;

  @override
  void initState() {
    super.initState();

    // Controller untuk urutan kemunculan elemen loading (2.6 detik)
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );

    _cloudOpacity = Tween<double>(begin: 0.0, end: 0.38).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.42, curve: Curves.easeInOutCubic),
      ),
    );

    _raccoonOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.08, 0.54, curve: Curves.easeOutCubic),
      ),
    );
    _raccoonScale = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.08, 0.54, curve: Curves.easeOutCubic),
      ),
    );
    _raccoonSlide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.08, 0.54, curve: Curves.easeOutCubic),
      ),
    );

    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.44, 0.75, curve: Curves.easeOutCubic),
      ),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.20),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.44, 0.75, curve: Curves.easeOutCubic),
      ),
    );

    _loadingOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.70, 0.95, curve: Curves.easeOutCubic),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _entranceController.forward();
      }
    });

    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    // Step 5: Setelah 7 detik, lakukan transisi cross-fade pre-warmed yang 100% bebas frame drop
    _navigationTimer = Timer(const Duration(seconds: 7), () {
      if (mounted) {
        _dotsController.stop();
        setState(() {
          _showRegis = true;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isImagesPrecached) {
      _isImagesPrecached = true;
      precacheImage(
          const AssetImage('assets/images/rakun_laoding.png'), context);
      precacheImage(const AssetImage('assets/images/awan.png'), context);
      precacheImage(const AssetImage('assets/images/rakun.png'), context);
    }
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _dotsController.dispose();
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Form Registrasi Siswa (Pre-warmed di memori GPU, meluncur naik perlahan & sangat halus)
          AnimatedSlide(
            offset: _showRegis ? Offset.zero : const Offset(0, 0.025),
            duration: const Duration(milliseconds: 750),
            curve: Curves.easeOutCubic,
            child: const RegisSiswaPage(),
          ),

          // 2. Loading Screen Overlay (Melapisi di atasnya lalu cross-fade keluar tanpa frame drop)
          if (!_isOverlayRemoved)
            IgnorePointer(
              ignoring: _showRegis,
              child: AnimatedOpacity(
                opacity: _showRegis ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 750),
                curve: Curves.easeInOutCubic,
                onEnd: () {
                  if (mounted && _showRegis) {
                    setState(() {
                      _isOverlayRemoved = true;
                    });
                  }
                },
                child: _buildLoadingOverlay(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Stack(
      children: [
        // 1. Background Gradien Biru Langit Cerah ke Biru Tua Pekat
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1CB7FE),
                  Color(0xFF0F9AE8),
                  Color(0xFF0868B4),
                  Color(0xFF04488A),
                  Color(0xFF022A5B),
                  Color(0xFF011C40),
                ],
                stops: [0.0, 0.20, 0.42, 0.65, 0.85, 1.0],
              ),
            ),
          ),
        ),

        // 2. Awan Halus Transparan
        Positioned(
          top: 20,
          left: 0,
          right: 0,
          height: 380,
          child: RepaintBoundary(
            child: FadeTransition(
              opacity: _cloudOpacity,
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
                    stops: [0.0, 0.30, 0.70, 1.0],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.dstIn,
                child: Image.asset(
                  'assets/images/awan.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox(),
                ),
              ),
            ),
          ),
        ),

        // 3. Konten Utama: Rakun -> Teks -> Loading Dots
        SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                const Spacer(flex: 2),

                // Maskot Rakun
                RepaintBoundary(
                  child: FadeTransition(
                    opacity: _raccoonOpacity,
                    child: ScaleTransition(
                      scale: _raccoonScale,
                      child: SlideTransition(
                        position: _raccoonSlide,
                        child: Image.asset(
                          'assets/images/rakun_laoding.png',
                          width: 290,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const SizedBox(),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Teks Judul SIP & STUDY ENGLISH PRIMA
                RepaintBoundary(
                  child: FadeTransition(
                    opacity: _textOpacity,
                    child: SlideTransition(
                      position: _textSlide,
                      child: Column(
                        children: [
                          Text(
                            'SIP',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 38,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2.0,
                              color: const Color(0xFFFFD200),
                              shadows: [
                                const Shadow(
                                  color: Color(0xFFC68A00),
                                  offset: Offset(0, 4),
                                  blurRadius: 0,
                                ),
                                Shadow(
                                  color: const Color(0xFF001F42)
                                      .withValues(alpha: 0.45),
                                  offset: const Offset(0, 8),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'STUDY  ENGLISH  PRIMA',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2.2,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: const Color(0xFF001F42)
                                      .withValues(alpha: 0.65),
                                  offset: const Offset(0, 3),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const Spacer(flex: 3),

                // Loading Dots dan Teks "Loading...."
                RepaintBoundary(
                  child: FadeTransition(
                    opacity: _loadingOpacity,
                    child: Column(
                      children: [
                        AnimatedBuilder(
                          animation: _dotsController,
                          builder: (context, child) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(5, (index) {
                                final double t =
                                    (_dotsController.value * 5.0 - index) % 5.0;
                                final double dist = t < 0 ? t + 5.0 : t;
                                final double opacity =
                                    (1.0 - (dist / 5.0) * 0.72)
                                        .clamp(0.28, 1.0);
                                final double scale =
                                    (1.15 - (dist / 5.0) * 0.25)
                                        .clamp(0.88, 1.15);

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5),
                                  child: Transform.scale(
                                    scale: scale,
                                    child: Container(
                                      width: 13,
                                      height: 13,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white
                                            .withValues(alpha: opacity),
                                        boxShadow: opacity > 0.75
                                            ? [
                                                BoxShadow(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.45),
                                                  blurRadius: 6,
                                                  spreadRadius: 1,
                                                ),
                                              ]
                                            : null,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Loading....',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.white.withValues(alpha: 0.92),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 46),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

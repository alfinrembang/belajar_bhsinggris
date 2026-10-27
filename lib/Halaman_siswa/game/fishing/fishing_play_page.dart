import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../models/siswa_model.dart';
import '../../../../services/api_service.dart';
import '../../../../widgets/custom_button.dart';
import '../puzzle/game_coin_manager.dart';
import 'fishing_how_to_play_dialog.dart';
import 'fishing_visuals.dart';

/// Model Ikan Laut yang Berenang Bebas di Laut
class LiveOceanFish {
  final int id;
  final Map<String, dynamic> question;
  final String species; // clownfish, bluetang, yellowtang, angelfish, reef
  final String speciesName;
  final String speciesIndo;

  double x; // Posisi horizontal (piksel)
  double y; // Posisi vertikal (piksel)
  double vx; // Kecepatan horizontal
  double vy; // Kecepatan vertikal
  bool isFacingRight;
  bool isCaught;
  bool isFleeing;

  LiveOceanFish({
    required this.id,
    required this.question,
    required this.species,
    required this.speciesName,
    required this.speciesIndo,
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.isFacingRight,
    this.isCaught = false,
    this.isFleeing = false,
  });
}

/// Model Partikel Gelembung Udara di Lautan
class OceanBubble {
  double x;
  double y;
  double size;
  double speed;
  double wobble;
  double wobbleSpeed;

  OceanBubble({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.wobble,
    required this.wobbleSpeed,
  });
}

/// Halaman Permainan Edukatif "Tangkap Ikan" (Catch The Fish) Versi Laut Realistis
/// Gameplay: Click/Tap ikan laut yang berenang menembus samudra luas, ada sistem kasih makan, dan kuis edukasi
class FishingPlayPage extends StatefulWidget {
  final SiswaModel? siswa;
  final int level;

  const FishingPlayPage({
    super.key,
    this.siswa,
    this.level = 1,
  });

  @override
  State<FishingPlayPage> createState() => _FishingPlayPageState();
}

class _FishingPlayPageState extends State<FishingPlayPage>
    with SingleTickerProviderStateMixin {
  // Loop Animasi Renang Fisika Ikan & Gelembung Laut (60fps Halus)
  late AnimationController _swimLoopController;
  final Random _rng = Random();

  // State Permainan
  List<LiveOceanFish> _fishes = [];
  List<OceanBubble> _bubbles = [];
  bool _isLoading = true;
  int _lives = 3;
  int _score = 0;
  bool _isGameOver = false;
  bool _isGameWon = false;

  // Ukuran Kanvas Laut (Dihitung dari LayoutBuilder)
  Size _seaSize = const Size(360, 500);

  // Sistem Kasih Makan Ikan (Feeding / Bait System)
  bool _isFeedingActive = false;
  int _feedingRemainingSeconds = 0;
  int _feedingCooldownSeconds = 0;
  Timer? _feedingTimer;
  Timer? _cooldownTimer;
  Offset _foodPosition = const Offset(180, 250);

  // Fallback Soal jika Offline
  static const List<Map<String, dynamic>> _fallbackQuestions = [
    {
      'word': 'GENEROUS',
      'part_of_speech': 'Adjective (Kata Sifat)',
      'meaning': 'Dermawan / Suka Memberi',
      'options': [
        'Dermawan / Suka Memberi',
        'Pelit / Kikir',
        'Pemarah',
        'Pemberani',
      ],
      'explanation': 'Menggambarkan orang yang suka berbagi dan membantu sesama.',
      'example_sentence': 'Mr. Jack is a generous teacher who always helps students.',
    },
    {
      'word': 'DISCOVER',
      'part_of_speech': 'Verb (Kata Kerja)',
      'meaning': 'Menemukan Hal Baru',
      'options': [
        'Menyembunyikan Rahasia',
        'Menghilangkan Jejak',
        'Menemukan Hal Baru',
        'Melupakan Masa Lalu',
      ],
      'explanation': 'Tindakan mencari dan berhasil menjumpai sesuatu yang baru.',
      'example_sentence': 'They discover a hidden treasure in the cave.',
    },
    {
      'word': 'COURAGE',
      'part_of_speech': 'Noun (Kata Benda)',
      'meaning': 'Keberanian / Kegagahan',
      'options': [
        'Kelemahan Hati',
        'Ketakutan Berlebih',
        'Keberanian / Kegagahan',
        'Kebencian Mendalam',
      ],
      'explanation': 'Sifat atau tekad kuat dalam menghadapi rasa takut.',
      'example_sentence': 'He showed great courage during the difficult rescue.',
    },
    {
      'word': 'PATIENT',
      'part_of_speech': 'Adjective (Kata Sifat)',
      'meaning': 'Sabar / Tenang Menunggu',
      'options': [
        'Sombong / Angkuh',
        'Sabar / Tenang Menunggu',
        'Cemas / Khawatir',
        'Malas / Lamban',
      ],
      'explanation': 'Mampu menahan emosi dan tenang dalam menghadapi cobaan.',
      'example_sentence': 'You need to be patient when waiting for a big fish.',
    },
    {
      'word': 'HONEST',
      'part_of_speech': 'Adjective (Kata Sifat)',
      'meaning': 'Jujur / Berkata Benar',
      'options': [
        'Jujur / Berkata Benar',
        'Bohong / Dusta',
        'Curang / Tidak Adil',
        'Licik / Banyak Akal',
      ],
      'explanation': 'Lurus hati dan tidak melakukan kecurangan atau kebohongan.',
      'example_sentence': 'An honest person is trusted and respected by everyone.',
    },
  ];

  @override
  void initState() {
    super.initState();

    _initBubbles();

    _swimLoopController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(_updateFishMovement);

    _loadGameQuestions();
  }

  void _initBubbles() {
    _bubbles = List.generate(20, (index) {
      return OceanBubble(
        x: _rng.nextDouble() * 360.0,
        y: _rng.nextDouble() * 560.0,
        size: 7.0 + _rng.nextDouble() * 11.0,
        speed: 0.9 + _rng.nextDouble() * 1.5,
        wobble: _rng.nextDouble() * 2 * pi,
        wobbleSpeed: 0.03 + _rng.nextDouble() * 0.03,
      );
    });
  }

  @override
  void dispose() {
    _swimLoopController.dispose();
    _feedingTimer?.cancel();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  /// Memuat Soal dari Database Laravel API
  Future<void> _loadGameQuestions() async {
    List<Map<String, dynamic>> questionList = [];
    try {
      final res = await ApiService.getFishingSoal(level: widget.level);
      if (res['success'] == true && res['data'] is List && (res['data'] as List).isNotEmpty) {
        questionList = (res['data'] as List).map((e) => Map<String, dynamic>.from(e)).toList();
      }
    } catch (_) {}

    if (questionList.isEmpty) {
      questionList = List.from(_fallbackQuestions);
    }

    // Ambil maksimal 5-6 soal untuk satu sesi permainan
    if (questionList.length > 5) {
      questionList = questionList.take(5).toList();
    }

    _spawnFishes(questionList);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      _swimLoopController.repeat();
    }
  }

  /// Menghasilkan Ikan-Ikan Laut Sesuai Jumlah Soal
  void _spawnFishes(List<Map<String, dynamic>> questions) {
    const speciesPool = [
      {'species': 'clownfish', 'name': 'Clownfish', 'indo': 'Ikan Badut (Nemo)'},
      {'species': 'bluetang', 'name': 'Blue Tang', 'indo': 'Ikan Dory'},
      {'species': 'yellowtang', 'name': 'Yellow Tang', 'indo': 'Ikan Kuning'},
      {'species': 'angelfish', 'name': 'Coral Angel', 'indo': 'Ikan Bidadari'},
      {'species': 'ruby', 'name': 'Ruby Reef', 'indo': 'Ikan Karang Merah'},
    ];

    final fishes = <LiveOceanFish>[];
    for (int i = 0; i < questions.length; i++) {
      final spec = speciesPool[i % speciesPool.length];
      final isRight = _rng.nextBool();
      final speedX = (0.7 + _rng.nextDouble() * 0.9) * (isRight ? 1 : -1);
      final speedY = (0.3 + _rng.nextDouble() * 0.5) * (_rng.nextBool() ? 1 : -1);

      fishes.add(
        LiveOceanFish(
          id: i,
          question: questions[i],
          species: spec['species']!,
          speciesName: spec['name']!,
          speciesIndo: spec['indo']!,
          x: 40.0 + (i * 55.0) % 260.0,
          y: 60.0 + (i * 70.0) % 320.0,
          vx: speedX,
          vy: speedY,
          isFacingRight: isRight,
        ),
      );
    }

    _fishes = fishes;
  }

  /// Loop Update Pergerakan Fisika Ikan Laut & Gelembung Udara (Realistis & Ringan)
  void _updateFishMovement() {
    if (_isGameOver || _isGameWon || _isLoading) return;

    // 1. Update Partikel Gelembung Udara Realistis (Naik ke Atas)
    for (final bubble in _bubbles) {
      bubble.y -= bubble.speed;
      bubble.wobble += bubble.wobbleSpeed;
      if (bubble.y < -25.0) {
        bubble.y = _seaSize.height + 15.0;
        bubble.x = _rng.nextDouble() * max(100.0, _seaSize.width);
        bubble.speed = 0.9 + _rng.nextDouble() * 1.5;
      }
    }

    // 2. Update Pergerakan Ikan Laut (Menembus Layar & Menantang)
    final minY = 18.0;
    final maxY = max(80.0, _seaSize.height - 75.0);

    for (final fish in _fishes) {
      if (fish.isCaught) continue;

      if (_isFeedingActive) {
        // Mode Kasih Makan: Semua ikan tertarik ke titik makanan di tengah
        final dx = _foodPosition.dx - (fish.x + 35);
        final dy = _foodPosition.dy - (fish.y + 20);
        final dist = sqrt(dx * dx + dy * dy);

        if (dist > 35) {
          fish.vx = (dx / dist) * 2.4;
          fish.vy = (dy / dist) * 2.4;
        } else {
          // Mengelilingi makanan
          fish.vx = -dy / dist * 1.6;
          fish.vy = dx / dist * 1.6;
        }
        fish.isFacingRight = fish.vx >= 0;
      } else {
        // Mode Renang Bebas Normal (Realistis & Meliuk Alami)
        if (_rng.nextInt(100) < 3) {
          fish.vy += (_rng.nextDouble() - 0.5) * 0.35;
          fish.vy = fish.vy.clamp(-1.3, 1.3);
        }

        // --- SISTEM MENEMBUS LAYAR (Screen Wrap-Around) ---
        // Jika berenang ke kanan dan menembus keluar layar kanan
        if (fish.vx > 0 && fish.x > _seaSize.width + 70.0) {
          fish.x = -85.0;
          fish.y = minY + _rng.nextDouble() * (maxY - minY);
          fish.vx = 0.8 + _rng.nextDouble() * 0.9;
          fish.isFacingRight = true;
        }
        // Jika berenang ke kiri dan menembus keluar layar kiri
        else if (fish.vx < 0 && fish.x < -85.0) {
          fish.x = _seaSize.width + 70.0;
          fish.y = minY + _rng.nextDouble() * (maxY - minY);
          fish.vx = -(0.8 + _rng.nextDouble() * 0.9);
          fish.isFacingRight = false;
        }

        // Batas Kedalaman Permukaan Air & Dasar Karang
        if (fish.y <= minY) {
          fish.vy = fish.vy.abs();
        } else if (fish.y >= maxY) {
          fish.vy = -fish.vy.abs();
        }

        // Kecepatan kabur berangsur normal jika baru saja lepas
        if (fish.isFleeing) {
          fish.vx *= 0.98;
          fish.vy *= 0.98;
          if (fish.vx.abs() < 1.4) {
            fish.isFleeing = false;
          }
        }
      }

      fish.x += fish.vx;
      fish.y += fish.vy;
    }

    setState(() {});
  }

  /// Sistem Kasih Makan Ikan (Berkumpul di Tengah Selama 3 Detik)
  void _feedFishes() {
    if (_isFeedingActive || _feedingCooldownSeconds > 0) return;

    _feedingTimer?.cancel();
    _cooldownTimer?.cancel();

    _foodPosition = Offset(_seaSize.width * 0.5, _seaSize.height * 0.48);

    setState(() {
      _isFeedingActive = true;
      _feedingRemainingSeconds = 3;
    });

    _feedingTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        _feedingRemainingSeconds--;
        if (_feedingRemainingSeconds <= 0) {
          t.cancel();
          _isFeedingActive = false;
          _startFeedingCooldown();
        }
      });
    });
  }

  /// Cooldown Tombol Beri Makan (10 Detik)
  void _startFeedingCooldown() {
    setState(() {
      _feedingCooldownSeconds = 10;
    });
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        _feedingCooldownSeconds--;
        if (_feedingCooldownSeconds <= 0) {
          t.cancel();
        }
      });
    });
  }

  /// Menangani Klik pada Ikan -> Membuka Kuis Kosakata
  void _onFishTapped(LiveOceanFish fish) {
    if (fish.isCaught || _isGameOver || _isGameWon) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return _FishQuizModal(
          fish: fish,
          onAnswerSubmitted: (bool isCorrect) {
            Navigator.pop(ctx);
            _processQuizResult(fish, isCorrect);
          },
        );
      },
    );
  }

  /// Memproses Hasil Kuis (Benar = Ditangkap, Salah = Lepas)
  void _processQuizResult(LiveOceanFish fish, bool isCorrect) {
    if (isCorrect) {
      setState(() {
        fish.isCaught = true;
        _score += 100;
      });

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Text('✨', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Hebat! ${fish.speciesIndo} berhasil ditangkap! (+100 Skor)',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF16A34A),
          duration: const Duration(milliseconds: 1400),
        ),
      );

      // Cek apakah seluruh ikan telah ditangkap
      if (_fishes.every((f) => f.isCaught)) {
        _handleGameWin();
      }
    } else {
      setState(() {
        _lives--;
        fish.isFleeing = true;
        // Berikan dorongan kecepatan kabur
        fish.vx = (fish.isFacingRight ? 3.0 : -3.0);
        fish.vy = (_rng.nextBool() ? 2.5 : -2.5);
      });

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Text('⚠️', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Jawaban kurang tepat! Ikan lepas dan kabur.',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFFEF4444),
          duration: const Duration(milliseconds: 1400),
        ),
      );

      if (_lives <= 0) {
        _handleGameOver();
      }
    }
  }

  /// Menangani Kemenangan (Semua Ikan Tertangkap)
  Future<void> _handleGameWin() async {
    _swimLoopController.stop();
    setState(() {
      _isGameWon = true;
    });

    int stars = _lives == 3 ? 3 : (_lives == 2 ? 2 : 1);
    int coinsAwarded = 25;

    // Simpan ke database Laravel API
    try {
      final res = await ApiService.submitFishingSelesai(
        siswaId: widget.siswa?.id,
        difficulty: 'mudah',
        level: widget.level,
        stars: stars,
        score: _score,
        fishName: 'Ocean Master Fish',
        fishEmoji: '🐠',
        coinsEarned: 25,
      );

      if (res['success'] == true) {
        if (res['coins_awarded'] != null) {
          coinsAwarded = (res['coins_awarded'] as num).toInt();
        }
        if (res['koin'] != null) {
          GameCoinManager.setCoins((res['koin'] as num).toInt());
        }
      }
    } catch (_) {
      GameCoinManager.addCoins(25);
    }

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          backgroundColor: Colors.white,
          elevation: 20,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF38BDF8), Color(0xFF0284C7)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0284C7).withValues(alpha: 0.35),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text('🏆', style: TextStyle(fontSize: 42)),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Semua Ikan Tertangkap! 🐠',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Luar biasa! Seluruh kosakata berhasil kamu kuasai dan semua ikan laut masuk ke embermu!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFF64748B),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.monetization_on_rounded,
                        color: coinsAwarded > 0 ? const Color(0xFFD97706) : const Color(0xFF94A3B8),
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        coinsAwarded > 0 ? '+$coinsAwarded Koin (Skor: $_score)' : '+0 Koin (Sudah Diklaim)',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: coinsAwarded > 0 ? const Color(0xFFB45309) : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Mainkan Lagi',
                  icon: Icons.replay_rounded,
                  gradientColors: const [Color(0xFF0EA5E9), Color(0xFF0284C7)],
                  onTap: () {
                    Navigator.pop(ctx);
                    _restartGame();
                  },
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Kembali ke Beranda',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Menangani Kekalahan (Nyawa Habis)
  void _handleGameOver() {
    _swimLoopController.stop();
    setState(() {
      _isGameOver = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          backgroundColor: Colors.white,
          elevation: 16,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFFCA5A5), width: 2),
                  ),
                  child: const Center(
                    child: Text('🐟💨', style: TextStyle(fontSize: 34)),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Ikan-Ikan Berhasil Kabur!',
                  style: GoogleFonts.poppins(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Energimu habis karena beberapa kali jawaban kurang tepat. Ayo coba lagi dan tangkap ikannya!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFF64748B),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 22),
                CustomButton(
                  text: 'Coba Lagi',
                  icon: Icons.replay_rounded,
                  onTap: () {
                    Navigator.pop(ctx);
                    _restartGame();
                  },
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Kembali ke Beranda',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Mengulang Permainan
  void _restartGame() {
    setState(() {
      _lives = 3;
      _score = 0;
      _isGameOver = false;
      _isGameWon = false;
      _isFeedingActive = false;
      _feedingRemainingSeconds = 0;
      _feedingCooldownSeconds = 0;
      for (final f in _fishes) {
        f.isCaught = false;
        f.isFleeing = false;
      }
    });
    _swimLoopController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    final caughtCount = _fishes.where((f) => f.isCaught).length;
    final totalCount = _fishes.length;

    return Scaffold(
      backgroundColor: const Color(0xFF0369A1),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Header (Kembali, Status Tangkapan, Nyawa, Skor, Tombol Bantuan)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Row(
                children: [
                  // Tombol Keluar
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.close_rounded,
                          color: Color(0xFF0369A1), size: 18),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Badge Mode & Indikator Tangkapan Ikan (Anti Overflow)
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🐠', style: TextStyle(fontSize: 14)),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              '$caughtCount/$totalCount Ikan Tertangkap',
                              style: GoogleFonts.poppins(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF0284C7),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Nyawa Pemain (❤️❤️❤️)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(3, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 1.5),
                          child: Icon(
                            Icons.favorite_rounded,
                            size: 14,
                            color: index < _lives
                                ? const Color(0xFFEF4444)
                                : const Color(0xFFCBD5E1),
                          ),
                        );
                      }),
                    ),
                  ),

                  const SizedBox(width: 6),

                  // Tombol Bantuan (?)
                  GestureDetector(
                    onTap: () => showFishingHowToPlay(context),
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: const Icon(Icons.help_outline_rounded,
                          color: Color(0xFF0284C7), size: 17),
                    ),
                  ),
                ],
              ),
            ),

            // 2. Kanvas Pemandangan Bawah Laut (Underwater Ocean Canvas)
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  _seaSize = Size(constraints.maxWidth, constraints.maxHeight);

                  return Stack(
                    children: [
                      // Latar Belakang Gradasi Samudra
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF0284C7), // Air laut toska cerah atas
                              Color(0xFF0369A1),
                              Color(0xFF075985),
                              Color(0xFF0C4A6E), // Kedalaman laut samudra bawah
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),

                      // Sinar Matahari Tembus Air (Caustics Light Effect)
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: 90,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withValues(alpha: 0.25),
                                Colors.transparent,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),

                      // Partikel Gelembung Udara Realistis Naik ke Permukaan Laut
                      for (final bubble in _bubbles)
                        Positioned(
                          left: bubble.x + sin(bubble.wobble) * 6.0,
                          top: bubble.y,
                          child: IgnorePointer(
                            child: Container(
                              width: bubble.size,
                              height: bubble.size,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    Colors.white.withValues(alpha: 0.55),
                                    Colors.white.withValues(alpha: 0.15),
                                    Colors.cyanAccent.withValues(alpha: 0.3),
                                  ],
                                  center: const Alignment(-0.35, -0.35),
                                ),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.65),
                                  width: 1.0,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.cyanAccent.withValues(alpha: 0.2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Align(
                                alignment: const Alignment(-0.45, -0.45),
                                child: Container(
                                  width: bubble.size * 0.28,
                                  height: bubble.size * 0.28,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                      // Hiasan Terumbu Karang & Rumput Laut di Dasar
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('🪸🌿', style: TextStyle(fontSize: 34, color: Colors.white.withValues(alpha: 0.85))),
                            Text('🫧', style: TextStyle(fontSize: 20, color: Colors.white.withValues(alpha: 0.5))),
                            Text('🪸', style: TextStyle(fontSize: 28, color: Colors.white.withValues(alpha: 0.85))),
                            Text('🫧', style: TextStyle(fontSize: 16, color: Colors.white.withValues(alpha: 0.5))),
                            Text('🌿🪸', style: TextStyle(fontSize: 34, color: Colors.white.withValues(alpha: 0.85))),
                          ],
                        ),
                      ),

                      // Animasi Makanan Ikan di Tengah Laut saat tombol "Beri Makan" aktif
                      if (_isFeedingActive)
                        Positioned(
                          left: _foodPosition.dx - 45,
                          top: _foodPosition.dy - 35,
                          child: FishFoodBaitWidget(
                            remainingSeconds: _feedingRemainingSeconds,
                          ),
                        ),

                      // Ikan-Ikan Laut yang Sedang Berenang Bebas & Realistis (Clickable Fish)
                      if (!_isLoading)
                        for (final fish in _fishes)
                          if (!fish.isCaught)
                            Positioned(
                              left: fish.x,
                              top: fish.y,
                              child: OceanSwimmerFishWidget(
                                species: fish.species,
                                isFacingRight: fish.isFacingRight,
                                isCaught: fish.isCaught,
                                onTap: () => _onFishTapped(fish),
                              ),
                            ),

                      // Indikator Loading Data Soal
                      if (_isLoading)
                        const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),

                      // 3. Tombol Mengapung "Beri Makan Ikan" di Pojok Bawah
                      Positioned(
                        bottom: 18,
                        right: 18,
                        child: GestureDetector(
                          onTap: _feedFishes,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              gradient: _feedingCooldownSeconds > 0
                                  ? const LinearGradient(
                                      colors: [Color(0xFF94A3B8), Color(0xFF64748B)],
                                    )
                                  : const LinearGradient(
                                      colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                                    ),
                              borderRadius: BorderRadius.circular(22),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.25),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                              border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 1.5),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _isFeedingActive
                                      ? '🦐'
                                      : (_feedingCooldownSeconds > 0 ? '⏳' : '🦐'),
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  _isFeedingActive
                                      ? 'Ikan Berkumpul! 🦐'
                                      : (_feedingCooldownSeconds > 0
                                          ? 'Cooldown (${_feedingCooldownSeconds}s)'
                                          : 'Beri Makan Ikan 🦐'),
                                  style: GoogleFonts.poppins(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Floating Hint di Kiri Bawah
                      Positioned(
                        bottom: 22,
                        left: 18,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.touch_app_rounded, color: Colors.white, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                'Klik Ikan untuk Menangkap!',
                                style: GoogleFonts.poppins(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Modal Kuis Kosakata saat Ikan Diklik (Lengkap dengan Feedback Warna & Highlight Kunci Jawaban)
class _FishQuizModal extends StatefulWidget {
  final LiveOceanFish fish;
  final ValueChanged<bool> onAnswerSubmitted;

  const _FishQuizModal({
    required this.fish,
    required this.onAnswerSubmitted,
  });

  @override
  State<_FishQuizModal> createState() => _FishQuizModalState();
}

class _FishQuizModalState extends State<_FishQuizModal> {
  String? _selectedOption;
  bool? _isCorrect;
  bool _isEvaluating = false;

  void _handleOptionClick(String option, String correctMeaning) async {
    if (_isEvaluating) return;

    final isCorrect = option.trim() == correctMeaning.trim();
    setState(() {
      _isEvaluating = true;
      _selectedOption = option;
      _isCorrect = isCorrect;
    });

    // Berikan jeda 950ms agar siswa membaca arti yang benar
    await Future.delayed(const Duration(milliseconds: 950));
    if (!mounted) return;

    widget.onAnswerSubmitted(isCorrect);
  }

  Color _getPartOfSpeechColor(String pos) {
    final lower = pos.toLowerCase();
    if (lower.contains('verb')) return const Color(0xFF059669);
    if (lower.contains('adjective')) return const Color(0xFF0284C7);
    if (lower.contains('noun')) return const Color(0xFF7C3AED);
    return const Color(0xFFD97706);
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.fish.question;
    final options = (q['options'] as List? ?? []).map((e) => e.toString()).toList();
    final correctMeaning = q['meaning']?.toString() ?? '';
    final pos = q['part_of_speech']?.toString() ?? 'Vocabulary';

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Garis Handle Modal
          Container(
            width: 44,
            height: 5,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 14),

          // Header Spesies Ikan yang Ditangkap
          // Header Spesies Ikan yang Ditangkap (Anti Overflow)
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F2FE),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('🐠', style: TextStyle(fontSize: 20)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.fish.speciesIndo,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF0F172A),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Jawab kuis untuk menangkap ikan!',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: const Color(0xFF64748B),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Badge Part of Speech
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _getPartOfSpeechColor(pos).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  pos,
                  style: GoogleFonts.poppins(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: _getPartOfSpeechColor(pos),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Kartu Kata Utama Bahasa Inggris & Contoh Kalimat
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9)],
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                Text(
                  q['word']?.toString() ?? 'WORD',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    color: const Color(0xFF0284C7),
                  ),
                ),
                if (q['example_sentence'] != null &&
                    q['example_sentence'].toString().isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    '💡 "${q['example_sentence']}"',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 11.5,
                      fontStyle: FontStyle.italic,
                      color: const Color(0xFF64748B),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Banner Feedback Jawaban Benar / Salah
          if (_selectedOption != null)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: _isCorrect == true ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isCorrect == true ? const Color(0xFF22C55E) : const Color(0xFFEF4444),
                  width: 1.2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isCorrect == true ? Icons.check_circle_rounded : Icons.cancel_rounded,
                    color: _isCorrect == true ? const Color(0xFF15803D) : const Color(0xFFB91C1C),
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      _isCorrect == true
                          ? '✨ BENAR! Ikan berhasil ditangkap!'
                          : '⚠️ KURANG TEPAT! Arti: "$correctMeaning"',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: _isCorrect == true ? const Color(0xFF15803D) : const Color(0xFFB91C1C),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

          // Grid 4 Pilihan Jawaban
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 2.3,
            ),
            itemCount: options.length,
            itemBuilder: (context, index) {
              final option = options[index];
              final isSelected = _selectedOption == option;
              final isCorrectOption = option.trim() == correctMeaning.trim();

              Color bgColor = const Color(0xFFF0FDF4);
              Color borderColor = const Color(0xFF86EFAC);
              Color textColor = const Color(0xFF15803D);
              IconData? statusIcon;
              Color iconColor = Colors.transparent;

              if (_selectedOption != null) {
                if (isSelected) {
                  if (_isCorrect == true) {
                    bgColor = const Color(0xFF22C55E);
                    borderColor = const Color(0xFF15803D);
                    textColor = Colors.white;
                    statusIcon = Icons.check_circle_rounded;
                    iconColor = Colors.white;
                  } else {
                    bgColor = const Color(0xFFEF4444);
                    borderColor = const Color(0xFFB91C1C);
                    textColor = Colors.white;
                    statusIcon = Icons.cancel_rounded;
                    iconColor = Colors.white;
                  }
                } else if (_isCorrect == false && isCorrectOption) {
                  // Highlight Kunci Jawaban yang Benar
                  bgColor = const Color(0xFFDCFCE7);
                  borderColor = const Color(0xFF16A34A);
                  textColor = const Color(0xFF15803D);
                  statusIcon = Icons.check_circle_outline_rounded;
                  iconColor = const Color(0xFF16A34A);
                } else {
                  bgColor = const Color(0xFFF8FAFC);
                  borderColor = const Color(0xFFE2E8F0);
                  textColor = const Color(0xFF94A3B8);
                }
              }

              return Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: _isEvaluating ? null : () => _handleOptionClick(option, correctMeaning),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: borderColor,
                        width: (isSelected || (_isCorrect == false && isCorrectOption)) ? 2.0 : 1.5,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: borderColor.withValues(alpha: 0.35),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (statusIcon != null) ...[
                            Icon(statusIcon, color: iconColor, size: 16),
                            const SizedBox(width: 5),
                          ],
                          Flexible(
                            child: Text(
                              option,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: textColor,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../models/siswa_model.dart';
import '../../../../services/api_service.dart';
import 'game_coin_manager.dart';
import 'puzzle_play_page.dart';

/// Model internal progres level puzzle per tingkat kesulitan
class LevelProgressData {
  final int level;
  final bool isUnlocked;
  final bool isCompleted;
  final int stars;
  final String? bestTime;

  const LevelProgressData({
    required this.level,
    required this.isUnlocked,
    required this.isCompleted,
    required this.stars,
    this.bestTime,
  });
}

/// Halaman Pilih Level Dinamis (Sesuai Gambar 1)
/// - Mengintegrasikan database API Laravel (`/api/puzzle/progres`).
/// - Sistem Penguncian: Level berikutnya HANYA terbuka jika level sebelumnya sudah selesai.
/// - Berlaku di seluruh tingkat kesulitan (Mudah, Sedang, Sulit).
/// - Dilengkapi koin dinamis dan kartu indikator level berikutnya.
class PuzzleLevelPage extends StatefulWidget {
  final SiswaModel? siswa;
  const PuzzleLevelPage({super.key, this.siswa});

  @override
  State<PuzzleLevelPage> createState() => _PuzzleLevelPageState();
}

class _PuzzleLevelPageState extends State<PuzzleLevelPage> {
  String _activeTab = 'Mudah';
  bool _isLoading = false;

  // Cache progres per tingkat kesulitan: 'mudah', 'sedang', 'sulit'
  final Map<String, List<LevelProgressData>> _progressCache = {};

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  /// Memuat progres dari Database Backend Laravel (dengan fallback lokal)
  Future<void> _loadProgress() async {
    final diffKey = _activeTab.toLowerCase();

    setState(() {
      _isLoading = true;
    });

    try {
      final res = await ApiService.getPuzzleProgres(
        siswaId: widget.siswa?.id,
        difficulty: diffKey,
      );

      if (res['success'] == true && res['data'] is List) {
        final List<dynamic> listRaw = res['data'];
        final List<LevelProgressData> loaded = [];

        for (final item in listRaw) {
          loaded.add(LevelProgressData(
            level: (item['level'] as num).toInt(),
            isUnlocked: item['is_unlocked'] == true,
            isCompleted: item['is_completed'] == true,
            stars: (item['stars'] as num?)?.toInt() ?? 0,
            bestTime: item['best_time']?.toString(),
          ));
        }

        if (mounted) {
          setState(() {
            _progressCache[diffKey] = loaded;
            if (res['koin'] != null) {
              GameCoinManager.setCoins((res['koin'] as num).toInt());
            }
          });
        }
      } else {
        _applyLocalFallback(diffKey);
      }
    } catch (_) {
      _applyLocalFallback(diffKey);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Fallback jika offline: Level 1 terbuka, Level 2-9 terkunci
  void _applyLocalFallback(String diffKey) {
    if (!_progressCache.containsKey(diffKey)) {
      _progressCache[diffKey] = List.generate(9, (index) {
        final lvl = index + 1;
        return LevelProgressData(
          level: lvl,
          isUnlocked: lvl == 1,
          isCompleted: false,
          stars: 0,
        );
      });
    }
  }

  List<LevelProgressData> get _currentLevels {
    final diffKey = _activeTab.toLowerCase();
    if (!_progressCache.containsKey(diffKey)) {
      _applyLocalFallback(diffKey);
    }
    return _progressCache[diffKey]!;
  }

  @override
  Widget build(BuildContext context) {
    final levels = _currentLevels;

    // Cari level berikutnya yang belum selesai
    final firstUncompleted = levels.firstWhere(
      (lvl) => !lvl.isCompleted,
      orElse: () => levels.last,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFE),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Header (Kembali, Judul, Koin Dinamis)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A)),
                    ),
                  ),
                  Text(
                    'Pilih Level',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),

                  // Koin Dinamis
                  ValueListenableBuilder<int>(
                    valueListenable: GameCoinManager.coins,
                    builder: (context, currentCoins, child) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFFDE68A)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.monetization_on_rounded, color: Color(0xFFD97706), size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '$currentCoins',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFFD97706),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // 2. Tabs Tingkat Kesulitan (Mudah, Sedang, Sulit)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: ['Mudah', 'Sedang', 'Sulit'].map((tab) {
                  final isActive = _activeTab == tab;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (_activeTab != tab) {
                          setState(() {
                            _activeTab = tab;
                          });
                          _loadProgress();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: isActive ? const Color(0xFF2563EB) : Colors.transparent,
                              width: 3,
                            ),
                          ),
                        ),
                        child: Text(
                          tab,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                            color: isActive ? const Color(0xFF2563EB) : const Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 18),

            // 3. Grid Level (9 Level Dinamis)
            Expanded(
              child: _isLoading && !_progressCache.containsKey(_activeTab.toLowerCase())
                  ? const Center(
                      child: CircularProgressIndicator(color: Color(0xFF0066D6)),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: levels.length,
                      itemBuilder: (context, index) {
                        final data = levels[index];
                        return _buildLevelCard(data);
                      },
                    ),
            ),

            // 4. Kartu Informasi Level Berikutnya (Sesuai Gambar 1)
            Padding(
              padding: const EdgeInsets.all(18),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Level Berikutnya',
                            style: GoogleFonts.poppins(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            firstUncompleted.level < 9
                                ? 'Selesaikan level ${firstUncompleted.level} untuk membuka level ${firstUncompleted.level + 1}'
                                : 'Selamat! Semua level di tingkat $_activeTab telah selesai.',
                            style: GoogleFonts.poppins(
                              fontSize: 11.5,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      firstUncompleted.level < 9
                          ? Icons.lock_rounded
                          : Icons.emoji_events_rounded,
                      color: const Color(0xFFF59E0B),
                      size: 28,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Membangun kartu level
  Widget _buildLevelCard(LevelProgressData data) {
    final level = data.level;
    final isUnlocked = data.isUnlocked;
    final stars = data.stars;

    // Jumlah potongan per level
    int pieces = 9;
    if (_activeTab.toLowerCase() == 'mudah' && level == 1) {
      pieces = 4;
    }

    return GestureDetector(
      onTap: () async {
        if (isUnlocked) {
          // Buka Halaman Main Puzzle
          await Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (c, a, s) => PuzzlePlayPage(
                level: level,
                pieces: pieces,
                difficulty: _activeTab.toLowerCase(),
                siswa: widget.siswa,
                isAlreadyCompleted: data.isCompleted,
              ),
              transitionDuration: const Duration(milliseconds: 350),
              transitionsBuilder: (c, a, s, child) =>
                  FadeTransition(opacity: a, child: child),
            ),
          );

          // Muat ulang progres dari database setelah selesai bermain
          _loadProgress();
        } else {
          // Notifikasi jika level masih terkunci
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Level $level masih terkunci! Selesaikan Level ${level - 1} terlebih dahulu untuk membukanya.',
                style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500),
              ),
              backgroundColor: const Color(0xFF0F172A),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          );
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isUnlocked ? Colors.white : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUnlocked
                ? (data.isCompleted ? const Color(0xFF10B981) : const Color(0xFF2563EB))
                : const Color(0xFFE2E8F0),
            width: isUnlocked ? 2.0 : 1.0,
          ),
          boxShadow: isUnlocked
              ? [
                  BoxShadow(
                    color: const Color(0xFF0066D6).withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isUnlocked) ...[
              Text(
                '$level',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
              ),
              Text(
                '$pieces Potongan',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 8),

              // Sistem Bintang (1 - 3 Bintang Terbuka)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  final active = index < stars;
                  return Icon(
                    Icons.star_rounded,
                    size: 15,
                    color: active ? const Color(0xFFF59E0B) : const Color(0xFFE2E8F0),
                  );
                }),
              ),
            ] else ...[
              Text(
                '$level',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFCBD5E1),
                ),
              ),
              Text(
                '$pieces Potongan',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFCBD5E1),
                ),
              ),
              const SizedBox(height: 8),
              const Icon(
                Icons.lock_rounded,
                color: Color(0xFFCBD5E1),
                size: 18,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

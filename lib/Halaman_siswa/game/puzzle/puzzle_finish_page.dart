import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../models/siswa_model.dart';
import '../../../../widgets/custom_button.dart';
import 'confetti_overlay.dart';
import 'puzzle_play_page.dart';

/// Halaman Menang / Selesai Puzzle (Sesuai Gambar 3)
/// Dilengkapi efek petasan/konfeti ringan, 2 indikator (Waktu & Best Time - hint dihilangkan),
/// dan tombol "Level Berikutnya" yang fungsional.
class PuzzleFinishPage extends StatelessWidget {
  final int level;
  final String difficulty;
  final SiswaModel? siswa;
  final String timeSpent;
  final String bestTime;
  final int stars;
  final int coinsEarned;
  final String imageAsset;

  const PuzzleFinishPage({
    super.key,
    required this.level,
    this.difficulty = 'mudah',
    this.siswa,
    this.timeSpent = '01:32',
    this.bestTime = '01:20',
    this.stars = 3,
    this.coinsEarned = 20,
    this.imageAsset = 'assets/images/rakun_hello.png',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Navy malam sesuai desain
      body: ConfettiOverlay(
        child: SafeArea(
          child: Column(
            children: [
              // 1. Header (Tombol Kembali)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                        ),
                        child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),

                      // 2. Judul Selamat
                      Text(
                        'Hebat!\nPuzzle Selesai!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 27,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          height: 1.25,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // 3. Thumbnail Gambar Puzzle dengan Bingkai Emas Bercahaya
                      Container(
                        width: 220,
                        height: 155,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFF59E0B), width: 3.5),
                          image: DecorationImage(
                            image: AssetImage(imageAsset),
                            fit: BoxFit.contain,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFF59E0B).withValues(alpha: 0.45),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 22),

                      // 4. Sistem 3 Bintang (Gambar 3)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildStar(stars >= 1, size: 36),
                          const SizedBox(width: 8),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildStar(stars >= 2, size: 48),
                          ),
                          const SizedBox(width: 8),
                          _buildStar(stars >= 3, size: 36),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // 5. Tepat 2 Indikator (Waktu & Best Time - Sesuai Permintaan, Hint Dibuang)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatItem('Waktu', timeSpent),
                            Container(width: 1, height: 32, color: Colors.white.withValues(alpha: 0.15)),
                            _buildStatItem('Best Time', bestTime),
                          ],
                        ),
                      ),

                      const SizedBox(height: 22),

                      // 6. Hadiah Koin
                      Text(
                        coinsEarned > 0 ? 'Kamu mendapatkan' : 'Hadiah Koin Level',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.monetization_on_rounded,
                            color: coinsEarned > 0 ? const Color(0xFFF59E0B) : const Color(0xFF94A3B8),
                            size: 26,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            coinsEarned > 0 ? '+$coinsEarned' : '+0',
                            style: GoogleFonts.poppins(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: coinsEarned > 0 ? const Color(0xFFFCD34D) : const Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                      if (coinsEarned == 0) ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                          ),
                          child: Text(
                            'Sudah pernah diselesaikan (Koin telah diklaim)',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF94A3B8),
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // 7. Tombol Aksi Bawah
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  children: [
                    // Tombol Level Berikutnya
                    CustomButton(
                      text: level < 9 ? 'Level Berikutnya' : 'Mainkan Lagi',
                      icon: Icons.play_arrow_rounded,
                      onTap: () {
                        if (level < 9) {
                          final nextLevel = level + 1;
                          final pieces = difficulty == 'mudah' && nextLevel == 1 ? 4 : 9;
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (c, a, s) => PuzzlePlayPage(
                                level: nextLevel,
                                pieces: pieces,
                                difficulty: difficulty,
                                siswa: siswa,
                              ),
                              transitionDuration: const Duration(milliseconds: 350),
                              transitionsBuilder: (c, a, s, child) =>
                                  FadeTransition(opacity: a, child: child),
                            ),
                          );
                        } else {
                          Navigator.pop(context);
                        }
                      },
                    ),

                    const SizedBox(height: 14),

                    // Tombol Kembali ke Level
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        'Kembali ke Level',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF94A3B8),
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
    );
  }

  Widget _buildStar(bool active, {required double size}) {
    return Icon(
      Icons.star_rounded,
      size: size,
      color: active ? const Color(0xFFFCD34D) : Colors.white.withValues(alpha: 0.18),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF94A3B8)),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

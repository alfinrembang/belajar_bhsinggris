import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../models/siswa_model.dart';
import '../../../../widgets/custom_button.dart';
import 'game_coin_manager.dart';
import 'puzzle_level_page.dart';

class PuzzleHomePage extends StatelessWidget {
  final SiswaModel? siswa;

  const PuzzleHomePage({super.key, this.siswa});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFE),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header (Tombol Kembali & Koin Dinamis)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Tombol Kembali
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

                    // Koin Dinamis (Reaktif dengan ValueListenableBuilder)
                    ValueListenableBuilder<int>(
                      valueListenable: GameCoinManager.coins,
                      builder: (context, currentCoins, child) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFFFDE68A),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFD97706).withValues(alpha: 0.12),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.monetization_on_rounded,
                                color: Color(0xFFD97706),
                                size: 18,
                              ),
                              const SizedBox(width: 5),
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

              // 2. Kartu Hero Utama (Puzzle Master)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 18),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0F172A).withValues(alpha: 0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Puzzle Master',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F172A),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Susun potongan, temukan keindahan!',
                      style: GoogleFonts.poppins(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Ilustrasi Puzzle Menarik (Pengganti Rakun)
                    _buildPuzzleIllustration(),

                    const SizedBox(height: 22),

                    // Tombol Mainkan Puzzle
                    CustomButton(
                      text: 'Mainkan Puzzle',
                      icon: Icons.play_arrow_rounded,
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (c, a, s) => PuzzleLevelPage(siswa: siswa),
                            transitionDuration: const Duration(milliseconds: 350),
                            transitionsBuilder: (c, a, s, child) =>
                                FadeTransition(opacity: a, child: child),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // 3. Cara Bermain (Rules)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CARA BERMAIN',
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1E293B),
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildRuleItem(1, 'Pilih Level', 'Pilih level sesuai tingkat kesulitanmu.', const Color(0xFF3B82F6)),
                    _buildRuleItem(2, 'Susun Puzzle', 'Geser potongan ke tempat yang tepat.', const Color(0xFF10B981)),
                    _buildRuleItem(3, 'Selesaikan Gambar', 'Lengkapi semua potongan untuk menyelesaikan puzzle.', const Color(0xFFF59E0B)),
                    _buildRuleItem(4, 'Dapatkan Hadiah', 'Semakin cepat, semakin banyak koin yang kamu dapatkan!', const Color(0xFF8B5CF6)),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // 4. Tingkat Kesulitan & Level
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TINGKAT KESULITAN & LEVEL',
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1E293B),
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildDifficultyCard('Mudah', '4 - 12 Potongan', 'Cocok untuk pemula. Potongan lebih sedikit dan bentuk lebih besar.', const Color(0xFFD1FAE5), const Color(0xFF059669)),
                    const SizedBox(height: 12),
                    _buildDifficultyCard('Sedang', '12 - 24 Potongan', 'Tantangan yang pas untuk melatih fokus dan ketelitian.', const Color(0xFFFEF3C7), const Color(0xFFD97706)),
                    const SizedBox(height: 12),
                    _buildDifficultyCard('Sulit', '25 - 36+ Potongan', 'Untuk ahli puzzle sejati! Lebih banyak potongan dan bentuk lebih kecil.', const Color(0xFFFEE2E2), const Color(0xFFDC2626)),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  /// Ilustrasi Puzzle Edukasi yang Menawan & Harmonis
  Widget _buildPuzzleIllustration() {
    return Container(
      width: double.infinity,
      height: 175,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFEFF6FF), // Biru langit lembut
            Color(0xFFE0F2FE),
            Color(0xFFF0FDF4), // Sentuhan mint lembut
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFBAE6FD).withValues(alpha: 0.7),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0284C7).withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Elemen dekoratif kilau / bintang kecil
          Positioned(
            top: 14,
            left: 18,
            child: Icon(
              Icons.auto_awesome,
              color: const Color(0xFFF59E0B).withValues(alpha: 0.7),
              size: 20,
            ),
          ),
          Positioned(
            bottom: 14,
            right: 20,
            child: Icon(
              Icons.auto_awesome,
              color: const Color(0xFF38BDF8).withValues(alpha: 0.75),
              size: 18,
            ),
          ),

          // Badge Tipe Puzzle di Pojok Kanan Atas
          Positioned(
            top: 14,
            right: 18,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.extension_rounded, size: 13, color: Color(0xFF0066D6)),
                  const SizedBox(width: 4),
                  Text(
                    'Jigsaw Art',
                    style: GoogleFonts.poppins(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0066D6),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Kanvas Puzzle Utama di Tengah
          Container(
            width: 148,
            height: 132,
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.12),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
            ),
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildPuzzlePieceTile(
                  icon: Icons.wb_sunny_rounded,
                  color: const Color(0xFFF59E0B),
                  bgColor: const Color(0xFFFEF3C7),
                  label: 'Sky',
                ),
                _buildPuzzlePieceTile(
                  icon: Icons.landscape_rounded,
                  color: const Color(0xFF10B981),
                  bgColor: const Color(0xFFD1FAE5),
                  label: 'Nature',
                ),
                _buildPuzzlePieceTile(
                  icon: Icons.water_drop_rounded,
                  color: const Color(0xFF0284C7),
                  bgColor: const Color(0xFFE0F2FE),
                  label: 'Lake',
                ),
                _buildPuzzlePieceTile(
                  icon: Icons.extension_rounded,
                  color: const Color(0xFF8B5CF6),
                  bgColor: const Color(0xFFEDE9FE),
                  label: 'Match',
                  isConnecting: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPuzzlePieceTile({
    required IconData icon,
    required Color color,
    required Color bgColor,
    required String label,
    bool isConnecting = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isConnecting ? const Color(0xFF8B5CF6) : color.withValues(alpha: 0.4),
          width: isConnecting ? 2.0 : 1.2,
        ),
        boxShadow: isConnecting
            ? [
                BoxShadow(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleItem(int step, String title, String desc, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$step',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFF64748B),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyCard(String title, String pieces, String desc, Color bgColor, Color textColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: textColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.extension_rounded, color: textColor, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              const Spacer(),
              Text(
                pieces,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: textColor.withValues(alpha: 0.85),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

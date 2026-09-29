import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../models/siswa_model.dart';
import '../../../../widgets/custom_button.dart';
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
              // 1. Header (Kembali & Koin)
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
                            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2)),
                          ],
                        ),
                        child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A)),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.monetization_on_rounded, color: Color(0xFFD97706), size: 16),
                          const SizedBox(width: 4),
                          Text('120', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFFD97706))),
                        ],
                      ),
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
                    BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 14, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Puzzle Master',
                      style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Susun potongan, temukan keindahan!',
                      style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 20),
                    
                    // Ilustrasi Puzzle
                    Container(
                      width: double.infinity,
                      height: 160,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(16),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/rakun_hello.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
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
                            transitionsBuilder: (c, a, s, child) => FadeTransition(opacity: a, child: child),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 3. Cara Bermain (Rules)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CARA BERMAIN',
                      style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFF1E293B)),
                    ),
                    const SizedBox(height: 16),
                    _buildRuleItem(1, 'Pilih Level', 'Pilih level sesuai tingkat kesulitanmu.', const Color(0xFF3B82F6)),
                    _buildRuleItem(2, 'Susun Puzzle', 'Geser potongan ke tempat yang tepat.', const Color(0xFF10B981)),
                    _buildRuleItem(3, 'Selesaikan Gambar', 'Lengkapi semua potongan untuk menyelesaikan puzzle.', const Color(0xFFF59E0B)),
                    _buildRuleItem(4, 'Dapatkan Hadiah', 'Semakin cepat, semakin banyak koin yang kamu dapatkan!', const Color(0xFF8B5CF6)),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 4. Tingkat Kesulitan & Level
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TINGKAT KESULITAN & LEVEL',
                      style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFF1E293B)),
                    ),
                    const SizedBox(height: 16),
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

  Widget _buildRuleItem(int step, String title, String desc, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
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
                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: color),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A))),
                const SizedBox(height: 2),
                Text(desc, style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF64748B), height: 1.4)),
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
              Icon(Icons.extension, color: textColor, size: 20),
              const SizedBox(width: 8),
              Text(title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: textColor)),
              const Spacer(),
              Text(pieces, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: textColor)),
            ],
          ),
          const SizedBox(height: 8),
          Text(desc, style: GoogleFonts.poppins(fontSize: 12, color: textColor.withValues(alpha: 0.8), height: 1.4)),
        ],
      ),
    );
  }
}

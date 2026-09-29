import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../models/siswa_model.dart';
import 'puzzle_finish_page.dart';
import '../../../../widgets/custom_button.dart';

class PuzzlePlayPage extends StatelessWidget {
  final int level;
  final int pieces;
  final SiswaModel? siswa;
  
  const PuzzlePlayPage({super.key, required this.level, required this.pieces, this.siswa});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFE),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Header (Kembali, Level, Waktu)
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
                  Column(
                    children: [
                      Text('Level $level', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A))),
                      Text('$pieces Potongan', style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF64748B))),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined, color: Color(0xFF0F172A), size: 20),
                      const SizedBox(width: 6),
                      Text('02:45', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A))),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 2. Area Papan Puzzle (Statis Placeholder)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0), width: 2),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/rakun_hello.png'), // Gambar rakun dari aset sebagai puzzle
                      fit: BoxFit.contain,
                      opacity: 0.15, // Efek bayangan background
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Simulasi grid board puzzle (3x3 statis)
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        itemCount: 9,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xFFE2E8F0).withValues(alpha: 0.5)),
                            ),
                            child: (index == 4 || index == 7) // Simulasi beberapa piece sudah terpasang
                                ? Container(
                                    margin: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2563EB).withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Center(child: Icon(Icons.extension, color: Color(0xFF2563EB), size: 32)),
                                  )
                                : null,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 3. Potongan Puzzle Tersedia di bawah (Statis)
            Container(
              height: 100,
              margin: const EdgeInsets.symmetric(horizontal: 18),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF8B5CF6).withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) => Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2))],
                  ),
                  child: const Icon(Icons.extension, color: Color(0xFF8B5CF6), size: 30),
                )),
              ),
            ),
            
            const SizedBox(height: 30),
            
            // 4. Tombol Selesai (Simulasi - Karena tidak ada tombol bantuan sesuai permintaan)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              child: CustomButton(
                text: 'Selesai (Simulasi Tampilan)',
                icon: Icons.check_circle_outline_rounded,
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (c, a, s) => PuzzleFinishPage(level: level, siswa: siswa),
                      transitionDuration: const Duration(milliseconds: 350),
                      transitionsBuilder: (c, a, s, child) => FadeTransition(opacity: a, child: child),
                    ),
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

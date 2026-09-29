import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../models/siswa_model.dart';
import '../../../../widgets/custom_button.dart';

class PuzzleFinishPage extends StatelessWidget {
  final int level;
  final SiswaModel? siswa;
  
  const PuzzleFinishPage({super.key, required this.level, this.siswa});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Latar belakang Navy gelap
      body: SafeArea(
        child: Column(
          children: [
            // 1. Header (Tombol Kembali)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // 2. Judul Selamat
                    Text(
                      'Hebat!\nPuzzle Selesai!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white, height: 1.2),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // 3. Gambar Thumbnail Puzzle
                    Container(
                      width: 220,
                      height: 160,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFF59E0B), width: 4),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/rakun_hello.png'), // Memanfaatkan aset yang sudah ada
                          fit: BoxFit.contain,
                        ),
                        boxShadow: [
                          BoxShadow(color: const Color(0xFFF59E0B).withValues(alpha: 0.4), blurRadius: 20, offset: const Offset(0, 8)),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // 4. Sistem Bintang (Statis 3 Bintang)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildStar(true, size: 40),
                        const SizedBox(width: 10),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: _buildStar(true, size: 50),
                        ),
                        const SizedBox(width: 10),
                        _buildStar(true, size: 40),
                      ],
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // 5. Statistik
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatItem('Waktu', '01:32'),
                          _buildStatItem('Best Time', '01:20'),
                          _buildStatItem('Hint Dipakai', '0'), // 0 Karena dibuat lebih menantang
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // 6. Hadiah Koin
                    Text('Kamu mendapatkan', style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xFF94A3B8))),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.monetization_on_rounded, color: Color(0xFFF59E0B), size: 28),
                        const SizedBox(width: 8),
                        Text('+20', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w800, color: const Color(0xFFFCD34D))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // 7. Tombol Navigasi
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CustomButton(
                    text: 'Level Berikutnya',
                    onTap: () => Navigator.pop(context), // Kembali simulasi
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text('Kembali ke Level', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF94A3B8))),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStar(bool active, {required double size}) {
    return Icon(Icons.star_rounded, size: size, color: active ? const Color(0xFFFCD34D) : Colors.white.withValues(alpha: 0.2));
  }
  
  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF94A3B8))),
        const SizedBox(height: 4),
        Text(value, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
      ],
    );
  }
}

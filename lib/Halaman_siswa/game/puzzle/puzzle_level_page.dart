import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../models/siswa_model.dart';
import 'puzzle_play_page.dart';

class PuzzleLevelPage extends StatefulWidget {
  final SiswaModel? siswa;
  const PuzzleLevelPage({super.key, this.siswa});

  @override
  State<PuzzleLevelPage> createState() => _PuzzleLevelPageState();
}

class _PuzzleLevelPageState extends State<PuzzleLevelPage> {
  String _activeTab = 'Mudah';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFE),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Header (Kembali, Judul, Koin)
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
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A)),
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
            
            // 2. Tabs Tingkat Kesulitan
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: ['Mudah', 'Sedang', 'Sulit'].map((tab) {
                  final isActive = _activeTab == tab;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _activeTab = tab),
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
            
            const SizedBox(height: 20),
            
            // 3. Grid Level
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  final level = index + 1;
                  // Simulasi: 3 level pertama terbuka
                  final isUnlocked = level <= 3;
                  return _buildLevelCard(level, isUnlocked);
                },
              ),
            ),
            
            // 4. Info Level Berikutnya (Statis)
            Padding(
              padding: const EdgeInsets.all(18),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Level Berikutnya', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A))),
                          const SizedBox(height: 4),
                          Text('Selesaikan level 3 untuk membuka level 4', style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF64748B))),
                        ],
                      ),
                    ),
                    const Icon(Icons.lock_rounded, color: Color(0xFFF59E0B), size: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelCard(int level, bool isUnlocked) {
    int pieces = 0;
    if (_activeTab == 'Mudah') pieces = level * 3 + 1;
    else if (_activeTab == 'Sedang') pieces = level * 4 + 8;
    else pieces = level * 5 + 20;

    return GestureDetector(
      onTap: isUnlocked ? () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (c, a, s) => PuzzlePlayPage(level: level, pieces: pieces, siswa: widget.siswa),
            transitionDuration: const Duration(milliseconds: 350),
            transitionsBuilder: (c, a, s, child) => FadeTransition(opacity: a, child: child),
          ),
        );
      } : null,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUnlocked ? (level == 3 ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0)) : const Color(0xFFF1F5F9),
            width: isUnlocked && level == 3 ? 2 : 1,
          ),
          boxShadow: isUnlocked ? [
            BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 4))
          ] : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isUnlocked) ...[
              Text('$level', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A))),
              Text('$pieces Potongan', style: GoogleFonts.poppins(fontSize: 10, color: const Color(0xFF64748B))),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) => Icon(
                  Icons.star_rounded, 
                  size: 16, 
                  color: (level == 3 && index == 2) ? const Color(0xFFE2E8F0) : const Color(0xFFF59E0B)
                )),
              ),
            ] else ...[
              Text('$level', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w800, color: const Color(0xFFCBD5E1))),
              Text('$pieces Potongan', style: GoogleFonts.poppins(fontSize: 10, color: const Color(0xFFCBD5E1))),
              const SizedBox(height: 8),
              const Icon(Icons.lock_rounded, color: Color(0xFFCBD5E1), size: 18),
            ]
          ],
        ),
      ),
    );
  }
}

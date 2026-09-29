import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Section Navigasi Soal Bawah: Legenda (Selesai, Aktif, Kosong) & Deretan Nomor Soal.
class IsiQuizNavigationPaletteSection extends StatelessWidget {
  final int totalQuestions;
  final int currentIndex;
  final Map<int, int> answers;
  final ValueChanged<int> onSelectQuestion;

  const IsiQuizNavigationPaletteSection({
    super.key,
    required this.totalQuestions,
    required this.currentIndex,
    required this.answers,
    required this.onSelectQuestion,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00386B).withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Baris: Teks "Navigasi Soal" & Legenda
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Navigasi Soal',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF334155),
                ),
              ),

              // Legenda: hijau Selesai, biru Aktif, putih Kosong
              Row(
                children: [
                  _buildLegendItem(const Color(0xFF10B981), 'Selesai'),
                  const SizedBox(width: 8),
                  _buildLegendItem(const Color(0xFF0056D2), 'Aktif'),
                  const SizedBox(width: 8),
                  _buildLegendItem(const Color(0xFFE2E8F0), 'Kosong'),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Deretan Nomor Soal Bulat (Sesuai Mockup)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: List.generate(totalQuestions, (index) {
                final bool isAnswered = answers.containsKey(index);
                final bool isActive = currentIndex == index;

                Color bgColor;
                Widget content;

                if (isAnswered) {
                  // Selesai -> Lingkaran Hijau Centang Putih
                  bgColor = const Color(0xFF10B981);
                  content = const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 18,
                  );
                } else if (isActive) {
                  // Aktif -> Lingkaran Biru Solid Angka Putih
                  bgColor = const Color(0xFF0056D2);
                  content = Text(
                    '${index + 1}',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  );
                } else {
                  // Kosong -> Lingkaran Biru Pastel Angka Biru
                  bgColor = const Color(0xFFEFF6FF);
                  content = Text(
                    '${index + 1}',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0056D2),
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.only(right: 7),
                  child: InkWell(
                    onTap: () => onSelectQuestion(index),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(child: content),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color dotColor, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 3),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 9.5,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }
}

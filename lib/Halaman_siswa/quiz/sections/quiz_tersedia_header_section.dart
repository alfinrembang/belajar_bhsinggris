import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Section Header Judul "Quiz Tersedia" dengan tautan interaktif "Lihat Semua ->".
class QuizTersediaHeaderSection extends StatelessWidget {
  final VoidCallback? onLihatSemuaTap;

  const QuizTersediaHeaderSection({super.key, this.onLihatSemuaTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Quiz Tersedia',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0F172A),
            letterSpacing: -0.2,
          ),
        ),
        InkWell(
          onTap: onLihatSemuaTap ??
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Menampilkan seluruh kuis yang tersedia...'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Lihat Semua',
                  style: GoogleFonts.poppins(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF334155),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 14,
                  color: Color(0xFF334155),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

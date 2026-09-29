import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Modal Hasil Skor Kuis saat Siswa Menyelesaikan Seluruh Soal.
class IsiQuizResultModal extends StatelessWidget {
  final int totalQuestions;
  final int correctAnswers;
  final int earnedXP;
  final VoidCallback onFinish;

  const IsiQuizResultModal({
    super.key,
    required this.totalQuestions,
    required this.correctAnswers,
    this.earnedXP = 50,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    final int score = totalQuestions > 0 ? ((correctAnswers / totalQuestions) * 100).round() : 0;
    final bool isPassed = score >= 70;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(26),
          topRight: Radius.circular(26),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFCBD5E1),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 18),

          // Ikon Prestasi
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: isPassed ? const Color(0xFFFEF3C7) : const Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isPassed ? Icons.emoji_events_rounded : Icons.sentiment_neutral_rounded,
              color: isPassed ? const Color(0xFFD97706) : const Color(0xFF64748B),
              size: 34,
            ),
          ),

          const SizedBox(height: 14),

          // Judul Selamat
          Text(
            isPassed ? 'Luar Biasa! Kuis Selesai 🎉' : 'Kuis Selesai! Terus Berlatih 👍',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
            ),
          ),

          const SizedBox(height: 4),

          Text(
            'Berikut adalah ringkasan hasil pengerjaan kuis kamu.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: const Color(0xFF64748B),
            ),
          ),

          const SizedBox(height: 18),

          // 3 Kartu Statistik Skor
          Row(
            children: [
              // 1. Skor Akhir
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '$score',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0056D2),
                        ),
                      ),
                      Text(
                        'Nilai',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // 2. Benar / Total
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '$correctAnswers/$totalQuestions',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                      Text(
                        'Benar',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // 3. Bonus XP
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '+$earnedXP',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFD97706),
                        ),
                      ),
                      Text(
                        'XP Didapat',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          // Tombol Kembali
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: onFinish,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0056D2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: Text(
                'Kembali ke Menu Kuis',
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

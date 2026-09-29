import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'isi_quiz_audio_player_widget.dart';

/// Section Kartu Soal Kuis: Badge Nomor di Pojok Kiri Atas, Teks Bacaan & Player Audio (Listening).
class IsiQuizQuestionCardSection extends StatelessWidget {
  final int questionNumber;
  final String questionText;
  final String? readingPassage;
  final bool isListening;
  final String? audioTitle;
  final String? audioDuration;

  const IsiQuizQuestionCardSection({
    super.key,
    required this.questionNumber,
    required this.questionText,
    this.readingPassage,
    this.isListening = false,
    this.audioTitle,
    this.audioDuration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFF1F5F9),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00386B).withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Konten Teks Soal & Listening
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row atas: Memberi ruang di kiri untuk badge nomor
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Placeholder ukuran badge nomor agar teks sejajar rapi
                      const SizedBox(width: 48),
                      const SizedBox(width: 10),
                      // Baris awal teks bacaan atau teks soal
                      Expanded(
                        child: Text(
                          readingPassage ?? questionText,
                          style: GoogleFonts.poppins(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0F172A),
                            height: 1.45,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Jika soal Listening: Munculkan Pemutar Audio
                  if (isListening) ...[
                    const SizedBox(height: 16),
                    IsiQuizAudioPlayerWidget(
                      audioTitle: audioTitle ?? 'Audio Percakapan Listening',
                      durationText: audioDuration ?? '00:45',
                    ),
                    const SizedBox(height: 14),
                    // Pertanyaan setelah audio didengar
                    Text(
                      questionText,
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                        height: 1.4,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Badge Nomor di Pojok Kiri Atas (Sesuai Mockup)
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: 46,
                height: 44,
                decoration: const BoxDecoration(
                  color: Color(0xFF0056D2), // Vibrant Blue
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Center(
                  child: Text(
                    '$questionNumber',
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

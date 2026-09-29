import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'listening_question_template.dart';

/// Konten Langkah 5:
/// Judul: Dengarkan Pengumuman
/// Audio: Audio 4 (00:00 / 00:45)
/// Soal: 4. Who is the announcement intended for?
/// Pilihan: A. All train passengers, B. Students of class 10, C. Library visitors, D. Hospital staff
class ListeningStep5Section extends StatefulWidget {
  const ListeningStep5Section({super.key});

  @override
  State<ListeningStep5Section> createState() => _ListeningStep5SectionState();
}

class _ListeningStep5SectionState extends State<ListeningStep5Section> {
  int? _selectedOption;

  final List<String> _options = const [
    'All train passengers',
    'Students of class 10',
    'Library visitors',
    'Hospital staff',
  ];

  @override
  Widget build(BuildContext context) {
    return ListeningQuestionTemplate(
      title: 'Dengarkan Pengumuman',
      audioTitle: 'Audio 4',
      totalDuration: '00:45',
      questionNumber: 4,
      questionText: 'Who is the announcement intended for?',
      options: _options,
      correctIndex: 1, // B. Students of class 10
      selectedOption: _selectedOption,
      onSelectOption: (index) {
        setState(() {
          _selectedOption = index;
        });
      },
      bottomWidget: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFDCFCE7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF86EFAC), width: 1.2),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: Color(0xFF10B981),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Langkah terakhir selesai! Tekan tombol "Selesai" untuk menyelesaikan modul.',
                style: GoogleFonts.poppins(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF065F46),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

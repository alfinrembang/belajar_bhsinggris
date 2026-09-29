import 'package:flutter/material.dart';
import 'listening_question_template.dart';

/// Konten Langkah 2 (Sesuai Mockup 1):
/// Judul: Dengarkan Percakapan 1
/// Audio: Audio 1 (00:00 / 01:24)
/// Soal: 1. What is the main topic of the conversation?
/// Pilihan: A. A new movie release, B. A school event, C. A lost wallet, D. A birthday party
class ListeningStep2Section extends StatefulWidget {
  const ListeningStep2Section({super.key});

  @override
  State<ListeningStep2Section> createState() => _ListeningStep2SectionState();
}

class _ListeningStep2SectionState extends State<ListeningStep2Section> {
  int? _selectedOption;

  final List<String> _options = const [
    'A new movie release',
    'A school event',
    'A lost wallet',
    'A birthday party',
  ];

  @override
  Widget build(BuildContext context) {
    return ListeningQuestionTemplate(
      title: 'Dengarkan Percakapan 1',
      audioTitle: 'Audio 1',
      totalDuration: '01:24',
      questionNumber: 1,
      questionText: 'What is the main topic of the conversation?',
      options: _options,
      correctIndex: 1, // B. A school event
      selectedOption: _selectedOption,
      onSelectOption: (index) {
        setState(() {
          _selectedOption = index;
        });
      },
    );
  }
}

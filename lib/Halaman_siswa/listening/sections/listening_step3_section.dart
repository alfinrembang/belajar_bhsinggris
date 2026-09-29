import 'package:flutter/material.dart';
import 'listening_question_template.dart';

/// Konten Langkah 3 (Sesuai Mockup 2):
/// Judul: Dengarkan Percakapan 2
/// Audio: Audio 2 (00:00 / 01:12)
/// Soal: 2. Where does the conversation take place?
/// Pilihan: A. In a restaurant, B. In a library, C. At the airport, D. In a hospital
class ListeningStep3Section extends StatefulWidget {
  const ListeningStep3Section({super.key});

  @override
  State<ListeningStep3Section> createState() => _ListeningStep3SectionState();
}

class _ListeningStep3SectionState extends State<ListeningStep3Section> {
  int? _selectedOption;

  final List<String> _options = const [
    'In a restaurant',
    'In a library',
    'At the airport',
    'In a hospital',
  ];

  @override
  Widget build(BuildContext context) {
    return ListeningQuestionTemplate(
      title: 'Dengarkan Percakapan 2',
      audioTitle: 'Audio 2',
      totalDuration: '01:12',
      questionNumber: 2,
      questionText: 'Where does the conversation take place?',
      options: _options,
      correctIndex: 0, // A. In a restaurant
      selectedOption: _selectedOption,
      onSelectOption: (index) {
        setState(() {
          _selectedOption = index;
        });
      },
    );
  }
}

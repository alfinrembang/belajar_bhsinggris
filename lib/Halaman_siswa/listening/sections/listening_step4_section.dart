import 'package:flutter/material.dart';
import 'listening_question_template.dart';

/// Konten Langkah 4:
/// Judul: Dengarkan Percakapan 3
/// Audio: Audio 3 (00:00 / 00:58)
/// Soal: 3. What time will the meeting start?
/// Pilihan: A. At 08:30 AM, B. At 09:00 AM, C. At 10:15 AM, D. At 01:00 PM
class ListeningStep4Section extends StatefulWidget {
  const ListeningStep4Section({super.key});

  @override
  State<ListeningStep4Section> createState() => _ListeningStep4SectionState();
}

class _ListeningStep4SectionState extends State<ListeningStep4Section> {
  int? _selectedOption;

  final List<String> _options = const [
    'At 08:30 AM',
    'At 09:00 AM',
    'At 10:15 AM',
    'At 01:00 PM',
  ];

  @override
  Widget build(BuildContext context) {
    return ListeningQuestionTemplate(
      title: 'Dengarkan Percakapan 3',
      audioTitle: 'Audio 3',
      totalDuration: '00:58',
      questionNumber: 3,
      questionText: 'What time will the meeting start?',
      options: _options,
      correctIndex: 1, // B. At 09:00 AM
      selectedOption: _selectedOption,
      onSelectOption: (index) {
        setState(() {
          _selectedOption = index;
        });
      },
    );
  }
}

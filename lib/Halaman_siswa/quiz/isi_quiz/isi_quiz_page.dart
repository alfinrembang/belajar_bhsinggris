import 'package:flutter/material.dart';
import '../../../models/siswa_model.dart';
import '../sections/quiz_list_section.dart';
import 'sections/isi_quiz_header_section.dart';
import 'sections/isi_quiz_question_card_section.dart';
import 'sections/isi_quiz_options_section.dart';
import 'sections/isi_quiz_action_buttons_section.dart';
import 'sections/isi_quiz_navigation_palette_section.dart';
import 'sections/isi_quiz_result_modal.dart';

/// Model Item Soal Kuis (Pilgan & Listening)
class QuizQuestionModel {
  final String id;
  final int questionNumber;
  final String? readingPassage;
  final String questionText;
  final bool isListening;
  final String? audioTitle;
  final String? audioDuration;
  final List<String> options;
  final int correctOptionIndex;

  const QuizQuestionModel({
    required this.id,
    required this.questionNumber,
    this.readingPassage,
    required this.questionText,
    this.isListening = false,
    this.audioTitle,
    this.audioDuration,
    required this.options,
    required this.correctOptionIndex,
  });
}

/// Halaman Isi Quiz Siswa: Menampilkan Soal Pilgan & Listening dengan Navigasi Interaktif.
class IsiQuizPage extends StatefulWidget {
  final SiswaModel? siswa;
  final QuizItemData? quizData;

  const IsiQuizPage({
    super.key,
    this.siswa,
    this.quizData,
  });

  @override
  State<IsiQuizPage> createState() => _IsiQuizPageState();
}

class _IsiQuizPageState extends State<IsiQuizPage> {
  int _currentIndex = 0;
  final Map<int, int> _answers = {}; // questionIndex -> selectedOptionIndex

  // Daftar Mock Soal: 9 Soal (Kombinasi Teks Bacaan / Pilgan & Listening Audio)
  late final List<QuizQuestionModel> _questions = [
    // Soal 1 (Sesuai mockup pengguna: Descriptive Text Cindy)
    const QuizQuestionModel(
      id: 'q1',
      questionNumber: 1,
      readingPassage:
          'her name is cindy she is my best frined she is tall and she has long hair seha has big round eyes and abeautiful smile,cindy is kind, friendly,and always helps me when i nedd helep',
      questionText: 'What is Cindy like based on the text above?',
      isListening: false,
      options: [
        'Shy & quiet',
        'Kind and helpful',
        'Arrogant & selfish',
        'Lazy & careless',
      ],
      correctOptionIndex: 1,
    ),

    // Soal 2 (Pilgan Teks Reading)
    const QuizQuestionModel(
      id: 'q2',
      questionNumber: 2,
      readingPassage:
          'My pet is a lovely golden retriever named Max. He has fluffy golden fur and a playful wagging tail. Every morning, he wakes me up by barking softly.',
      questionText: 'How does Max wake up the writer every morning?',
      isListening: false,
      options: [
        'By jumping onto the bed',
        'By barking softly',
        'By running outside',
        'By biting shoes',
      ],
      correctOptionIndex: 1,
    ),

    // Soal 3 (Listening Audio)
    const QuizQuestionModel(
      id: 'q3',
      questionNumber: 3,
      isListening: true,
      audioTitle: 'Audio 1: Describing a Vacation Spot',
      audioDuration: '00:45',
      questionText: 'Where did Sarah spend her last holiday according to the conversation?',
      options: [
        'In a serene mountain villa',
        'At Kuta Beach in Bali',
        'At her grandmother’s village',
        'At a crowded theme park',
      ],
      correctOptionIndex: 0,
    ),

    // Soal 4 (Pilgan Teks Reading)
    const QuizQuestionModel(
      id: 'q4',
      questionNumber: 4,
      readingPassage:
          'The Eiffel Tower is a wrought-iron lattice tower on the Champ de Mars in Paris, France. It stands over 300 meters tall and was built in 1889.',
      questionText: 'What material is the Eiffel Tower made of?',
      options: [
        'Solid concrete',
        'Wrought-iron lattice',
        'Polished bronze metal',
        'Hardened stainless steel',
      ],
      correctOptionIndex: 1,
    ),

    // Soal 5 (Listening Audio)
    const QuizQuestionModel(
      id: 'q5',
      questionNumber: 5,
      isListening: true,
      audioTitle: 'Audio 2: Interview with Chef Sandra',
      audioDuration: '00:30',
      questionText: 'What is Chef Sandra’s secret ingredient for her famous soup?',
      options: [
        'Spicy red pepper powder',
        'Fresh thyme and roasted garlic',
        'Sweet organic brown sugar',
        'Extra aged cheddar cheese',
      ],
      correctOptionIndex: 1,
    ),

    // Soal 6 (Pilgan Grammar Descriptive Text)
    const QuizQuestionModel(
      id: 'q6',
      questionNumber: 6,
      questionText: 'Which grammatical tense is predominantly used in a Descriptive Text?',
      isListening: false,
      options: [
        'Simple Past Tense',
        'Simple Present Tense',
        'Future Continuous Tense',
        'Past Perfect Tense',
      ],
      correctOptionIndex: 1,
    ),

    // Soal 7 (Pilgan Vocabulary Adjective)
    const QuizQuestionModel(
      id: 'q7',
      questionNumber: 7,
      questionText: 'Which of the following words is an adjective describing physical appearance?',
      isListening: false,
      options: [
        'Quickly',
        'Handsome',
        'Carefully',
        'Walking',
      ],
      correctOptionIndex: 1,
    ),

    // Soal 8 (Listening Audio)
    const QuizQuestionModel(
      id: 'q8',
      questionNumber: 8,
      isListening: true,
      audioTitle: 'Audio 3: Morning Routine of David',
      audioDuration: '00:40',
      questionText: 'What time does David start jogging every morning?',
      options: [
        '05:30 AM',
        '06:00 AM',
        '07:15 AM',
        '08:00 AM',
      ],
      correctOptionIndex: 0,
    ),

    // Soal 9 (Pilgan Generic Structure)
    const QuizQuestionModel(
      id: 'q9',
      questionNumber: 9,
      questionText: 'What are the two main generic structures of a Descriptive Text?',
      isListening: false,
      options: [
        'Orientation and Re-orientation',
        'Identification and Description',
        'Thesis and Arguments',
        'Goal and Materials',
      ],
      correctOptionIndex: 1,
    ),
  ];

  void _handleSelectOption(int optionIndex) {
    setState(() {
      _answers[_currentIndex] = optionIndex;
    });
  }

  void _handlePrevious() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
  }

  void _handleNext() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      _confirmFinishQuiz();
    }
  }

  void _handleSelectQuestion(int index) {
    if (index >= 0 && index < _questions.length) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  void _handleCloseTap() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Keluar dari Kuis?'),
        content: const Text(
          'Progres kuis yang belum diselesaikan tidak akan tersimpan. Apakah kamu yakin ingin kembali?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Ya, Keluar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmFinishQuiz() {
    final unansweredCount = _questions.length - _answers.length;

    if (unansweredCount > 0) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Kuis Belum Lengkap'),
          content: Text(
            'Masih ada $unansweredCount soal yang belum kamu jawab. Apakah kamu yakin ingin menyelesaikan kuis sekarang?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Periksa Kembali'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0056D2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
                _showResultModal();
              },
              child: const Text('Selesaikan', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    } else {
      _showResultModal();
    }
  }

  void _showResultModal() {
    int correctCount = 0;
    _answers.forEach((qIndex, selectedOpt) {
      if (qIndex < _questions.length &&
          _questions[qIndex].correctOptionIndex == selectedOpt) {
        correctCount++;
      }
    });

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (ctx) => IsiQuizResultModal(
        totalQuestions: _questions.length,
        correctAnswers: correctCount,
        earnedXP: widget.quizData?.xp ?? 50,
        onFinish: () {
          Navigator.of(ctx).pop();
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQ = _questions[_currentIndex];
    final selectedOption = _answers[_currentIndex];
    final quizTitle = widget.quizData != null
        ? 'Quiz: ${widget.quizData!.title}'
        : 'Quiz: Descriptive Text';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Off-White Minimalis Sesuai Mockup
      body: SafeArea(
        child: Column(
          children: [
            // 1. Top Bar Header (Tombol X & Judul)
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 10),
              child: IsiQuizHeaderSection(
                title: quizTitle,
                onCloseTap: _handleCloseTap,
              ),
            ),

            // 2. Area Konten Soal & Opsi (Scrollable)
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  children: [
                    const SizedBox(height: 6),

                    // Card Soal (Badge Nomor di Pojok Kiri Atas + Reading / Listening)
                    IsiQuizQuestionCardSection(
                      questionNumber: currentQ.questionNumber,
                      questionText: currentQ.questionText,
                      readingPassage: currentQ.readingPassage,
                      isListening: currentQ.isListening,
                      audioTitle: currentQ.audioTitle,
                      audioDuration: currentQ.audioDuration,
                    ),

                    const SizedBox(height: 18),

                    // Pilihan Jawaban A, B, C, D
                    IsiQuizOptionsSection(
                      options: currentQ.options,
                      selectedIndex: selectedOption,
                      onSelectOption: _handleSelectOption,
                    ),

                    const SizedBox(height: 20),

                    // Tombol Aksi [← Sebelumnya] dan [Lanjut →]
                    IsiQuizActionButtonsSection(
                      hasPrevious: _currentIndex > 0,
                      isLast: _currentIndex == _questions.length - 1,
                      onPrevious: _handlePrevious,
                      onNext: _handleNext,
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // 3. Navigasi Soal Bawah (Bottom Palette)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: IsiQuizNavigationPaletteSection(
                totalQuestions: _questions.length,
                currentIndex: _currentIndex,
                answers: _answers,
                onSelectQuestion: _handleSelectQuestion,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

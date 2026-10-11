import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/siswa_model.dart';
import '../../../services/api_service.dart';
import '../sections/quiz_list_section.dart';
import 'sections/isi_quiz_header_section.dart';
import 'sections/isi_quiz_question_card_section.dart';
import 'sections/isi_quiz_options_section.dart';
import 'sections/isi_quiz_action_buttons_section.dart';
import 'sections/isi_quiz_navigation_palette_section.dart';
import 'sections/isi_quiz_result_modal.dart';

/// Model Butir Soal Kuis (Pilgan, Reading Passage, Listening Audio)
class QuizQuestionModel {
  final String id;
  final int questionNumber;
  final String? readingPassage;
  final String questionText;
  final bool isListening;
  final String? audioTitle;
  final String? audioDuration;
  final String? audioUrl;
  final List<String> options;

  const QuizQuestionModel({
    required this.id,
    required this.questionNumber,
    this.readingPassage,
    required this.questionText,
    this.isListening = false,
    this.audioTitle,
    this.audioDuration,
    this.audioUrl,
    required this.options,
  });
}

/// Halaman Isi Quiz Siswa: Mengambil butir soal secara dinamis dari database guru,
/// mendukung timer countdown ujian, navigasi soal fleksibel, validasi wajib jawab
/// semua butir soal sebelum selesai, dan evaluasi nilai otomatis di server.
class IsiQuizPage extends StatefulWidget {
  final SiswaModel? siswa;
  final QuizItemData? quizData;
  final int? quizId;

  const IsiQuizPage({
    super.key,
    this.siswa,
    this.quizData,
    this.quizId,
  });

  @override
  State<IsiQuizPage> createState() => _IsiQuizPageState();
}

class _IsiQuizPageState extends State<IsiQuizPage> {
  int _currentIndex = 0;
  final Map<int, int> _answers = {}; // questionIndex -> selectedOptionIndex (0:A, 1:B, 2:C, 3:D)

  bool _isLoadingQuestions = true;
  String? _errorMessage;
  bool _isSubmitting = false;
  List<QuizQuestionModel> _questions = [];

  Timer? _timer;
  late int _remainingSeconds;
  int _elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    final durasi = widget.quizData?.durasiMenit ?? 20;
    _remainingSeconds = durasi * 60;
    _loadQuizQuestions();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _elapsedSeconds++;
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          timer.cancel();
          _handleTimeUp();
        }
      });
    });
  }

  String _formatTimer() {
    final m = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _handleTimeUp() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Waktu Ujian Habis!'),
        content: const Text(
          'Waktu pengerjaan kuis telah berakhir. Lembar jawaban Anda akan otomatis dikirimkan ke server.',
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0056D2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              _submitAnswers(force: true);
            },
            child: const Text('Kirim Jawaban Sekarang', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  /// Memuat butir soal dinamis dari backend API
  Future<void> _loadQuizQuestions() async {
    setState(() {
      _isLoadingQuestions = true;
      _errorMessage = null;
    });

    final qId = widget.quizId ?? int.tryParse(widget.quizData?.id ?? '');
    if (qId == null) {
      setState(() {
        _isLoadingQuestions = false;
        _errorMessage = 'ID paket kuis tidak valid.';
      });
      return;
    }

    try {
      final res = await ApiService.getDetailQuiz(qId);
      if (res['success'] == true && res['data'] != null) {
        final data = res['data'];
        final List<dynamic> rawSoals = data['soals'] ?? [];

        if (rawSoals.isNotEmpty) {
          final mapped = rawSoals.map((s) {
            final tipe = s['tipe_soal']?.toString() ?? 'pilgan';
            final isListening = tipe == 'listening';
            final opts = [
              s['pilihan_a']?.toString() ?? '-',
              s['pilihan_b']?.toString() ?? '-',
              s['pilihan_c']?.toString() ?? '-',
              s['pilihan_d']?.toString() ?? '-',
            ];

            return QuizQuestionModel(
              id: s['id']?.toString() ?? '0',
              questionNumber: int.tryParse(s['nomor_soal']?.toString() ?? '1') ?? 1,
              readingPassage: s['reading_passage']?.toString(),
              questionText: s['pertanyaan']?.toString() ?? 'Pertanyaan kuis',
              isListening: isListening,
              audioTitle: s['audio_title']?.toString(),
              audioDuration: s['audio_duration']?.toString(),
              audioUrl: ApiService.resolveAudioUrl(s['audio_url']?.toString()),
              options: opts,
            );
          }).toList();

          if (mounted) {
            setState(() {
              _questions = mapped;
              _isLoadingQuestions = false;
            });
            _startTimer();
          }
          return;
        } else {
          if (mounted) {
            setState(() {
              _isLoadingQuestions = false;
              _errorMessage = 'Paket kuis ini belum memiliki butir soal yang aktif.';
            });
          }
          return;
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoadingQuestions = false;
            _errorMessage = res['message'] ?? 'Gagal memuat butir soal dari server.';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingQuestions = false;
          _errorMessage = 'Gagal terhubung ke server kuis: $e';
        });
      }
    }
  }

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
    setState(() {
      _currentIndex = index;
    });
  }

  void _handleCloseTap() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Keluar dari Kuis?'),
        content: const Text(
          'Progres pengerjaan kuis kamu tidak akan tersimpan jika kamu keluar sebelum menekan tombol Selesai.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Lanjutkan Kuis'),
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
            child: const Text('Keluar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  /// Validasi ketat: Tombol selesai tidak dapat diproses jika masih ada soal belum terjawab
  void _confirmFinishQuiz() {
    final unansweredCount = _questions.length - _answers.length;

    if (unansweredCount > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Masih ada $unansweredCount soal yang belum dijawab! Mohon jawab semua soal sebelum menyelesaikan kuis.',
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    _submitAnswers();
  }

  /// Mengirim lembar jawaban lengkap ke server untuk dinilai
  Future<void> _submitAnswers({bool force = false}) async {
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);
    _timer?.cancel();

    final qId = widget.quizId ?? int.tryParse(widget.quizData?.id ?? '');

    // Konversi jawaban map integer (0,1,2,3) ke huruf opsi (A,B,C,D)
    final Map<String, String> jawaban = {};
    for (int i = 0; i < _questions.length; i++) {
      final q = _questions[i];
      final optIdx = _answers[i];
      if (optIdx != null && optIdx >= 0 && optIdx < 4) {
        jawaban[q.id] = ['A', 'B', 'C', 'D'][optIdx];
      } else if (force) {
        jawaban[q.id] = 'A'; // Pilihan default saat waktu habis darurat
      }
    }

    if (qId != null) {
      final res = await ApiService.submitQuizAnswers(
        quizId: qId,
        siswaId: widget.siswa?.id,
        jawaban: jawaban,
        waktuPengerjaanDetik: _elapsedSeconds,
      );

      if (!mounted) return;
      setState(() => _isSubmitting = false);

      if (res['success'] == true && res['data'] != null) {
        final d = res['data'];
        final totalQ = int.tryParse(d['total_soal']?.toString() ?? '') ?? _questions.length;
        final correctCount = int.tryParse(d['jumlah_benar']?.toString() ?? '') ?? 0;
        final earnedXp = int.tryParse(d['xp_didapat']?.toString() ?? '') ?? (widget.quizData?.xp ?? 60);

        _showResultModal(
          total: totalQ,
          correct: correctCount,
          xp: earnedXp,
        );
        return;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res['message'] ?? 'Gagal mengirim jawaban ke server!'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    } else {
      setState(() => _isSubmitting = false);
    }
  }

  void _showResultModal({required int total, required int correct, required int xp}) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (ctx) => IsiQuizResultModal(
        totalQuestions: total,
        correctAnswers: correct,
        earnedXP: xp,
        onFinish: () {
          Navigator.of(ctx).pop(); // Tutup modal
          Navigator.of(context).pop(); // Kembali ke daftar kuis
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. Tampilan Loading saat memuat butir soal
    if (_isLoadingQuestions) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: Color(0xFF0056D2)),
              const SizedBox(height: 16),
              Text(
                'Memuat soal ujian kuis...',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // 2. Tampilan Error jika soal gagal dimuat dari server
    if (_errorMessage != null || _questions.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline_rounded, size: 54, color: Color(0xFFEF4444)),
                  const SizedBox(height: 12),
                  Text(
                    'Gagal Memuat Kuis',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _errorMessage ?? 'Soal kuis tidak ditemukan di server.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 12.5,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Kembali'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: _loadQuizQuestions,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0056D2),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final currentQ = _questions[_currentIndex];
    final selectedOption = _answers[_currentIndex];
    final quizTitle = widget.quizData != null
        ? 'Quiz: ${widget.quizData!.title}'
        : 'Quiz Evaluasi';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Top Bar Header (Tombol X, Judul & Timer Countdown)
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 10),
              child: IsiQuizHeaderSection(
                title: quizTitle,
                timerText: _formatTimer(),
                isTimerWarning: _remainingSeconds <= 60,
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

                    // Card Soal (Badge Nomor, Reading Passage, Listening Audio)
                    IsiQuizQuestionCardSection(
                      questionNumber: currentQ.questionNumber,
                      questionText: currentQ.questionText,
                      readingPassage: currentQ.readingPassage,
                      isListening: currentQ.isListening,
                      audioTitle: currentQ.audioTitle,
                      audioDuration: currentQ.audioDuration,
                      audioUrl: currentQ.audioUrl,
                    ),

                    const SizedBox(height: 18),

                    // Pilihan Jawaban A, B, C, D
                    IsiQuizOptionsSection(
                      options: currentQ.options,
                      selectedIndex: selectedOption,
                      onSelectOption: _handleSelectOption,
                    ),

                    const SizedBox(height: 20),

                    // Tombol Aksi [Sebelumnya] dan [Lanjut / Selesai]
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

            // 3. Navigasi Soal Bawah (Bottom Palette 1..20)
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

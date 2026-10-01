import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/siswa_model.dart';
import '../../services/api_service.dart';
import '../../widgets/isi_materi_background.dart';
import 'sections/listening_header_section.dart';
import 'sections/listening_stepper_section.dart';
import 'sections/listening_hero_section.dart';
import 'sections/listening_tujuan_section.dart';
import 'sections/listening_question_template.dart';
import 'sections/listening_step2_section.dart';
import 'sections/listening_step3_section.dart';
import 'sections/listening_step4_section.dart';
import 'sections/listening_step5_section.dart';
import 'sections/listening_bottom_nav_section.dart';

/// Halaman Utama Latihan Listening Siswa.
/// Mendukung mode Dinamis (dari Backend Laravel via listeningId)
/// dan mode Statis (Fallback 5 Langkah Standar).
class ListeningSiswaPage extends StatefulWidget {
  final SiswaModel? siswa;
  final int? listeningId;
  final int initialStep;
  final int totalSteps;

  const ListeningSiswaPage({
    super.key,
    this.siswa,
    this.listeningId,
    this.initialStep = 1,
    this.totalSteps = 5,
  });

  @override
  State<ListeningSiswaPage> createState() => _ListeningSiswaPageState();
}

class _ListeningSiswaPageState extends State<ListeningSiswaPage> {
  late int _currentStep;
  bool _isBookmarked = false;

  // State Dinamis dari Backend
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _listeningData;
  List<Map<String, dynamic>> _soalList = [];
  final Map<int, int> _selectedAnswers = {}; // indexSoal -> selectedOptionIndex

  @override
  void initState() {
    super.initState();
    _currentStep = widget.initialStep;

    if (widget.listeningId != null) {
      _fetchDetailListening(widget.listeningId!);
    }
  }

  Future<void> _fetchDetailListening(int id) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final res = await ApiService.getDetailListening(id);

    if (!mounted) return;

    if (res['success'] == true && res['data'] != null) {
      final data = res['data'] as Map<String, dynamic>;
      final rawSoals = data['soals'] as List<dynamic>? ?? [];
      final parsedSoals = rawSoals
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();

      setState(() {
        _listeningData = data;
        _soalList = parsedSoals;
        _isLoading = false;
      });
    } else {
      setState(() {
        _errorMessage = res['message'] ?? 'Gagal memuat detail listening.';
        _isLoading = false;
      });
    }
  }

  int get _effectiveTotalSteps {
    if (widget.listeningId != null && _soalList.isNotEmpty) {
      return 1 + _soalList.length;
    }
    return widget.totalSteps;
  }

  int _getOptionIndex(dynamic val) {
    if (val == null) return 0;
    final str = val.toString().trim().toUpperCase();
    if (str == 'A') return 0;
    if (str == 'B') return 1;
    if (str == 'C') return 2;
    if (str == 'D') return 3;
    final num = int.tryParse(str);
    if (num != null && num >= 0 && num <= 3) return num;
    return 0;
  }

  void _handleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isBookmarked
              ? 'Materi Listening disimpan ke bookmark!'
              : 'Materi Listening dihapus dari bookmark!',
        ),
        duration: const Duration(milliseconds: 1500),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handlePrevious() {
    if (_currentStep > 1) {
      setState(() {
        _currentStep--;
      });
    }
  }

  Future<void> _handleNext() async {
    if (_currentStep < _effectiveTotalSteps) {
      setState(() {
        _currentStep++;
      });
    } else {
      // Langkah Terakhir: Selesaikan Listening & Kirim Skor ke Backend
      int skor = 100;
      int xpReward = _listeningData?['xp_reward'] is int
          ? _listeningData!['xp_reward']
          : (int.tryParse(_listeningData?['xp_reward']?.toString() ?? '') ?? 50);

      if (_soalList.isNotEmpty) {
        int correctCount = 0;
        for (int i = 0; i < _soalList.length; i++) {
          final correctIdx = _getOptionIndex(_soalList[i]['jawaban_benar']);
          if (_selectedAnswers[i] == correctIdx) {
            correctCount++;
          }
        }
        skor = ((correctCount / _soalList.length) * 100).round();
      }

      // Kirim status penyelesaian ke server
      if (widget.listeningId != null) {
        await ApiService.selesaikanListening(
          listeningId: widget.listeningId!,
          siswaId: widget.siswa?.id,
          skor: skor,
          xpReward: xpReward,
        );
      }

      if (!mounted) return;

      // Tampilkan Modal Dialog Hasil & XP
      _showResultDialog(skor, xpReward);
    }
  }

  void _showResultDialog(int skor, int xpReward) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon Trophy / Medali Perayaan
                Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEFF6FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.emoji_events_rounded,
                      color: Color(0xFF0056D2),
                      size: 40,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  'Latihan Selesai!',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  'Kerja bagus! Kamu telah menyelesaikan modul listening ini dengan baik.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 12.5,
                    color: const Color(0xFF64748B),
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 20),

                // Info Skor & XP Card
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Skor Kamu',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '$skor',
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF0056D2),
                            ),
                          ),
                        ],
                      ),
                      Container(width: 1, height: 36, color: const Color(0xFFCBD5E1)),
                      Column(
                        children: [
                          Text(
                            'Bonus XP',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '+$xpReward XP',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF10B981),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Tombol Kembali ke Daftar Listening
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(); // Tutup dialog
                      Navigator.of(context).pop(true); // Kembali ke daftar paket listening dengan sinyal refresh
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0056D2),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'Kembali ke Modul Listening',
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
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IsiMateriBackground(
      bottomNavigationBar: ListeningBottomNavSection(
        currentStep: _currentStep,
        totalSteps: _effectiveTotalSteps,
        onSebelumnyaTap: _handlePrevious,
        onLanjutTap: _handleNext,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header: Back Button, Title "Listening", Bookmark
          ListeningHeaderSection(
            isBookmarked: _isBookmarked,
            onBackTap: () => Navigator.of(context).pop(),
            onBookmarkTap: _handleBookmark,
          ),

          const SizedBox(height: 14),

          // 2. Stepper Progress: Materi X/Total
          ListeningStepperSection(
            currentStep: _currentStep,
            totalSteps: _effectiveTotalSteps,
          ),

          const SizedBox(height: 18),

          // 3. Step Content (Step 1 s/d Step N)
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 260),
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: _buildStepContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    if (_isLoading) {
      return Container(
        key: const ValueKey<String>('loading'),
        height: 350,
        alignment: Alignment.center,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF0056D2)),
            SizedBox(height: 16),
            Text('Memuat materi listening...'),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Container(
        key: const ValueKey<String>('error'),
        padding: const EdgeInsets.all(24),
        alignment: Alignment.center,
        child: Column(
          children: [
            const Icon(Icons.error_outline_rounded, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text(_errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _fetchDetailListening(widget.listeningId!),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    // Jika Mode Dinamis (ada soal dari backend)
    if (widget.listeningId != null && _soalList.isNotEmpty) {
      if (_currentStep == 1) {
        final List<String> rawTujuan = List<String>.from(
          _listeningData?['tujuan_belajar'] ?? [],
        );

        return Column(
          key: const ValueKey<int>(1),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListeningHeroSection(
              title: _listeningData?['judul'],
              subtitle: _listeningData?['deskripsi'],
            ),
            const SizedBox(height: 18),
            ListeningTujuanSection(
              poinTujuan: rawTujuan,
              transkrip: _listeningData?['transkrip'],
            ),
            const SizedBox(height: 16),
          ],
        );
      } else {
        final soalIndex = _currentStep - 2;
        final soal = _soalList[soalIndex];
        final options = [
          soal['pilihan_a']?.toString() ?? '',
          soal['pilihan_b']?.toString() ?? '',
          soal['pilihan_c']?.toString() ?? '',
          soal['pilihan_d']?.toString() ?? '',
        ];
        final correctIdx = _getOptionIndex(soal['jawaban_benar']);

        return Column(
          key: ValueKey<int>(_currentStep),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListeningQuestionTemplate(
              title: 'Dengarkan Percakapan ${_currentStep - 1}',
              audioTitle: _listeningData?['audio_title'] ?? 'Audio Track',
              totalDuration: _listeningData?['durasi'] ?? '02:00',
              questionNumber: soal['nomor_soal'] is int
                  ? soal['nomor_soal']
                  : (_currentStep - 1),
              questionText: soal['pertanyaan']?.toString() ?? '',
              options: options,
              correctIndex: correctIdx,
              selectedOption: _selectedAnswers[soalIndex],
              onSelectOption: (idx) {
                setState(() {
                  _selectedAnswers[soalIndex] = idx;
                });
              },
            ),
            const SizedBox(height: 16),
          ],
        );
      }
    }

    // Mode Fallback Statis (Step 1 s/d 5 standar)
    switch (_currentStep) {
      case 1:
        return Column(
          key: const ValueKey<int>(1),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            ListeningHeroSection(),
            SizedBox(height: 18),
            ListeningTujuanSection(),
            SizedBox(height: 16),
          ],
        );
      case 2:
        return const Column(
          key: ValueKey<int>(2),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListeningStep2Section(),
            SizedBox(height: 16),
          ],
        );
      case 3:
        return const Column(
          key: ValueKey<int>(3),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListeningStep3Section(),
            SizedBox(height: 16),
          ],
        );
      case 4:
        return const Column(
          key: ValueKey<int>(4),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListeningStep4Section(),
            SizedBox(height: 16),
          ],
        );
      case 5:
      default:
        return const Column(
          key: ValueKey<int>(5),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListeningStep5Section(),
            SizedBox(height: 16),
          ],
        );
    }
  }
}

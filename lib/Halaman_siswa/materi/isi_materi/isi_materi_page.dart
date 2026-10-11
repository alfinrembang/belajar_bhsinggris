import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../models/siswa_model.dart';
import '../../../../services/api_service.dart';
import '../../../../widgets/isi_materi_background.dart';
import 'sections/isi_materi_header_section.dart';
import 'sections/isi_materi_stepper_section.dart';
import 'sections/isi_materi_hero_section.dart';
import 'sections/isi_materi_tujuan_section.dart';
import 'sections/isi_materi_step2_section.dart';
import 'sections/isi_materi_step3_section.dart';
import 'sections/isi_materi_step4_section.dart';
import 'sections/isi_materi_bottom_nav_section.dart';

/// Halaman Utama Isi Materi Siswa.
/// Terhubung 100% Dinamis dengan Backend Laravel (GET /api/materi/{id}).
class IsiMateriPage extends StatefulWidget {
  final SiswaModel? siswa;
  final int? materiId;
  final String judulMateri;
  final int initialStep;
  final int totalSteps;

  const IsiMateriPage({
    super.key,
    this.siswa,
    this.materiId,
    this.judulMateri = 'Descriptive Text: Describing Famous Places',
    this.initialStep = 1,
    this.totalSteps = 4,
  });

  @override
  State<IsiMateriPage> createState() => _IsiMateriPageState();
}

class _IsiMateriPageState extends State<IsiMateriPage> {
  late int _currentStep;
  bool _isBookmarked = false;
  bool _isLoading = false;
  Map<String, dynamic>? _detailData;
  Map<String, String>? _step4Answers;
  int? _step4Benar;
  int? _step4Total;
  int _step4CheckedCount = 0;

  @override
  void initState() {
    super.initState();
    _currentStep = widget.initialStep;
    final id = widget.materiId ?? 1;
    _loadMateriDetail(id);
  }

  Future<void> _loadMateriDetail(int id) async {
    setState(() => _isLoading = true);
    final res = await ApiService.getDetailMateri(id);
    if (!mounted) return;
    if (res['success'] == true) {
      setState(() {
        _detailData = res['data'] as Map<String, dynamic>?;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  void _handleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isBookmarked
              ? 'Materi ditambahkan ke bookmark!'
              : 'Materi dihapus dari bookmark!',
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
    if (_currentStep < widget.totalSteps) {
      setState(() {
        _currentStep++;
      });
    } else {
      // Validasi ketat: jika ada soal latihan, harus dikerjakan dan diperiksa semua
      final soals = _detailData?['soals'] as List<dynamic>?;
      final totalSoal = soals?.length ?? 0;

      if (totalSoal > 0 && _step4CheckedCount < totalSoal) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '⚠️ Harap kerjakan dan periksa semua contoh soal terlebih dahulu! (Baru  dari  selesai)',
            ),
            backgroundColor: const Color(0xFFDC2626),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
        return;
      }

      await _selesaikanMateriDenganHasil(
        jawaban: _step4Answers,
        benar: _step4Benar,
        total: _step4Total,
      );
    }
  }

  Future<void> _selesaikanMateriDenganHasil({
    Map<String, String>? jawaban,
    int? benar,
    int? total,
  }) async {
    final title = _detailData?['judul']?.toString() ?? widget.judulMateri;
    final rawId = _detailData?['id']?.toString() ?? widget.materiId?.toString() ?? '1';
    final materiId = int.tryParse(rawId) ?? (widget.materiId ?? 1);
    final xpReward = _detailData?['xp_reward'] is int
        ? (_detailData!['xp_reward'] as int)
        : (int.tryParse(_detailData?['xp_reward']?.toString() ?? '') ?? 50);

    // Tampilkan loading dialog singkat
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF0066D6)),
      ),
    );

    // Simpan penyelesaian materi ke backend & cache lokal dengan jawaban riil
    final res = await ApiService.selesaikanMateri(
      materiId: materiId,
      siswaId: widget.siswa?.id,
      xpReward: xpReward,
      jawaban: jawaban,
    );

    if (!mounted) return;
    Navigator.of(context).pop(); // Tutup loading dialog

    final data = res['data'] as Map<String, dynamic>?;
    final int skor = data?['skor'] is int
        ? (data!['skor'] as int)
        : (total != null && total > 0 && benar != null
            ? ((benar / total) * 100).round()
            : 100);

    final int xpDidapat = data?['xp_didapat'] is int
        ? (data!['xp_didapat'] as int)
        : (total != null && total > 0 && benar != null
            ? (xpReward * (skor / 100)).round().clamp(5, xpReward)
            : xpReward);

    _showHasilEvaluasiDialog(
      title: title,
      skor: skor,
      xpDidapat: xpDidapat,
      benar: benar,
      total: total,
    );
  }

  void _showHasilEvaluasiDialog({
    required String title,
    required int skor,
    required int xpDidapat,
    int? benar,
    int? total,
  }) {
    final bool isLulus = skor >= 70;
    final Color primaryColor = isLulus ? const Color(0xFF059669) : const Color(0xFFD97706);
    final IconData icon = isLulus ? Icons.emoji_events_rounded : Icons.lightbulb_rounded;
    final String statusTitle = isLulus ? 'Hebat Sekali!' : 'Tetap Semangat!';
    final String statusSubtitle = isLulus
        ? 'Kamu berhasil menuntaskan modul ini dengan pemahaman yang sangat baik!'
        : 'Kamu telah menyelesaikan modul ini. Pelajari kembali materi untuk hasil lebih optimal!';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 10,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 26),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Badge Ikon
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: primaryColor, size: 38),
                ),
                const SizedBox(height: 16),

                // Judul Status
                Text(
                  statusTitle,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),

                // Nama Modul
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF64748B),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 18),

                // Nilai / Skor Box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Nilai Akhir',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '',
                            style: GoogleFonts.poppins(
                              fontSize: 40,
                              fontWeight: FontWeight.w800,
                              color: primaryColor,
                            ),
                          ),
                          Text(
                            ' / 100',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Statistik Mini (Benar & XP)
                Row(
                  children: [
                    if (total != null && total > 0) ...[
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Benar',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                ' dari ',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Reward XP',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: const Color(0xFFB45309),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '+ XP',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFFB45309),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Subtitle Motivasi
                Text(
                  statusSubtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 11.5,
                    color: const Color(0xFF64748B),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Tombol Kembali
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      Navigator.of(context).pop(true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0066D6),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'Kembali ke Menu Materi',
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
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
    final activeJudul = _detailData?['judul']?.toString() ?? widget.judulMateri;

    return IsiMateriBackground(
      bottomNavigationBar: IsiMateriBottomNavSection(
        currentStep: _currentStep,
        totalSteps: widget.totalSteps,
        onSebelumnyaTap: _handlePrevious,
        onLanjutTap: _handleNext,
      ),
      child: _isLoading
          ? const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 80),
                child: CircularProgressIndicator(color: Color(0xFF0066D6)),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header Section: Tombol Back, Judul Materi, Bookmark
                IsiMateriHeaderSection(
                  judulMateri: activeJudul,
                  isBookmarked: _isBookmarked,
                  onBackTap: () => Navigator.of(context).pop(),
                  onBookmarkTap: _handleBookmark,
                ),

                const SizedBox(height: 14),

                // 2. Stepper Progress Section: Materi X Dari Y & Bar Node
                IsiMateriStepperSection(
                  currentStep: _currentStep,
                  totalSteps: widget.totalSteps,
                ),

                const SizedBox(height: 18),

                // 3. Dynamic Step Content (Langkah 1 s/d Langkah 4)
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 280),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: _buildStepContent(activeJudul),
                ),
              ],
            ),
    );
  }

  Widget _buildStepContent(String activeJudul) {
    final kategori = _detailData?['kategori']?.toString() ?? 'Reading';
    final deskripsi = _detailData?['deskripsi_singkat']?.toString() ??
        'Mempelajari struktur identifikasi dan deskripsi tempat wisata bersejarah.';
    final penjelasan = _detailData?['penjelasan']?.toString() ??
        'Descriptive text adalah jenis teks yang bertujuan untuk menggambarkan orang, tempat, atau benda secara rinci dan spesifik.\n\nStruktur Teks:\n1. Identification: Mengenalkan objek yang akan digambarkan.\n2. Description: Menjelaskan kualitas, karakteristik fisik, dan keunikan objek.\n\nUnsur Bahasa:\n- Menggunakan Simple Present Tense.\n- Menggunakan banyak kata sifat (Adjectives).';
    final contohTeks = _detailData?['contoh_teks']?.toString() ??
        'Borobudur is a ninth-century Mahayana Buddhist temple located in Magelang Regency, Central Java, Indonesia. It is recognized as the world\'s largest Buddhist temple. The monument consists of nine stacked platforms, six square and three circular, topped by a central dome.';
    final gambarUrl = _detailData?['gambar_url']?.toString();
    final soals = _detailData?['soals'] as List<dynamic>?;
    final xpReward = _detailData?['xp_reward'] is int
        ? (_detailData!['xp_reward'] as int)
        : (int.tryParse(_detailData?['xp_reward']?.toString() ?? '') ?? 50);

    switch (_currentStep) {
      case 1:
        // Langkah 1: Overview & Sasaran Belajar
        return Column(
          key: const ValueKey<int>(1),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IsiMateriHeroSection(
              judul: activeJudul.contains(':')
                  ? activeJudul.split(':').first
                  : (activeJudul.contains(' ')
                      ? activeJudul.replaceFirst(' ', '\n')
                      : activeJudul),
              assetRakun: 'assets/images/rakun_materi.png',
            ),
            const SizedBox(height: 18),
            IsiMateriTujuanSection(
              judul: 'Tujuan & Sasaran Modul',
              subjudul: deskripsi,
              poinTujuan: [
                'Memahami konsep utama: $activeJudul',
                'Mempelajari tata bahasa & unsur kebahasaan materi',
                'Membaca contoh penerapan teks nyata & mendengarkan audio',
                'Menyelesaikan ${soals?.length ?? 5} butir latihan pemahaman (+ XP)',
              ],
            ),
            const SizedBox(height: 16),
          ],
        );
      case 2:
        // Langkah 2: Teori & Penjelasan Konsep dari Dashboard Guru
        return Column(
          key: const ValueKey<int>(2),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IsiMateriStep2Section(
              judul: activeJudul,
              kategori: kategori,
              penjelasan: penjelasan,
            ),
            const SizedBox(height: 16),
          ],
        );
      case 3:
        // Langkah 3: Contoh Teks Penerapan & Media Audio Listening dari Dashboard Guru
        return Column(
          key: const ValueKey<int>(3),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IsiMateriStep3Section(
              judul: activeJudul,
              contohTeks: contohTeks,
              gambarUrl: gambarUrl,
            ),
            const SizedBox(height: 16),
          ],
        );
      case 4:
      default:
        // Langkah 4: Latihan Soal Pemahaman (5 Butir Soal Interaktif dari Dashboard Guru)
        return Column(
          key: const ValueKey<int>(4),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IsiMateriStep4Section(
              soals: soals,
              xpReward: xpReward,
              onProgressChanged: (jawaban, checkedCount, total) {
                _step4Answers = jawaban;
                _step4CheckedCount = checkedCount;
                _step4Total = total;
              },
              onSelesai: (jawaban, benar, total) {
                _step4Answers = jawaban;
                _step4Benar = benar;
                _step4Total = total;
                _step4CheckedCount = total;
                _selesaikanMateriDenganHasil(
                  jawaban: jawaban,
                  benar: benar,
                  total: total,
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        );
    }
  }
}

import 'package:flutter/material.dart';
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
      // Langkah terakhir telah selesai
      final title = _detailData?['judul']?.toString() ?? widget.judulMateri;
      final rawId = _detailData?['id']?.toString() ?? widget.materiId?.toString() ?? '1';
      final materiId = int.tryParse(rawId) ?? (widget.materiId ?? 1);
      final xpReward = _detailData?['xp_reward'] is int
          ? (_detailData!['xp_reward'] as int)
          : (int.tryParse(_detailData?['xp_reward']?.toString() ?? '') ?? 50);

      // Simpan penyelesaian materi ke backend & cache lokal
      await ApiService.selesaikanMateri(
        materiId: materiId,
        siswaId: widget.siswa?.id,
        xpReward: xpReward,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text('🎉 Selamat! Materi $title selesai. +$xpReward XP'),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF059669),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
      Navigator.of(context).pop(true);
    }
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
    final audioUrl = _detailData?['audio_url']?.toString();
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
              audioUrl: audioUrl,
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
              onSelesai: _handleNext,
            ),
            const SizedBox(height: 16),
          ],
        );
    }
  }
}

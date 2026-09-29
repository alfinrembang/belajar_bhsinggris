import 'package:flutter/material.dart';
import '../../../../models/siswa_model.dart';
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
/// Disusun secara modular menggunakan sections dengan latar belakang IsiMateriBackground
/// dan mendukung alur tahapan materi lengkap (Step 1 s/d Step 4) secara dinamis & efisien.
class IsiMateriPage extends StatefulWidget {
  final SiswaModel? siswa;
  final String judulMateri;
  final int initialStep;
  final int totalSteps;

  const IsiMateriPage({
    super.key,
    this.siswa,
    this.judulMateri = 'Descriptive Text',
    this.initialStep = 1,
    this.totalSteps = 4,
  });

  @override
  State<IsiMateriPage> createState() => _IsiMateriPageState();
}

class _IsiMateriPageState extends State<IsiMateriPage> {
  late int _currentStep;
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _currentStep = widget.initialStep;
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

  void _handleNext() {
    if (_currentStep < widget.totalSteps) {
      setState(() {
        _currentStep++;
      });
    } else {
      // Langkah terakhir telah selesai
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎉 Selamat! Kamu telah menyelesaikan materi Descriptive Text.'),
          backgroundColor: Color(0xFF059669),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return IsiMateriBackground(
      bottomNavigationBar: IsiMateriBottomNavSection(
        currentStep: _currentStep,
        totalSteps: widget.totalSteps,
        onSebelumnyaTap: _handlePrevious,
        onLanjutTap: _handleNext,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header Section: Tombol Back, Judul Materi, Bookmark
          IsiMateriHeaderSection(
            judulMateri: widget.judulMateri,
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
            child: _buildStepContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 1:
        return Column(
          key: const ValueKey<int>(1),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section: Banner Soft Blue + Maskot Rakun
            IsiMateriHeroSection(
              judul: widget.judulMateri.contains(' ')
                  ? widget.judulMateri.replaceFirst(' ', '\n')
                  : widget.judulMateri,
              assetRakun: 'assets/images/rakun_materi.png',
            ),
            const SizedBox(height: 18),
            // Tujuan Pembelajaran Section: Kartu Putih Checklist
            const IsiMateriTujuanSection(),
            const SizedBox(height: 16),
          ],
        );
      case 2:
        return Column(
          key: const ValueKey<int>(2),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            // Konten Langkah 2: What is, Purpose, Contoh Penggunaan
            IsiMateriStep2Section(),
            SizedBox(height: 16),
          ],
        );
      case 3:
        return Column(
          key: const ValueKey<int>(3),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            // Konten Langkah 3: Generic Structure & Language Features
            IsiMateriStep3Section(),
            SizedBox(height: 16),
          ],
        );
      case 4:
      default:
        return Column(
          key: const ValueKey<int>(4),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            // Konten Langkah 4: Example Teks, Audio Listening Player, & Soal Pilihan Ganda
            IsiMateriStep4Section(),
            SizedBox(height: 16),
          ],
        );
    }
  }
}

import 'package:flutter/material.dart';
import '../../models/siswa_model.dart';
import '../../widgets/isi_materi_background.dart';
import 'sections/listening_header_section.dart';
import 'sections/listening_stepper_section.dart';
import 'sections/listening_hero_section.dart';
import 'sections/listening_tujuan_section.dart';
import 'sections/listening_step2_section.dart';
import 'sections/listening_step3_section.dart';
import 'sections/listening_step4_section.dart';
import 'sections/listening_step5_section.dart';
import 'sections/listening_bottom_nav_section.dart';

/// Halaman Utama Listening Siswa.
/// Menggunakan komponen reusable IsiMateriBackground dan modul terpisah (Step 1 s/d Step 5).
class ListeningSiswaPage extends StatefulWidget {
  final SiswaModel? siswa;
  final int initialStep;
  final int totalSteps;

  const ListeningSiswaPage({
    super.key,
    this.siswa,
    this.initialStep = 1,
    this.totalSteps = 5,
  });

  @override
  State<ListeningSiswaPage> createState() => _ListeningSiswaPageState();
}

class _ListeningSiswaPageState extends State<ListeningSiswaPage> {
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

  void _handleNext() {
    if (_currentStep < widget.totalSteps) {
      setState(() {
        _currentStep++;
      });
    } else {
      // Selesai seluruh langkah
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎉 Luar biasa! Kamu telah menyelesaikan modul Listening.'),
          backgroundColor: Color(0xFF0056D2),
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
      bottomNavigationBar: ListeningBottomNavSection(
        currentStep: _currentStep,
        totalSteps: widget.totalSteps,
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

          // 2. Stepper Progress: Materi X/5
          ListeningStepperSection(
            currentStep: _currentStep,
            totalSteps: widget.totalSteps,
          ),

          const SizedBox(height: 18),

          // 3. Step Content (Step 1 s/d Step 5)
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
    switch (_currentStep) {
      case 1:
        return Column(
          key: const ValueKey<int>(1),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            // Hero Section: Teks Listening & Maskot Rakun Headphone
            ListeningHeroSection(),
            SizedBox(height: 18),
            // Tujuan Pembelajaran: Ikon Target Bulat Biru & 3 Poin Checklist
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

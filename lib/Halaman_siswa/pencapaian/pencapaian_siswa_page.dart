import 'package:flutter/material.dart';
import '../../../models/siswa_model.dart';
import '../beranda/beranda_siswa_page.dart';
import '../materi/materi_siswa_page.dart';
import '../quiz/quiz_siswa_page.dart';
import '../game/game_siswa_page.dart';
import '../profil/profil_siswa_page.dart';
import '../beranda/sections/bottom_nav_bar_section.dart';
import '../../../widgets/pencapaian_badge_icon.dart';
import 'sections/pencapaian_header_section.dart';
import 'sections/pencapaian_stats_section.dart';
import 'sections/pencapaian_progress_section.dart';
import 'sections/pencapaian_filter_section.dart';
import 'sections/pencapaian_list_section.dart';
import 'sections/pencapaian_info_banner_section.dart';

/// Halaman Pencapaian Siswa: Menampilkan Prestasi, Lencana, Progres, & Filter.
class PencapaianSiswaPage extends StatefulWidget {
  final SiswaModel? siswa;

  const PencapaianSiswaPage({super.key, this.siswa});

  @override
  State<PencapaianSiswaPage> createState() => _PencapaianSiswaPageState();
}

class _PencapaianSiswaPageState extends State<PencapaianSiswaPage> {
  final int _selectedNavIndex = 4; // Tab Pencapaian Aktif (Index 4)
  String _activeFilter = 'Semua';

  // Mock data lencana sesuai mockup visual
  final List<LencanaItem> _allLencana = const [
    LencanaItem(
      id: '1',
      title: 'Top 10 RPL 1',
      description: 'Masuk peringkat 10 besar\nRPL 1 di kelas',
      info: 'Okt 2024',
      badgeType: BadgeType.trophy,
      isUnlocked: true,
      isRare: true,
    ),
    LencanaItem(
      id: '2',
      title: 'Early Bird',
      description: 'Belajar sebelum jam 06:00\nselama 7 hari',
      info: '06:00 WIB',
      badgeType: BadgeType.earlyBird,
      isUnlocked: true,
      isRare: false,
    ),
    LencanaItem(
      id: '3',
      title: 'Streak King',
      description: 'Belajar 7 hari berturut-turut\ntanpa absen',
      info: 'Minggu lalu',
      badgeType: BadgeType.streakKing,
      isUnlocked: true,
      isRare: true,
    ),
    LencanaItem(
      id: '4',
      title: 'Bug Hunter',
      description: 'Melaporkan 10 bug atau\nmasalah di aplikasi',
      info: '50 Glosarium',
      badgeType: BadgeType.bugHunter,
      isUnlocked: true,
      isRare: false,
    ),
    LencanaItem(
      id: '5',
      title: 'Score 100',
      description: 'Mendapatkan nilai 100 pada\nQuiz Modul 3',
      info: 'Quiz Modul 3',
      badgeType: BadgeType.score100,
      isUnlocked: true,
      isRare: false,
    ),
    LencanaItem(
      id: '6',
      title: 'TOEIC 550+',
      description: 'Mencapai skor TOEIC\nminimal 550',
      info: 'Terkunci',
      badgeType: BadgeType.locked,
      isUnlocked: false,
      isRare: true,
    ),
  ];

  List<LencanaItem> get _filteredLencana {
    if (_activeFilter.toLowerCase() == 'terbuka') {
      return _allLencana.where((item) => item.isUnlocked).toList();
    } else if (_activeFilter.toLowerCase() == 'terkunci') {
      return _allLencana.where((item) => !item.isUnlocked).toList();
    } else if (_activeFilter.toLowerCase() == 'langka') {
      return _allLencana.where((item) => item.isRare).toList();
    }
    return _allLencana;
  }

  void _navigateToNavIndex(int index) {
    if (index == _selectedNavIndex) return;

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (c, a, s) => BerandaSiswaPage(siswa: widget.siswa),
          transitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: (c, a, s, child) => FadeTransition(opacity: a, child: child),
        ),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (c, a, s) => MateriSiswaPage(siswa: widget.siswa),
          transitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: (c, a, s, child) => FadeTransition(opacity: a, child: child),
        ),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (c, a, s) => QuizSiswaPage(siswa: widget.siswa),
          transitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: (c, a, s, child) => FadeTransition(opacity: a, child: child),
        ),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (c, a, s) => GameSiswaPage(siswa: widget.siswa),
          transitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: (c, a, s, child) => FadeTransition(opacity: a, child: child),
        ),
      );
    } else if (index == 5) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (c, a, s) => ProfilSiswaPage(siswa: widget.siswa),
          transitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: (c, a, s, child) => FadeTransition(opacity: a, child: child),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavBarSection(
        currentIndex: _selectedNavIndex,
        onTap: _navigateToNavIndex,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // 1. Header Section: Tombol Back & Judul "Pencapaian"
              PencapaianHeaderSection(
                onBackTap: () {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (c, a, s) => BerandaSiswaPage(siswa: widget.siswa),
                      transitionDuration: const Duration(milliseconds: 300),
                      transitionsBuilder: (c, a, s, child) => FadeTransition(opacity: a, child: child),
                    ),
                  );
                },
              ),

              const SizedBox(height: 18),

              // 2. Stats Section: Lencana Terbuka (5) & Terkunci (8)
              const PencapaianStatsSection(
                totalTerbuka: 5,
                totalTerkunci: 8,
              ),

              const SizedBox(height: 14),

              // 3. Progress Section: Progress Keseluruhan 5 / 13
              const PencapaianProgressSection(
                totalTerbuka: 5,
                totalLencana: 13,
              ),

              const SizedBox(height: 16),

              // 4. Filter Chips Section: Semua, Terbuka, Terkunci, Langka
              PencapaianFilterSection(
                selectedFilter: _activeFilter,
                onFilterChanged: (filter) {
                  setState(() {
                    _activeFilter = filter;
                  });
                },
              ),

              const SizedBox(height: 14),

              // 5. List Lencana Section
              PencapaianListSection(
                items: _filteredLencana,
                onTapItem: (item) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Lencana ${item.title} (${item.isUnlocked ? 'Terbuka' : 'Terkunci'})'),
                      duration: const Duration(milliseconds: 1500),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),

              const SizedBox(height: 14),

              // 6. Info Banner Section (Motivasi Bawah)
              const PencapaianInfoBannerSection(),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../models/siswa_model.dart';
import '../../../widgets/student_background.dart';
import '../../../widgets/student_sidebar.dart';
import '../beranda/beranda_siswa_page.dart';
import '../beranda/sections/bottom_nav_bar_section.dart';
import '../materi/materi_siswa_page.dart';
import '../quiz/quiz_siswa_page.dart';
import '../profil/profil_siswa_page.dart';
import 'sections/game_filter_section.dart';
import 'sections/game_grid_section.dart';
import 'sections/game_header_section.dart';
import 'sections/game_leaderboard_section.dart';
import 'fishing/fishing_home_page.dart';
import 'werewolf/werewolf_lobby_page.dart';

/// Halaman Utama Game Edukasi Siswa.
/// Disusun secara modular menggunakan sub-sections terpisah,
/// dibungkus dengan komponen latar belakang reusable (StudentBackground),
/// dan menggunakan tombol CustomButton, serta thumbnail MateriThumbnail.
class GameSiswaPage extends StatefulWidget {
  final SiswaModel? siswa;

  const GameSiswaPage({super.key, this.siswa});

  @override
  State<GameSiswaPage> createState() => _GameSiswaPageState();
}

class _GameSiswaPageState extends State<GameSiswaPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedNavIndex = 3; // Tab Game aktif (Index 3)
  String _selectedCategory = 'Semua';

  final List<GameItemData> _allGames = const [
    GameItemData(
      id: 'tebak_serigala',
      title: 'Tebak Serigala',
      description: '9 Domba vs 1 Serigala! Tebak siapa serigala lewat ciri-ciri bahasa Inggris.',
      category: 'tebak-tebakan',
      themeColor: Color(0xFF6366F1), // Indigo Malam Misteri
      badgeColor: Color(0xFF818CF8),
      badgeText: '🎯 Tebak-Tebakan',
      customIcon: Icons.pets_rounded,
    ),
    GameItemData(
      id: 'word_fishing',
      title: 'Tangkap Ikan',
      description: 'Tangkap ikan lucu sambil belajar kosakata!',
      category: 'edukasi',
      themeColor: Color(0xFF0284C7), // Biru Samudra Cerah
      badgeColor: Color(0xFF38BDF8),
      badgeText: '🐠 Edukasi',
      imageAsset: 'assets/images/ikan/Ikan Badut Kotak yang Menggemaskan.png',
    ),
  ];

  List<GameItemData> get _filteredGames {
    if (_selectedCategory.toLowerCase() == 'semua') {
      return _allGames;
    }
    return _allGames.where((game) {
      return game.category.toLowerCase() == _selectedCategory.toLowerCase();
    }).toList();
  }

  void _navigateToNavIndex(int index) {
    if (index == _selectedNavIndex) return;

    if (index == 0) {
      // Ke Halaman Beranda
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (c, a, s) => BerandaSiswaPage(siswa: widget.siswa),
          transitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: (c, a, s, child) => FadeTransition(opacity: a, child: child),
        ),
      );
    } else if (index == 1) {
      // Ke Halaman Materi
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (c, a, s) => MateriSiswaPage(siswa: widget.siswa),
          transitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: (c, a, s, child) => FadeTransition(opacity: a, child: child),
        ),
      );
    } else if (index == 2) {
      // Ke Halaman Quiz
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (c, a, s) => QuizSiswaPage(siswa: widget.siswa),
          transitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: (c, a, s, child) => FadeTransition(opacity: a, child: child),
        ),
      );
    } else if (index == 4) {
      // Ke Halaman Profil (Tab ke-5 pada 5 menu navigasi)
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (c, a, s) => ProfilSiswaPage(siswa: widget.siswa),
          transitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: (c, a, s, child) => FadeTransition(opacity: a, child: child),
        ),
      );
    } else {
      setState(() {
        _selectedNavIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: StudentSidebar(
        siswa: widget.siswa,
        activeMenu: 'Games',
      ),
      backgroundColor: const Color(0xFFF7FAFE),
      bottomNavigationBar: BottomNavBarSection(
        currentIndex: _selectedNavIndex,
        onTap: _navigateToNavIndex,
      ),
      body: StudentBackground(
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                // 1. Header Section (Hamburger, "Halo, Game", Notifikasi)
                GameHeaderSection(
                  onMenuTap: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                  onNotificationTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Belum ada notifikasi game baru.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 36),

                // 2. Podium Leaderboard Top 3 Skor Siswa Dinamis
                GameLeaderboardSection(siswa: widget.siswa),

                const SizedBox(height: 24),

                // 3. Judul "Game" & Filter Chips Kategori
                GameFilterSection(
                  selectedCategory: _selectedCategory,
                  onCategoryChanged: (cat) {
                    setState(() {
                      _selectedCategory = cat;
                    });
                  },
                ),

                const SizedBox(height: 16),

                // 4. Grid Game Cards
                GameGridSection(
                  items: _filteredGames,
                  onPlayGame: (game) {
                    if (game.id == 'tebak_serigala') {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (c, a, s) => WerewolfLobbyPage(siswa: widget.siswa),
                          transitionDuration: const Duration(milliseconds: 350),
                          transitionsBuilder: (c, a, s, child) => FadeTransition(opacity: a, child: child),
                        ),
                      );
                    } else if (game.id == 'word_fishing') {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (c, a, s) => FishingHomePage(siswa: widget.siswa),
                          transitionDuration: const Duration(milliseconds: 350),
                          transitionsBuilder: (c, a, s, child) => FadeTransition(opacity: a, child: child),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Permainan ${game.title} segera hadir!'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                ),

                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

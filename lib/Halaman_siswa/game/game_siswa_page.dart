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
import 'puzzle/puzzle_home_page.dart';

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
      id: 'puzzle_master',
      title: 'Puzzle Master',
      description: 'Susun potongan, temukan keindahan!',
      category: 'vocabulary',
      themeColor: Color(0xFFF59E0B), // Kuning Amber
      badgeColor: Color(0xFFFCD34D),
      badgeText: '🧩 Puzzle',
      customIcon: Icons.extension_rounded,
    ),
    GameItemData(
      id: 'g2',
      title: 'Rangkai Kata',
      description: 'Permainan Merangkai Kata, Rangkai Kata dengan Benar',
      category: 'vocabulary',
      themeColor: Color(0xFFA855F7), // Ungu
      badgeColor: Color(0xFFC084FC),
      badgeText: 'Tt Kata',
    ),
    GameItemData(
      id: 'g3',
      title: 'Rangkai Kata',
      description: 'Permainan Merangkai Kata, Rangkai Kata dengan Benar',
      category: 'grammar',
      themeColor: Color(0xFF22C55E), // Hijau Zamrud
      badgeColor: Color(0xFF4ADE80),
      badgeText: 'Tt Kata',
    ),
    GameItemData(
      id: 'g4',
      title: 'Rangkai Kata',
      description: 'Permainan Merangkai Kata, Rangkai Kata dengan Benar',
      category: 'listening',
      themeColor: Color(0xFFEF4444), // Coral Red
      badgeColor: Color(0xFFF87171),
      badgeText: 'Tt Kata',
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
      // Ke Halaman Profil
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

                // 2. Podium Leaderboard Top 3 Skor Siswa
                const GameLeaderboardSection(),

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

                // 4. Grid Game Cards 2 Kolom
                GameGridSection(
                  items: _filteredGames,
                  onPlayGame: (game) {
                    if (game.id == 'puzzle_master') {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (c, a, s) => PuzzleHomePage(siswa: widget.siswa),
                          transitionDuration: const Duration(milliseconds: 350),
                          transitionsBuilder: (c, a, s, child) => FadeTransition(opacity: a, child: child),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Memulai permainan ${game.title}...'),
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

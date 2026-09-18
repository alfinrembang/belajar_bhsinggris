import 'package:flutter/material.dart';
import '../../../models/siswa_model.dart';
import '../../../widgets/student_background.dart';
import '../../../widgets/student_sidebar.dart';
import '../beranda/beranda_siswa_page.dart';
import '../beranda/sections/bottom_nav_bar_section.dart';
import '../materi/materi_siswa_page.dart';
import '../game/game_siswa_page.dart';
import '../profil/profil_siswa_page.dart';
import 'sections/quiz_header_section.dart';
import 'sections/quiz_join_room_section.dart';
import 'sections/quiz_list_section.dart';
import 'sections/quiz_tersedia_header_section.dart';

/// Halaman Utama Quiz Siswa.
/// Disusun secara modular menggunakan sub-sections terpisah,
/// dibungkus dengan komponen latar belakang reusable (StudentBackground),
/// dan menggunakan tombol CustomButton, serta thumbnail MateriThumbnail.
class QuizSiswaPage extends StatefulWidget {
  final SiswaModel? siswa;

  const QuizSiswaPage({super.key, this.siswa});

  @override
  State<QuizSiswaPage> createState() => _QuizSiswaPageState();
}

class _QuizSiswaPageState extends State<QuizSiswaPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedNavIndex = 2; // Tab Quiz aktif (Index 2)

  // Data daftar kuis yang tersedia sesuai desain
  final List<QuizItemData> _availableQuizzes = const [
    QuizItemData(
      id: 'q1',
      title: 'Job Interview & Work Etiquette',
      category: 'speaking',
      durasiMenit: 8,
      jumlahSoal: 10,
      xp: 60,
      customIcon: Icons.forum_rounded,
    ),
    QuizItemData(
      id: 'q2',
      title: 'Passive Voice in Technical Manuals',
      category: 'text',
      durasiMenit: 8,
      jumlahSoal: 6,
      xp: 40,
      customIcon: Icons.menu_book_rounded,
    ),
    QuizItemData(
      id: 'q3',
      title: 'Business Presentation Skills',
      category: 'vocabulary',
      durasiMenit: 10,
      jumlahSoal: 8,
      xp: 50,
      customIcon: Icons.translate_rounded,
    ),
    QuizItemData(
      id: 'q4',
      title: 'Grammar Mastery: Conditional Sentences',
      category: 'grammar',
      durasiMenit: 12,
      jumlahSoal: 10,
      xp: 65,
      customIcon: Icons.spellcheck_rounded,
    ),
  ];

  void _navigateToNavIndex(int index) {
    if (index == _selectedNavIndex) return;

    if (index == 0) {
      // Ke Halaman Beranda
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              BerandaSiswaPage(siswa: widget.siswa),
          transitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    } else if (index == 1) {
      // Ke Halaman Materi
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              MateriSiswaPage(siswa: widget.siswa),
          transitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    } else if (index == 3) {
      // Ke Halaman Game
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              GameSiswaPage(siswa: widget.siswa),
          transitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    } else if (index == 4) {
      // Ke Halaman Profil
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              ProfilSiswaPage(siswa: widget.siswa),
          transitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
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
        activeMenu: 'Latihan',
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

                // 1. Header Section (Hamburger, "Halo, Quiz", Notifikasi)
                QuizHeaderSection(
                  onMenuTap: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                  onNotificationTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Belum ada notifikasi baru untuk kuis.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 36),

                // 2. Hero Card "JOIN ROOM" dengan rakun_quiz.png & Tombol GO
                QuizJoinRoomSection(
                  onJoinRoom: (code) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Bergabung ke room: $code...'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 22),

                // 3. Section Header "Quiz Tersedia" & "Lihat Semua ->"
                QuizTersediaHeaderSection(
                  onLihatSemuaTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Menampilkan seluruh kuis tersedia.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),

                // 4. List Quiz Cards Interaktif
                QuizListSection(
                  items: _availableQuizzes,
                  onMulaiQuiz: (quiz) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Memulai kuis ${quiz.title}...'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
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

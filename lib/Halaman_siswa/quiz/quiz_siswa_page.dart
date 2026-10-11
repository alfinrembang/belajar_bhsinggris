import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/siswa_model.dart';
import '../../../services/api_service.dart';
import '../../../widgets/student_background.dart';
import '../../../widgets/student_sidebar.dart';
import '../beranda/beranda_siswa_page.dart';
import '../beranda/sections/bottom_nav_bar_section.dart';
import '../materi/materi_siswa_page.dart';
import '../game/game_siswa_page.dart';
import '../profil/profil_siswa_page.dart';
import '../pencapaian/pencapaian_siswa_page.dart';
import 'sections/quiz_header_section.dart';
import 'sections/quiz_join_room_section.dart';
import 'sections/quiz_list_section.dart';
import 'sections/quiz_tersedia_header_section.dart';
import 'isi_quiz/isi_quiz_page.dart';

/// Halaman Utama Quiz Siswa: Mengambil daftar paket kuis live secara dinamis
/// dari backend Laravel (Dashboard Guru), mendukung pencarian room via kode unik,
/// dan navigasi langsung ke sesi ujian interaktif.
class QuizSiswaPage extends StatefulWidget {
  final SiswaModel? siswa;

  const QuizSiswaPage({super.key, this.siswa});

  @override
  State<QuizSiswaPage> createState() => _QuizSiswaPageState();
}

class _QuizSiswaPageState extends State<QuizSiswaPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedNavIndex = 2; // Tab Quiz aktif (Index 2)

  bool _isLoading = true;
  String? _errorMessage;
  List<QuizItemData> _quizzes = [];

  @override
  void initState() {
    super.initState();
    _fetchQuizzes();
  }

  /// Mengambil daftar seluruh paket kuis dinamis dari server
  Future<void> _fetchQuizzes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final res = await ApiService.getDaftarQuiz(
        siswaId: widget.siswa?.id,
      );

      if (res['success'] == true) {
        final List<dynamic> rawList = res['data'] ?? [];
        final mapped = rawList.map((item) {
          final cat = item['kategori']?.toString() ?? 'General';
          return QuizItemData(
            id: item['id']?.toString() ?? '0',
            title: item['judul']?.toString() ?? 'Kuis Bahasa Inggris',
            category: cat,
            durasiMenit: int.tryParse(item['durasi_menit']?.toString() ?? '15') ?? 15,
            jumlahSoal: int.tryParse(item['jumlah_soal']?.toString() ?? '20') ?? 20,
            xp: int.tryParse(item['xp_reward']?.toString() ?? '60') ?? 60,
            kodeRoom: item['kode_room']?.toString(),
            isCompleted: item['is_completed'] == true,
            skorTerakhir: item['skor_terakhir'] != null
                ? int.tryParse(item['skor_terakhir'].toString())
                : null,
            customIcon: _getCategoryIcon(cat),
          );
        }).toList();

        if (mounted) {
          setState(() {
            _quizzes = mapped;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _quizzes = [];
            _errorMessage = res['message'] ?? 'Gagal memuat kuis dari server.';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _quizzes = [];
          _errorMessage = 'Tidak dapat terhubung ke server kuis. Silakan periksa koneksi Anda.';
          _isLoading = false;
        });
      }
    }
  }

  IconData _getCategoryIcon(String category) {
    final lower = category.toLowerCase();
    if (lower.contains('grammar')) return Icons.spellcheck_rounded;
    if (lower.contains('vocab')) return Icons.translate_rounded;
    if (lower.contains('reading')) return Icons.menu_book_rounded;
    if (lower.contains('speaking')) return Icons.forum_rounded;
    return Icons.quiz_rounded;
  }

  /// Bergabung ke room ujian melalui input kode room 6 digit
  Future<void> _handleJoinRoom(String code) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mencari room kuis dengan kode "$code"...'),
        duration: const Duration(milliseconds: 1500),
      ),
    );

    final res = await ApiService.joinQuizRoom(code);

    if (!mounted) return;

    if (res['success'] == true && res['data'] != null) {
      final q = res['data'];
      final quizItem = QuizItemData(
        id: q['id']?.toString() ?? '0',
        title: q['judul']?.toString() ?? 'Kuis Room $code',
        category: q['kategori']?.toString() ?? 'General',
        durasiMenit: int.tryParse(q['durasi_menit']?.toString() ?? '15') ?? 15,
        jumlahSoal: int.tryParse(q['jumlah_soal']?.toString() ?? '20') ?? 20,
        xp: int.tryParse(q['xp_reward']?.toString() ?? '60') ?? 60,
        kodeRoom: q['kode_room']?.toString() ?? code,
        customIcon: _getCategoryIcon(q['kategori']?.toString() ?? ''),
      );

      _bukaIsiQuiz(quizItem);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res['message'] ?? 'Room kuis tidak ditemukan atau kuis belum aktif!'),
          backgroundColor: const Color(0xFFEF4444),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _bukaIsiQuiz(QuizItemData quiz) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (c, a, s) => IsiQuizPage(
          siswa: widget.siswa,
          quizData: quiz,
          quizId: int.tryParse(quiz.id),
        ),
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (c, a, s, child) =>
            FadeTransition(opacity: a, child: child),
      ),
    ).then((_) {
      // Refresh daftar kuis setelah menyelesaikan kuis
      _fetchQuizzes();
    });
  }

  void _navigateToNavIndex(int index) {
    if (index == _selectedNavIndex) return;

    if (index == 0) {
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
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              PencapaianSiswaPage(siswa: widget.siswa),
          transitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    } else if (index == 5) {
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
          child: RefreshIndicator(
            onRefresh: _fetchQuizzes,
            color: const Color(0xFF1E6BFF),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
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

                  // 2. Hero Card "JOIN ROOM" dengan input kode room & Tombol GO
                  QuizJoinRoomSection(
                    onJoinRoom: _handleJoinRoom,
                  ),

                  const SizedBox(height: 22),

                  // 3. Section Header "Quiz Tersedia" & Tombol Refresh
                  QuizTersediaHeaderSection(
                    onLihatSemuaTap: _fetchQuizzes,
                  ),

                  const SizedBox(height: 12),

                  // 4. Daftar Kuis Dinamis
                  if (_isLoading)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 48),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(color: Color(0xFF1E6BFF)),
                          const SizedBox(height: 14),
                          Text(
                            'Memuat daftar kuis dari server...',
                            style: GoogleFonts.poppins(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (_errorMessage != null)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.wifi_off_rounded, size: 48, color: Color(0xFF94A3B8)),
                          const SizedBox(height: 10),
                          Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 14),
                          ElevatedButton.icon(
                            onPressed: _fetchQuizzes,
                            icon: const Icon(Icons.refresh_rounded, size: 16),
                            label: const Text('Coba Lagi'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E6BFF),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (_quizzes.isEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 42, horizontal: 20),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          const Icon(Icons.inbox_outlined, size: 48, color: Color(0xFF94A3B8)),
                          const SizedBox(height: 10),
                          Text(
                            'Belum ada paket kuis aktif saat ini',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Paket kuis yang dibuat guru akan otomatis muncul di sini.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 11.5,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    QuizListSection(
                      items: _quizzes,
                      onMulaiQuiz: _bukaIsiQuiz,
                    ),

                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

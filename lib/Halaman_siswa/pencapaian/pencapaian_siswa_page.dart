import 'package:flutter/material.dart';
import '../../models/siswa_model.dart';
import '../../widgets/student_background.dart';
import '../../widgets/student_sidebar.dart';
import '../beranda/sections/bottom_nav_bar_section.dart';
import '../beranda/beranda_siswa_page.dart';
import '../materi/materi_siswa_page.dart';
import '../quiz/quiz_siswa_page.dart';
import '../game/game_siswa_page.dart';
import '../profil/profil_siswa_page.dart';
import 'detail_pencapaian_page.dart';
import 'sections/pencapaian_header_section.dart';
import 'sections/pencapaian_summary_section.dart';
import 'sections/pencapaian_filter_section.dart';
import 'sections/pencapaian_list_section.dart';

/// Halaman Pencapaian / Achievement Siswa.
/// Menampilkan daftar lencana prestasi dengan filter dan progress keseluruhan.
/// Disusun secara modular menggunakan konsep sections/partials.
class PencapaianSiswaPage extends StatefulWidget {
  final SiswaModel? siswa;

  const PencapaianSiswaPage({super.key, this.siswa});

  @override
  State<PencapaianSiswaPage> createState() => _PencapaianSiswaPageState();
}

class _PencapaianSiswaPageState extends State<PencapaianSiswaPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _activeFilter = 'Semua';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: StudentSidebar(
        siswa: widget.siswa,
        activeMenu: 'Pencapaian',
      ),
      backgroundColor: const Color(0xFFF7FAFE),
      bottomNavigationBar: BottomNavBarSection(
        currentIndex: -1, // Tidak ada yang aktif di nav bawah (Pencapaian ada di sidebar)
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (c, a, s) => BerandaSiswaPage(siswa: widget.siswa),
                transitionDuration: const Duration(milliseconds: 400),
                transitionsBuilder: (c, a, s, child) =>
                    FadeTransition(opacity: a, child: child),
              ),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (c, a, s) => MateriSiswaPage(siswa: widget.siswa),
                transitionDuration: const Duration(milliseconds: 400),
                transitionsBuilder: (c, a, s, child) =>
                    FadeTransition(opacity: a, child: child),
              ),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (c, a, s) => QuizSiswaPage(siswa: widget.siswa),
                transitionDuration: const Duration(milliseconds: 400),
                transitionsBuilder: (c, a, s, child) =>
                    FadeTransition(opacity: a, child: child),
              ),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (c, a, s) => GameSiswaPage(siswa: widget.siswa),
                transitionDuration: const Duration(milliseconds: 400),
                transitionsBuilder: (c, a, s, child) =>
                    FadeTransition(opacity: a, child: child),
              ),
            );
          } else if (index == 4) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (c, a, s) => ProfilSiswaPage(siswa: widget.siswa),
                transitionDuration: const Duration(milliseconds: 400),
                transitionsBuilder: (c, a, s, child) =>
                    FadeTransition(opacity: a, child: child),
              ),
            );
          }
        },
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

                // 1. Header Section (Menu Hamburger + Judul Pencapaian)
                PencapaianHeaderSection(
                  onMenuTap: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                ),

                const SizedBox(height: 36),

                // 2. Ringkasan Lencana (Terbuka & Terkunci + Progress)
                const PencapaianSummarySection(
                  totalTerbuka: 5,
                  totalTerkunci: 8,
                  selesai: 5,
                  totalLencana: 13,
                ),

                const SizedBox(height: 18),

                // 3. Filter Tabs (Semua, Terbuka, Terkunci, Langka)
                PencapaianFilterSection(
                  activeFilter: _activeFilter,
                  onFilterChanged: (filter) {
                    setState(() {
                      _activeFilter = filter;
                    });
                  },
                ),

                const SizedBox(height: 16),

                // 4. Daftar Pencapaian / Lencana
                PencapaianListSection(
                  activeFilter: _activeFilter,
                  onItemTap: (item) {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (c, a, s) => DetailPencapaianPage(
                          title: item.title,
                          description: item.description,
                          info: item.info,
                          status: item.status,
                          icon: item.icon,
                          iconColor: item.iconColor,
                          iconBgColor: item.iconBgColor,
                        ),
                        transitionDuration: const Duration(milliseconds: 400),
                        transitionsBuilder: (c, a, s, child) =>
                            FadeTransition(opacity: a, child: child),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

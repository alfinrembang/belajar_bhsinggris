import 'package:flutter/material.dart';
import '../../models/pencapaian_model.dart';
import '../../models/siswa_model.dart';
import '../../services/api/pencapaian_service.dart';
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

/// Halaman Pencapaian / Achievement Siswa Dinamis.
/// Mengambil ringkasan lencana terbuka/terkunci serta seluruh daftar lencana
/// prestasi (streak 7 hari, 10.000 pts game, kuis, materi, listening, dll.)
/// secara real-time dari backend API.
class PencapaianSiswaPage extends StatefulWidget {
  final SiswaModel? siswa;

  const PencapaianSiswaPage({super.key, this.siswa});

  @override
  State<PencapaianSiswaPage> createState() => _PencapaianSiswaPageState();
}

class _PencapaianSiswaPageState extends State<PencapaianSiswaPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _activeFilter = 'Semua';

  bool _isLoading = true;
  PencapaianSummaryModel _summary = const PencapaianSummaryModel(
    totalTerbuka: 0,
    totalTerkunci: 0,
    selesai: 0,
    totalLencana: 0,
    persentase: 0,
  );
  List<PencapaianItemModel> _items = [];

  @override
  void initState() {
    super.initState();
    _loadPencapaian();
  }

  Future<void> _loadPencapaian() async {
    setState(() {
      _isLoading = true;
    });

    final res = await PencapaianService.getPencapaian(siswaId: widget.siswa?.id);

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (res['success'] == true) {
          _summary = res['summary'] as PencapaianSummaryModel;
          _items = res['items'] as List<PencapaianItemModel>;
        }
      });
    }
  }

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
        currentIndex: -1, // Halaman Pencapaian diakses melalui Akses Cepat / Sidebar
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (c, a, s) => BerandaSiswaPage(siswa: widget.siswa),
                transitionDuration: const Duration(milliseconds: 350),
                transitionsBuilder: (c, a, s, child) =>
                    FadeTransition(opacity: a, child: child),
              ),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (c, a, s) => MateriSiswaPage(siswa: widget.siswa),
                transitionDuration: const Duration(milliseconds: 350),
                transitionsBuilder: (c, a, s, child) =>
                    FadeTransition(opacity: a, child: child),
              ),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (c, a, s) => QuizSiswaPage(siswa: widget.siswa),
                transitionDuration: const Duration(milliseconds: 350),
                transitionsBuilder: (c, a, s, child) =>
                    FadeTransition(opacity: a, child: child),
              ),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (c, a, s) => GameSiswaPage(siswa: widget.siswa),
                transitionDuration: const Duration(milliseconds: 350),
                transitionsBuilder: (c, a, s, child) =>
                    FadeTransition(opacity: a, child: child),
              ),
            );
          } else if (index == 4) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (c, a, s) => ProfilSiswaPage(siswa: widget.siswa),
                transitionDuration: const Duration(milliseconds: 350),
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
          child: RefreshIndicator(
            onRefresh: _loadPencapaian,
            color: const Color(0xFF0066D6),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
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

                  // 2. Ringkasan Lencana Dinamis (Terbuka, Terkunci & Progress Keseluruhan)
                  PencapaianSummarySection(
                    totalTerbuka: _summary.totalTerbuka,
                    totalTerkunci: _summary.totalTerkunci,
                    selesai: _summary.selesai,
                    totalLencana: _summary.totalLencana,
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

                  // 4. Daftar Pencapaian / Lencana Dinamis
                  PencapaianListSection(
                    activeFilter: _activeFilter,
                    items: _items,
                    isLoading: _isLoading,
                    onRetry: _loadPencapaian,
                    onItemTap: (item) {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (c, a, s) => DetailPencapaianPage(
                            item: item,
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
      ),
    );
  }
}

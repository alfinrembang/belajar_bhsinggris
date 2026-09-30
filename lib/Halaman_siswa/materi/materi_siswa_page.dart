import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/siswa_model.dart';
import '../../../services/api_service.dart';
import '../../../widgets/student_background.dart';
import '../../../widgets/student_sidebar.dart';
import '../beranda/beranda_siswa_page.dart';
import '../quiz/quiz_siswa_page.dart';
import '../game/game_siswa_page.dart';
import '../profil/profil_siswa_page.dart';
import '../pencapaian/pencapaian_siswa_page.dart';
import '../beranda/sections/bottom_nav_bar_section.dart';
import 'sections/materi_filter_section.dart';
import 'sections/materi_header_section.dart';
import 'sections/materi_hero_section.dart';
import 'sections/materi_lanjutkan_section.dart';
import 'sections/materi_list_section.dart';
import 'sections/materi_search_section.dart';
import 'isi_materi/isi_materi_page.dart';

/// Halaman Materi Pembelajaran Siswa (100% Dinamis dari Backend Laravel).
/// Disusun secara modular menggunakan arsitektur sections/partials,
/// dibungkus dengan komponen latar belakang reusable (StudentBackground),
/// dan mengambil data materi live via ApiService.
class MateriSiswaPage extends StatefulWidget {
  final SiswaModel? siswa;

  const MateriSiswaPage({super.key, this.siswa});

  @override
  State<MateriSiswaPage> createState() => _MateriSiswaPageState();
}

class _MateriSiswaPageState extends State<MateriSiswaPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedNavIndex = 1; // Tab Materi aktif (Index 1)
  String _selectedCategory = 'Semua';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // State Dinamis dari Backend Laravel
  bool _isLoading = true;
  String? _errorMessage;
  List<MateriItemData> _materiList = [];

  @override
  void initState() {
    super.initState();
    _fetchMateri();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Mengambil daftar materi aktual dari API Laravel
  Future<void> _fetchMateri() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final res = await ApiService.getDaftarMateri(
      // Muat semua materi aktif agar siswa dapat melihat seluruh materi dari guru
      kelas: null,
      kategori: null,
      siswaId: widget.siswa?.id,
    );

    if (!mounted) return;

    if (res['success'] == true) {
      setState(() {
        _materiList = (res['data'] as List<MateriItemData>?) ?? [];
        _isLoading = false;
      });
    } else {
      setState(() {
        _errorMessage = res['message'] ?? 'Gagal memuat materi.';
        _isLoading = false;
      });
    }
  }

  // Filter daftar materi berdasarkan kategori & kata kunci pencarian
  List<MateriItemData> get _filteredMateri {
    return _materiList.where((item) {
      final isAll = _selectedCategory == 'Semua' || _selectedCategory == 'All';
      final matchCategory = isAll ||
          (item.category.toLowerCase() == _selectedCategory.toLowerCase()) ||
          (_selectedCategory.toLowerCase() == 'reading' && item.category.toLowerCase() == 'text') ||
          (_selectedCategory.toLowerCase() == 'conversation' && item.category.toLowerCase() == 'speaking');

      final matchSearch = _searchQuery.isEmpty ||
          item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.description.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchCategory && matchSearch;
    }).toList();
  }

  void _navigateToNavIndex(int index) {
    if (index == _selectedNavIndex) return;

    if (index == 0) {
      // Kembali ke Halaman Beranda
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              BerandaSiswaPage(siswa: widget.siswa),
          transitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    } else if (index == 2) {
      // Ke Halaman Quiz
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              QuizSiswaPage(siswa: widget.siswa),
          transitionDuration: const Duration(milliseconds: 400),
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
          transitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    } else if (index == 4) {
      // Ke Halaman Pencapaian
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
      // Ke Halaman Profil
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              ProfilSiswaPage(siswa: widget.siswa),
          transitionDuration: const Duration(milliseconds: 400),
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

  void _openMateri(MateriItemData item) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => IsiMateriPage(
          siswa: widget.siswa,
          materiId: int.tryParse(item.id),
          judulMateri: item.title,
        ),
        transitionDuration: const Duration(milliseconds: 350),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ).then((_) {
      // Refresh materi list saat kembali (jika ada update progres)
      _fetchMateri();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Menyiapkan data profil dinamis siswa
    final namaTampil = (widget.siswa != null && widget.siswa!.namaLengkap.isNotEmpty)
        ? widget.siswa!.namaLengkap
        : 'Siswa';

    final kelasTampil = (widget.siswa != null &&
            widget.siswa!.kelasLengkap != null &&
            widget.siswa!.kelasLengkap!.isNotEmpty)
        ? widget.siswa!.kelasLengkap!
        : (widget.siswa?.kelas ?? 'Kelas 10');

    final noAbsenTampil = (widget.siswa != null &&
            widget.siswa!.noAbsen != null &&
            widget.siswa!.noAbsen!.isNotEmpty)
        ? widget.siswa!.noAbsen!
        : ((widget.siswa != null &&
                widget.siswa!.noKelas != null &&
                widget.siswa!.noKelas!.isNotEmpty)
            ? widget.siswa!.noKelas!
            : '-');

    return Scaffold(
      key: _scaffoldKey,
      drawer: StudentSidebar(
        siswa: widget.siswa,
        activeMenu: 'Materi',
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
            onRefresh: _fetchMateri,
            color: const Color(0xFF0066D6),
            backgroundColor: Colors.white,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  // 1. Header Section (Menu Hamburger, Judul "Halo, Materi", Notifikasi)
                  MateriHeaderSection(
                    onMenuTap: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                    onNotificationTap: () {
                      // Notifikasi
                    },
                  ),

                  const SizedBox(height: 36),

                  // 2. Hero Card Section (Sapaan Siswa, Badge Kelas, & Rakun Menyapa)
                  MateriHeroSection(
                    nama: namaTampil,
                    kelas: kelasTampil,
                    noAbsen: noAbsenTampil,
                  ),

                  const SizedBox(height: 16),

                  // 3. Search Bar Section ("Cari materi text, grammar dll")
                  MateriSearchSection(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                      });
                    },
                  ),

                  const SizedBox(height: 18),

                  // 4. Lanjutkan Pembelajaran Section (Dinamis dari item materi pertama jika ada)
                  if (!_isLoading && _materiList.isNotEmpty) ...[
                    MateriLanjutkanSection(
                      title: _materiList.first.title,
                      category: _materiList.first.category,
                      description: _materiList.first.description,
                      onLanjutkanTap: () => _openMateri(_materiList.first),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // 5. Category Filter Section (Chips: Semua, Reading, Grammar, Conversation, Vocabulary)
                  MateriFilterSection(
                    selectedCategory: _selectedCategory,
                    onCategoryChanged: (cat) {
                      setState(() {
                        _selectedCategory = cat;
                      });
                    },
                  ),

                  const SizedBox(height: 18),

                  // 6. List Materi Section / Loading State / Error State
                  if (_isLoading)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(
                            color: Color(0xFF0066D6),
                            strokeWidth: 3,
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'Memuat materi pembelajaran...',
                            style: GoogleFonts.poppins(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (_errorMessage != null && _materiList.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFFEE2E2)),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.wifi_off_rounded,
                            color: Color(0xFFEF4444),
                            size: 36,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Gagal Memuat Materi',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 11.5,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 14),
                          ElevatedButton.icon(
                            onPressed: _fetchMateri,
                            icon: const Icon(Icons.refresh_rounded, size: 16),
                            label: const Text('Coba Lagi'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0066D6),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    MateriListSection(
                      items: _filteredMateri,
                      onMulaiBelajar: _openMateri,
                    ),

                  const SizedBox(height: 26),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

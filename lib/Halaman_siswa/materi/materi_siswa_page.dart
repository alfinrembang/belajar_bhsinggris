import 'package:flutter/material.dart';
import '../../../models/siswa_model.dart';
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

/// Halaman Materi Pembelajaran Siswa.
/// Disusun secara modular menggunakan arsitektur sections/partials,
/// dibungkus dengan komponen latar belakang reusable (StudentBackground),
/// dan menggunakan komponen MateriThumbnail terpusat yang konsisten dengan Beranda.
class MateriSiswaPage extends StatefulWidget {
  final SiswaModel? siswa;

  const MateriSiswaPage({super.key, this.siswa});

  @override
  State<MateriSiswaPage> createState() => _MateriSiswaPageState();
}

class _MateriSiswaPageState extends State<MateriSiswaPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedNavIndex = 1; // Tab Materi aktif (Index 1)
  String _selectedCategory = 'Text';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Data master materi pembelajaran (Desain dan warna diatur otomatis oleh MateriThumbnail & MateriBadge)
  final List<MateriItemData> _allMateri = const [
    MateriItemData(
      id: '1',
      category: 'Text',
      title: 'Descriptive Text',
      description: 'Materi tentang descriptive text dan lain sebagainya dan apapun',
      currentUnit: 1,
      totalUnit: 4,
      xp: 25,
    ),
    MateriItemData(
      id: '2',
      category: 'Text',
      title: 'Recount Text',
      description: 'Menceritakan kembali peristiwa masa lalu dengan urutan kronologis yang runtut',
      currentUnit: 2,
      totalUnit: 4,
      xp: 25,
    ),
    MateriItemData(
      id: '3',
      category: 'Text',
      title: 'Narrative Text',
      description: 'Menceritakan cerita imajinatif atau dongeng untuk menghibur pembaca',
      currentUnit: 0,
      totalUnit: 4,
      xp: 30,
    ),
    MateriItemData(
      id: '4',
      category: 'Grammar',
      title: 'Simple Present Tense',
      description: 'Penggunaan kalimat untuk menyatakan fakta, kebiasaan, dan kejadian umum',
      currentUnit: 1,
      totalUnit: 3,
      xp: 20,
    ),
    MateriItemData(
      id: '5',
      category: 'Grammar',
      title: 'Past Continuous Tense',
      description: 'Membahas kejadian yang sedang berlangsung di masa lampau pada titik waktu tertentu',
      currentUnit: 0,
      totalUnit: 3,
      xp: 20,
    ),
    MateriItemData(
      id: '6',
      category: 'Vocabulary',
      title: 'Daily Conversation Vocab',
      description: 'Kumpulan kosakata percakapan harian bahasa Inggris yang paling sering digunakan',
      currentUnit: 3,
      totalUnit: 5,
      xp: 35,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filter daftar materi berdasarkan kategori dan kata kunci pencarian
  List<MateriItemData> get _filteredMateri {
    return _allMateri.where((item) {
      final matchCategory = (_selectedCategory == 'All') ||
          (item.category.toLowerCase() == _selectedCategory.toLowerCase());
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

  @override
  Widget build(BuildContext context) {
    // Menyiapkan data profil dinamis siswa
    final namaTampil = (widget.siswa != null && widget.siswa!.namaLengkap.isNotEmpty)
        ? widget.siswa!.namaLengkap
        : 'Budi Pratama';

    final kelasTampil = (widget.siswa != null &&
            widget.siswa!.kelasLengkap != null &&
            widget.siswa!.kelasLengkap!.isNotEmpty)
        ? widget.siswa!.kelasLengkap!
        : 'XII RPL 1';

    final noAbsenTampil = (widget.siswa != null &&
            widget.siswa!.noAbsen != null &&
            widget.siswa!.noAbsen!.isNotEmpty)
        ? widget.siswa!.noAbsen!
        : ((widget.siswa != null &&
                widget.siswa!.noKelas != null &&
                widget.siswa!.noKelas!.isNotEmpty)
            ? widget.siswa!.noKelas!
            : '14');

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
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
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

                // 4. Lanjutkan Pembelajaran Section (Kartu Play & MateriThumbnail Reusable)
                MateriLanjutkanSection(
                  title: 'Descriptive Text',
                  category: 'Text',
                  description:
                      'Memahami apa itu Descriptive text dan mengetahui fungsi dan tujuannya',
                  onLanjutkanTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            IsiMateriPage(
                          siswa: widget.siswa,
                          judulMateri: 'Descriptive Text',
                        ),
                        transitionDuration: const Duration(milliseconds: 350),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(opacity: animation, child: child);
                        },
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // 5. Category Filter Section (Chips: Text, Grammar, Vocabulary, All)
                MateriFilterSection(
                  selectedCategory: _selectedCategory,
                  onCategoryChanged: (cat) {
                    setState(() {
                      _selectedCategory = cat;
                    });
                  },
                ),

                const SizedBox(height: 18),

                // 6. List Materi Section (Daftar Kartu Materi Menggunakan MateriThumbnail & MateriBadge)
                MateriListSection(
                  items: _filteredMateri,
                  onMulaiBelajar: (item) {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            IsiMateriPage(
                          siswa: widget.siswa,
                          judulMateri: item.title,
                        ),
                        transitionDuration: const Duration(milliseconds: 350),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(opacity: animation, child: child);
                        },
                      ),
                    );
                  },
                ),

                const SizedBox(height: 26),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

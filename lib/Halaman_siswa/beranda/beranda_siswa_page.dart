import '../../services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/siswa_model.dart';
import '../../widgets/student_background.dart';
import '../../widgets/student_sidebar.dart';
import 'sections/header_section.dart';
import 'sections/hero_card_section.dart';
import 'sections/progres_belajar_section.dart';
import 'sections/lanjutkan_belajar_section.dart';
import 'sections/akses_cepat_section.dart';
import 'sections/aktivitas_terbaru_section.dart';
import 'sections/bottom_nav_bar_section.dart';
import '../materi/materi_siswa_page.dart';
import '../quiz/quiz_siswa_page.dart';
import '../game/game_siswa_page.dart';
import '../profil/profil_siswa_page.dart';
import '../pencapaian/pencapaian_siswa_page.dart';
import '../listening/listening_daftar_page.dart';
import '../materi/isi_materi/isi_materi_page.dart';

/// Halaman Beranda Siswa (Dashboard Utama).
/// Disusun secara modular menggunakan konsep sections/partials
/// dan dibungkus dengan komponen latar belakang reusable (StudentBackground).
class BerandaSiswaPage extends StatefulWidget {
  final SiswaModel? siswa;

  const BerandaSiswaPage({super.key, this.siswa});

  @override
  State<BerandaSiswaPage> createState() => _BerandaSiswaPageState();
}

class _BerandaSiswaPageState extends State<BerandaSiswaPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedNavIndex = 0;

  // State Progres Belajar Dinamis dari Server
  int _persenProgres = 0;
  int _unitSelesai = 0;
  int _totalUnit = 4;
  int? _lanjutkanMateriId;
  String _judulLanjutkan = 'Descriptive Text: Describing Famous Places';
  String _subjudulLanjutkan = 'Materi belajar bahasa Inggris';

  // State Aktivitas Terbaru Dinamis
  List<AktivitasItem> _listAktivitas = [];
  bool _isLoadingAktivitas = true;

  @override
  void initState() {
    super.initState();
    _refreshAllData();
  }

  /// Mengambil seluruh data awal beranda (progres & aktivitas)
  Future<void> _refreshAllData() async {
    await Future.wait([
      _fetchProgres(),
      _fetchAktivitas(),
    ]);
  }

  /// Mengambil data progres belajar aktual siswa dari API Laravel
  Future<void> _fetchProgres() async {
    final res = await ApiService.getProgresMateri(
      siswaId: widget.siswa?.id,
    );

    if (!mounted) return;

    if (res['success'] == true && res['data'] != null) {
      final data = res['data'] as Map<String, dynamic>;
      setState(() {
        _persenProgres = (data['persentase'] is int)
            ? data['persentase'] as int
            : (int.tryParse(data['persentase']?.toString() ?? '') ?? 0);
        _unitSelesai = (data['materi_selesai'] is int)
            ? data['materi_selesai'] as int
            : (int.tryParse(data['materi_selesai']?.toString() ?? '') ?? 0);
        _totalUnit = (data['total_materi'] is int && (data['total_materi'] as int) > 0)
            ? data['total_materi'] as int
            : (int.tryParse(data['total_materi']?.toString() ?? '') ?? 4);

        final materiLanjut = data['materi_lanjutkan'] as Map<String, dynamic>? ??
            data['materi_terakhir'] as Map<String, dynamic>?;
        if (materiLanjut != null) {
          _lanjutkanMateriId = int.tryParse(materiLanjut['id']?.toString() ?? '');
          _judulLanjutkan = materiLanjut['judul']?.toString() ?? _judulLanjutkan;
          _subjudulLanjutkan = materiLanjut['deskripsi_singkat']?.toString() ??
              (_unitSelesai > 0 ? 'Lanjutkan modul berikutnya' : 'Mulai belajar bahasa Inggris');
        }
      });
    }
  }

  /// Mengambil 5 riwayat aktivitas terbaru siswa (Materi, Listening, Kuis, Game)
  Future<void> _fetchAktivitas() async {
    setState(() => _isLoadingAktivitas = true);

    final res = await ApiService.getAktivitasTerbaru(
      siswaId: widget.siswa?.id,
      limit: 5,
    );

    if (!mounted) return;

    if (res['success'] == true && res['data'] is List) {
      final rawList = res['data'] as List;
      setState(() {
        _listAktivitas = rawList
            .map((item) => AktivitasItem.fromJson(item as Map<String, dynamic>))
            .toList();
        _isLoadingAktivitas = false;
      });
    } else {
      setState(() {
        _listAktivitas = [];
        _isLoadingAktivitas = false;
      });
    }
  }

  /// Navigasi sesuai jenis aktivitas saat item ditekan
  void _handleAktivitasTap(AktivitasItem item) {
    final tipe = item.tipe?.toLowerCase();
    if (tipe == 'listening') {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              ListeningDaftarPage(siswa: widget.siswa),
          transitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ).then((_) => _refreshAllData());
    } else if (tipe == 'materi') {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              MateriSiswaPage(siswa: widget.siswa),
          transitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ).then((_) => _refreshAllData());
    } else if (tipe == 'quiz') {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              QuizSiswaPage(siswa: widget.siswa),
          transitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ).then((_) => _refreshAllData());
    } else if (tipe == 'game') {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              GameSiswaPage(siswa: widget.siswa),
          transitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ).then((_) => _refreshAllData());
    }
  }

  /// Menampilkan Bottom Sheet Riwayat Aktivitas Lengkap beserta Filter Kategori
  void _showModalSemuaAktivitas() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        String filterDipilih = 'all';
        List<AktivitasItem> modalItems = List.from(_listAktivitas);
        bool loadingModal = false;

        return StatefulBuilder(
          builder: (context, setModalState) {
            void loadFilter(String tipe) async {
              setModalState(() {
                filterDipilih = tipe;
                loadingModal = true;
              });

              final res = await ApiService.getAktivitasTerbaru(
                siswaId: widget.siswa?.id,
                limit: 50,
                type: tipe,
              );

              if (mounted) {
                setModalState(() {
                  loadingModal = false;
                  if (res['success'] == true && res['data'] is List) {
                    final rawList = res['data'] as List;
                    modalItems = rawList
                        .map((item) => AktivitasItem.fromJson(item as Map<String, dynamic>))
                        .toList();
                  } else {
                    modalItems = [];
                  }
                });
              }
            }

            return Container(
              height: MediaQuery.of(context).size.height * 0.78,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(26),
                  topRight: Radius.circular(26),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  // Indikator drag handle
                  Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFCBD5E1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Judul & Tombol Tutup
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          'Semua Aktivitas Belajar',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF1F5F9),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              size: 18,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Filter Chips Horisontal
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        _buildFilterChip('Semua', 'all', filterDipilih, loadFilter),
                        const SizedBox(width: 8),
                        _buildFilterChip('Listening', 'listening', filterDipilih, loadFilter),
                        const SizedBox(width: 8),
                        _buildFilterChip('Materi', 'materi', filterDipilih, loadFilter),
                        const SizedBox(width: 8),
                        _buildFilterChip('Kuis', 'quiz', filterDipilih, loadFilter),
                        const SizedBox(width: 8),
                        _buildFilterChip('Game', 'game', filterDipilih, loadFilter),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),
                  const Divider(height: 1, thickness: 0.8, color: Color(0xFFF1F5F9)),

                  // Isi List Riwayat Aktivitas
                  Expanded(
                    child: loadingModal
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF0075DE),
                            ),
                          )
                        : modalItems.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(28),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 52,
                                        height: 52,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFF1F5F9),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.history_rounded,
                                          size: 26,
                                          color: Color(0xFF94A3B8),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'Belum ada riwayat aktivitas',
                                        style: GoogleFonts.poppins(
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF334155),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Riwayat pengerjaan kamu untuk kategori ini akan tercatat di sini.',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          color: const Color(0xFF94A3B8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : ListView.separated(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                itemCount: modalItems.length,
                                separatorBuilder: (_, __) => const Divider(
                                  height: 16,
                                  thickness: 0.8,
                                  color: Color(0xFFF1F5F9),
                                ),
                                itemBuilder: (ctx, idx) {
                                  final item = modalItems[idx];
                                  final lowerStatus = item.status.toLowerCase();
                                  final isScore = lowerStatus.contains('skor');
                                  final isStar = lowerStatus.contains('★') || lowerStatus.contains('bintang');

                                  final badgeBg = isScore
                                      ? const Color(0xFFEDE9FE)
                                      : isStar
                                          ? const Color(0xFFFEF3C7)
                                          : const Color(0xFF86EFAC).withValues(alpha: 0.60);
                                  final badgeTextColor = isScore
                                      ? const Color(0xFF6D28D9)
                                      : isStar
                                          ? const Color(0xFFB45309)
                                          : const Color(0xFF15803D);

                                  return InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                      _handleAktivitasTap(item);
                                    },
                                    borderRadius: BorderRadius.circular(12),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 42,
                                            height: 42,
                                            decoration: BoxDecoration(
                                              color: item.iconBgColor,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              item.icon,
                                              color: item.iconColor,
                                              size: 21,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item.judul,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 12.5,
                                                    fontWeight: FontWeight.w700,
                                                    color: const Color(0xFF0F172A),
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Row(
                                                  children: [
                                                    Text(
                                                      item.tanggal,
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 10,
                                                        color: const Color(0xFF94A3B8),
                                                      ),
                                                    ),
                                                    if (item.waktuLalu != null && item.waktuLalu != '-') ...[
                                                      Text(
                                                        ' · ${item.waktuLalu}',
                                                        style: GoogleFonts.poppins(
                                                          fontSize: 9.5,
                                                          color: const Color(0xFF64748B),
                                                        ),
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 3.5,
                                            ),
                                            decoration: BoxDecoration(
                                              color: badgeBg,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              item.status,
                                              style: GoogleFonts.poppins(
                                                fontSize: 10.5,
                                                fontWeight: FontWeight.w600,
                                                color: badgeTextColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// Chip filter pilihan untuk modal riwayat aktivitas
  Widget _buildFilterChip(
    String label,
    String value,
    String selectedValue,
    Function(String) onSelected,
  ) {
    final isSelected = value == selectedValue;
    return InkWell(
      onTap: () => onSelected(value),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0075DE) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11.5,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Data dinamis siswa dari hasil login / registrasi
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
        activeMenu: 'Beranda',
      ),
      backgroundColor: const Color(0xFFF7FAFE),
      bottomNavigationBar: BottomNavBarSection(
        currentIndex: _selectedNavIndex,
        onTap: (index) {
          if (index == 1) {
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
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    QuizSiswaPage(siswa: widget.siswa),
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
                    ProfilSiswaPage(siswa: widget.siswa),
                transitionDuration: const Duration(milliseconds: 350),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
            );
          }
        },
      ),
      body: StudentBackground(
        child: SafeArea(
          bottom: false,
          child: RefreshIndicator(
            color: const Color(0xFF0075DE),
            onRefresh: _refreshAllData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  // 1. Header Section (Menu Hamburger, Judul Beranda, Notifikasi)
                  HeaderSection(
                    onMenuTap: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                    onNotificationTap: () {
                      // Aksi Buka Notifikasi
                    },
                  ),

                  const SizedBox(height: 36),

                  // 2. Hero Card Section (Sapaan Nama Siswa, Badge Kelas, & Rakun Menyapa)
                  HeroCardSection(
                    nama: namaTampil,
                    kelas: kelasTampil,
                    noAbsen: noAbsenTampil,
                  ),

                  const SizedBox(height: 18),

                  // 3. Progres Belajar Section (Dinamis Sesuai Materi Selesai)
                  ProgresBelajarSection(
                    persen: _persenProgres,
                    unitSelesai: _unitSelesai,
                    totalUnit: _totalUnit,
                    onDetailTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) =>
                              MateriSiswaPage(siswa: widget.siswa),
                          transitionDuration: const Duration(milliseconds: 400),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return FadeTransition(opacity: animation, child: child);
                          },
                        ),
                      ).then((_) => _refreshAllData());
                    },
                  ),

                  const SizedBox(height: 18),

                  // 4. Lanjutkan Belajar Section (Dinamis Sesuai Materi Rekomendasi/Terakhir)
                  LanjutkanBelajarSection(
                    judulMateri: _judulLanjutkan,
                    subjudul: _unitSelesai >= _totalUnit
                        ? 'Semua materi telah diselesaikan! 🎉'
                        : _subjudulLanjutkan,
                    persen: _persenProgres,
                    onLanjutkanTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) =>
                              IsiMateriPage(
                            siswa: widget.siswa,
                            materiId: _lanjutkanMateriId,
                            judulMateri: _judulLanjutkan,
                          ),
                          transitionDuration: const Duration(milliseconds: 350),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return FadeTransition(opacity: animation, child: child);
                          },
                        ),
                      ).then((_) => _refreshAllData());
                    },
                  ),

                  const SizedBox(height: 18),

                  // 5. Akses Cepat Section (Materi, Latihan, Listening, Games dengan Icon Cerah)
                  AksesCepatSection(
                    onMateriTap: () {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) =>
                              MateriSiswaPage(siswa: widget.siswa),
                          transitionDuration: const Duration(milliseconds: 400),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return FadeTransition(opacity: animation, child: child);
                          },
                        ),
                      );
                    },
                    onLatihanTap: () {
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
                    },
                    onListeningTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) =>
                              ListeningDaftarPage(siswa: widget.siswa),
                          transitionDuration: const Duration(milliseconds: 350),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return FadeTransition(opacity: animation, child: child);
                          },
                        ),
                      ).then((_) => _refreshAllData());
                    },
                    onGamesTap: () {
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
                    },
                    onPencapaianTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) =>
                              PencapaianSiswaPage(siswa: widget.siswa),
                          transitionDuration: const Duration(milliseconds: 350),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return FadeTransition(opacity: animation, child: child);
                          },
                        ),
                      ).then((_) => _refreshAllData());
                    },
                  ),

                  const SizedBox(height: 18),

                  // 7. Aktivitas Terbaru Section (Dinamis: Riwayat Materi, Listening, Kuis, Game)
                  AktivitasTerbaruSection(
                    listAktivitas: _listAktivitas,
                    isLoading: _isLoadingAktivitas,
                    onLihatSemuaTap: _showModalSemuaAktivitas,
                    onItemTap: _handleAktivitasTap,
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

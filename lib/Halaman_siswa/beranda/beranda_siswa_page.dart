import '../../services/api_service.dart';
import 'package:flutter/material.dart';
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
import '../listening/listening_siswa_page.dart';
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

  @override
  void initState() {
    super.initState();
    _fetchProgres();
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
                transitionDuration: const Duration(milliseconds: 400),
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
                transitionDuration: const Duration(milliseconds: 400),
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
                transitionDuration: const Duration(milliseconds: 400),
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
                    // Buka Halaman Materi Lengkap
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
                    ).then((_) => _fetchProgres());
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
                    ).then((_) => _fetchProgres());
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
                            ListeningSiswaPage(siswa: widget.siswa),
                        transitionDuration: const Duration(milliseconds: 350),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return FadeTransition(opacity: animation, child: child);
                        },
                      ),
                    );
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
                ),

                const SizedBox(height: 18),

                // 7. Aktivitas Terbaru Section (Riwayat Belajar & Badge Selesai)
                AktivitasTerbaruSection(
                  onLihatSemuaTap: () {
                    // Aksi Lihat Semua Aktivitas
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

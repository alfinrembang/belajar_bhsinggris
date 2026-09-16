import 'package:flutter/material.dart';
import '../../models/siswa_model.dart';
import '../../widgets/student_background.dart';
import 'sections/header_section.dart';
import 'sections/hero_card_section.dart';
import 'sections/progres_belajar_section.dart';
import 'sections/lanjutkan_belajar_section.dart';
import 'sections/akses_cepat_section.dart';
import 'sections/random_test_section.dart';
import 'sections/aktivitas_terbaru_section.dart';
import 'sections/bottom_nav_bar_section.dart';

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
  int _selectedNavIndex = 0;

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
      backgroundColor: const Color(0xFFF7FAFE),
      bottomNavigationBar: BottomNavBarSection(
        currentIndex: _selectedNavIndex,
        onTap: (index) {
          setState(() {
            _selectedNavIndex = index;
          });
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
                    // Aksi Buka Drawer / Menu
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

                // 3. Progres Belajar Section (70%, Unit 4 dari 6 Selesai)
                ProgresBelajarSection(
                  persen: 70,
                  unitSelesai: 4,
                  totalUnit: 6,
                  onDetailTap: () {
                    // Aksi Lihat Detail Progres
                  },
                ),

                const SizedBox(height: 18),

                // 4. Lanjutkan Belajar Section (Descriptive Text & Tombol Lanjutkan)
                LanjutkanBelajarSection(
                  judulMateri: 'Descriptive Text',
                  subjudul: 'Materi terakhir yang kamu pelajari',
                  persen: 70,
                  onLanjutkanTap: () {
                    // Aksi Lanjutkan Materi
                  },
                ),

                const SizedBox(height: 18),

                // 5. Akses Cepat Section (Materi, Latihan, Listening, Games dengan Icon Cerah)
                AksesCepatSection(
                  onMateriTap: () {
                    // Navigasi ke Materi
                  },
                  onLatihanTap: () {
                    // Navigasi ke Latihan
                  },
                  onListeningTap: () {
                    // Navigasi ke Listening
                  },
                  onGamesTap: () {
                    // Navigasi ke Games
                  },
                ),

                const SizedBox(height: 18),

                // 6. Random Test Section (Kartu Dadu & Tombol Mulai Test)
                RandomTestSection(
                  onMulaiTestTap: () {
                    // Aksi Mulai Random Test
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

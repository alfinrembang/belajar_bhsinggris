import 'package:flutter/material.dart';
import '../../../models/siswa_model.dart';
import '../../../widgets/student_background.dart';
import '../../../widgets/student_sidebar.dart';
import '../beranda/beranda_siswa_page.dart';
import '../beranda/sections/bottom_nav_bar_section.dart';
import '../materi/materi_siswa_page.dart';
import '../quiz/quiz_siswa_page.dart';
import '../game/game_siswa_page.dart';
import '../pencapaian/pencapaian_siswa_page.dart';
import 'sections/profil_header_section.dart';
import 'sections/profil_lencana_section.dart';
import 'sections/profil_settings_section.dart';
import 'sections/profil_user_card_section.dart';
import 'kelola_profil_page.dart';

/// Halaman Utama Profil Siswa.
/// Disusun secara modular menggunakan sub-sections terpisah,
/// dibungkus dengan komponen latar belakang reusable (StudentBackground),
/// menampilkan data profil dinamis dari akun siswa yang sedang aktif,
/// lencana prestasi, pengaturan akun (dengan CustomToggleSwitch), dan navigasi konsisten.
class ProfilSiswaPage extends StatefulWidget {
  final SiswaModel? siswa;

  const ProfilSiswaPage({super.key, this.siswa});

  @override
  State<ProfilSiswaPage> createState() => _ProfilSiswaPageState();
}

class _ProfilSiswaPageState extends State<ProfilSiswaPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedNavIndex = 5; // Tab Profil aktif (Index 4)
  late SiswaModel? _currentSiswa;

  @override
  void initState() {
    super.initState();
    _currentSiswa = widget.siswa;
  }

  void _navigateToNavIndex(int index) {
    if (index == _selectedNavIndex) return;

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (c, a, s) => BerandaSiswaPage(siswa: widget.siswa),
          transitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: (c, a, s, child) => FadeTransition(opacity: a, child: child),
        ),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (c, a, s) => MateriSiswaPage(siswa: widget.siswa),
          transitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: (c, a, s, child) => FadeTransition(opacity: a, child: child),
        ),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (c, a, s) => QuizSiswaPage(siswa: widget.siswa),
          transitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: (c, a, s, child) => FadeTransition(opacity: a, child: child),
        ),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (c, a, s) => GameSiswaPage(siswa: widget.siswa),
          transitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: (c, a, s, child) => FadeTransition(opacity: a, child: child),
        ),
      );
    } else if (index == 4) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (c, a, s) => PencapaianSiswaPage(siswa: widget.siswa),
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
        siswa: _currentSiswa,
        activeMenu: 'Profil',
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

                // 1. Header Section (Hamburger, "Halo, Profil", Notifikasi)
                ProfilHeaderSection(
                  onMenuTap: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                  onNotificationTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Belum ada notifikasi baru untuk profil.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 36),

                // 2. Kartu Profil Siswa Dinamis (Foto, Nama, NISN, No Absen, Kelas, Level)
                ProfilUserCardSection(
                  siswa: _currentSiswa,
                  onEditTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => KelolaProfilPage(siswa: _currentSiswa),
                      ),
                    );
                    if (result is SiswaModel) {
                      setState(() {
                        _currentSiswa = result;
                      });
                    }
                  },
                ),

                const SizedBox(height: 20),

                // 3. Lencana Prestasi (6 Badges)
                const ProfilLencanaSection(),

                const SizedBox(height: 20),

                // 4. Pengaturan Akun (Guru, Toggle Pengingat, Download PDF, Logout)
                ProfilSettingsSection(
                  siswa: _currentSiswa,
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

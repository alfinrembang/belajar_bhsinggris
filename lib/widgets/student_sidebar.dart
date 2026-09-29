import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Auth/login_siswa.dart';
import '../Halaman_siswa/beranda/beranda_siswa_page.dart';
import '../Halaman_siswa/materi/materi_siswa_page.dart';
import '../Halaman_siswa/quiz/quiz_siswa_page.dart';
import '../Halaman_siswa/game/game_siswa_page.dart';
import '../Halaman_siswa/profil/profil_siswa_page.dart';
import '../Halaman_siswa/pencapaian/pencapaian_siswa_page.dart';
import '../models/siswa_model.dart';
import '../services/api_service.dart';

/// Komponen Reusable Sidebar (Drawer) untuk seluruh Halaman Siswa.
/// Berisi Profil Mini Siswa, Menu Utama Bericon Konsisten, dan Tombol Logout.
class StudentSidebar extends StatelessWidget {
  final SiswaModel? siswa;
  final String activeMenu;

  const StudentSidebar({
    super.key,
    this.siswa,
    this.activeMenu = 'Beranda',
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    final namaTampil = (siswa != null && siswa!.namaLengkap.isNotEmpty)
        ? siswa!.namaLengkap
        : 'Budi Pratama';

    final kelasTampil = (siswa != null &&
            siswa!.kelasLengkap != null &&
            siswa!.kelasLengkap!.isNotEmpty)
        ? siswa!.kelasLengkap!
        : 'XII RPL 1';

    final noAbsenTampil = (siswa != null &&
            siswa!.noAbsen != null &&
            siswa!.noAbsen!.isNotEmpty)
        ? siswa!.noAbsen!
        : ((siswa != null &&
                siswa!.noKelas != null &&
                siswa!.noKelas!.isNotEmpty)
            ? siswa!.noKelas!
            : '14');

    return Drawer(
      width: (MediaQuery.of(context).size.width * 0.80).clamp(280.0, 320.0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // 1. Header Profil Siswa (Gradien Biru Elegan)
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, topPadding + 16, 16, 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0E4E93), // Biru Tua Elegan
                  Color(0xFF166CBD), // Biru Menengah
                  Color(0xFF1D87DC), // Biru Terang
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(28),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x290E4E93),
                  blurRadius: 14,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Baris Atas: Avatar & Tombol Close (X)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar / Lingkaran Profil Siswa
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.8),
                          width: 2.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          namaTampil.isNotEmpty
                              ? namaTampil.trim()[0].toUpperCase()
                              : 'S',
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF0066D6),
                          ),
                        ),
                      ),
                    ),

                    // Tombol Tutup Silang
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Nama Siswa
                Text(
                  namaTampil,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.2,
                  ),
                ),

                const SizedBox(height: 4),

                // Badge Kelas & Nomor Absen
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3.5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.school_rounded,
                        color: Colors.white,
                        size: 13,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '$kelasTampil • No. Absen $noAbsenTampil',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // 2. Daftar Menu Utama (Scrollable jika layar pendek)
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              child: Column(
                children: [
                  // 1. Menu Beranda
                  _buildMenuItem(
                    context: context,
                    title: 'Beranda',
                    icon: Icons.home_rounded,
                    iconColor: const Color(0xFF0284C7),
                    iconBgColor: const Color(0xFFE0F2FE),
                    isActive: activeMenu.toLowerCase() == 'beranda',
                    onTap: () {
                      Navigator.of(context).pop();
                      if (activeMenu.toLowerCase() != 'beranda') {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (c, a, s) =>
                                BerandaSiswaPage(siswa: siswa),
                            transitionDuration: const Duration(milliseconds: 350),
                            transitionsBuilder: (c, a, s, child) =>
                                FadeTransition(opacity: a, child: child),
                          ),
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 6),

                  // 2. Menu Materi
                  _buildMenuItem(
                    context: context,
                    title: 'Materi',
                    icon: Icons.auto_stories_rounded,
                    iconColor: const Color(0xFF0066D6),
                    iconBgColor: const Color(0xFFE8F1FB),
                    isActive: activeMenu.toLowerCase() == 'materi',
                    onTap: () {
                      Navigator.of(context).pop();
                      if (activeMenu.toLowerCase() != 'materi') {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (c, a, s) =>
                                MateriSiswaPage(siswa: siswa),
                            transitionDuration: const Duration(milliseconds: 350),
                            transitionsBuilder: (c, a, s, child) =>
                                FadeTransition(opacity: a, child: child),
                          ),
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 6),

                  // 3. Menu Latihan (Quiz / Exercise)
                  _buildMenuItem(
                    context: context,
                    title: 'Latihan',
                    icon: Icons.edit_note_rounded,
                    iconColor: const Color(0xFF059669),
                    iconBgColor: const Color(0xFFD1FAE5),
                    isActive: activeMenu.toLowerCase() == 'latihan',
                    onTap: () {
                      Navigator.of(context).pop();
                      if (activeMenu.toLowerCase() != 'latihan') {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (c, a, s) =>
                                QuizSiswaPage(siswa: siswa),
                            transitionDuration: const Duration(milliseconds: 350),
                            transitionsBuilder: (c, a, s, child) =>
                                FadeTransition(opacity: a, child: child),
                          ),
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 6),

                  // 4. Menu Listening
                  _buildMenuItem(
                    context: context,
                    title: 'Listening',
                    icon: Icons.headphones_rounded,
                    iconColor: const Color(0xFF7C3AED),
                    iconBgColor: const Color(0xFFEDE9FE),
                    isActive: activeMenu.toLowerCase() == 'listening',
                    onTap: () {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Menu Listening audio segera hadir!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 6),

                  // 5. Menu Games
                  _buildMenuItem(
                    context: context,
                    title: 'Games',
                    icon: Icons.sports_esports_rounded,
                    iconColor: const Color(0xFFD97706),
                    iconBgColor: const Color(0xFFFEF3C7),
                    isActive: activeMenu.toLowerCase() == 'games',
                    onTap: () {
                      Navigator.of(context).pop();
                      if (activeMenu.toLowerCase() != 'games') {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (c, a, s) =>
                                GameSiswaPage(siswa: siswa),
                            transitionDuration: const Duration(milliseconds: 350),
                            transitionsBuilder: (c, a, s, child) =>
                                FadeTransition(opacity: a, child: child),
                          ),
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 6),

                  // 6. Menu Pencapaian
                  _buildMenuItem(
                    context: context,
                    title: 'Pencapaian',
                    icon: Icons.emoji_events_rounded,
                    iconColor: const Color(0xFFCA8A04),
                    iconBgColor: const Color(0xFFFEF9C3),
                    isActive: activeMenu.toLowerCase() == 'pencapaian',
                    onTap: () {
                      Navigator.of(context).pop();
                      if (activeMenu.toLowerCase() != 'pencapaian') {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (c, a, s) =>
                                PencapaianSiswaPage(siswa: siswa),
                            transitionDuration: const Duration(milliseconds: 350),
                            transitionsBuilder: (c, a, s, child) =>
                                FadeTransition(opacity: a, child: child),
                          ),
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 6),

                  // 7. Menu Profil
                  _buildMenuItem(
                    context: context,
                    title: 'Profil',
                    icon: Icons.person_rounded,
                    iconColor: const Color(0xFF475569),
                    iconBgColor: const Color(0xFFF1F5F9),
                    isActive: activeMenu.toLowerCase() == 'profil',
                    onTap: () {
                      Navigator.of(context).pop();
                      if (activeMenu.toLowerCase() != 'profil') {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (c, a, s) =>
                                ProfilSiswaPage(siswa: siswa),
                            transitionDuration: const Duration(milliseconds: 350),
                            transitionsBuilder: (c, a, s, child) =>
                                FadeTransition(opacity: a, child: child),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          // 3. Garis Pembatas Halus
          const Divider(
            height: 1,
            color: Color(0xFFE2E8F0),
            indent: 18,
            endIndent: 18,
          ),

          // 4. Bagian Bawah: Tombol Logout & Info Versi
          Padding(
            padding: EdgeInsets.fromLTRB(14, 10, 14, bottomPadding + 12),
            child: Column(
              children: [
                _buildMenuItem(
                  context: context,
                  title: 'Keluar Akun',
                  icon: Icons.logout_rounded,
                  iconColor: const Color(0xFFEF4444),
                  iconBgColor: const Color(0xFFFEE2E2),
                  isDestructive: true,
                  onTap: () {
                    _showLogoutConfirmationDialog(context);
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  'v1.0.0 • Belajar Bahasa Inggris',
                  style: GoogleFonts.poppins(
                    fontSize: 10.5,
                    color: const Color(0xFF94A3B8),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Builder Item Menu Sidebar
  Widget _buildMenuItem({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required VoidCallback onTap,
    bool isActive = false,
    bool isDestructive = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9.5),
          decoration: BoxDecoration(
            color: isActive
                ? const Color(0xFF0066D6).withValues(alpha: 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: isActive
                ? Border.all(
                    color: const Color(0xFF0066D6).withValues(alpha: 0.2),
                    width: 1,
                  )
                : null,
          ),
          child: Row(
            children: [
              // Icon Box Squircle
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 20,
                  ),
                ),
              ),

              const SizedBox(width: 14),

              // Judul Menu
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    fontWeight: isActive || isDestructive
                        ? FontWeight.w700
                        : FontWeight.w600,
                    color: isDestructive
                        ? const Color(0xFFEF4444)
                        : (isActive
                            ? const Color(0xFF0066D6)
                            : const Color(0xFF1E293B)),
                  ),
                ),
              ),

              // Indikator Panah Kanan
              Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: isActive
                    ? const Color(0xFF0066D6)
                    : (isDestructive
                        ? const Color(0xFFEF4444).withValues(alpha: 0.5)
                        : const Color(0xFFCBD5E1)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Dialog Konfirmasi Logout yang Estetik
  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon Peringatan Logout
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFFECACA),
                      width: 1,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.logout_rounded,
                      color: Color(0xFFEF4444),
                      size: 28,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Judul Dialog
                Text(
                  'Keluar dari Akun?',
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),

                const SizedBox(height: 6),

                // Deskripsi Dialog
                Text(
                  'Kamu harus memasukkan kembali email/NISN dan kata sandi untuk masuk.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: const Color(0xFF64748B),
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 20),

                // Tombol Batal & Ya, Keluar
                Row(
                  children: [
                    // Tombol Batal
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          side: const BorderSide(
                            color: Color(0xFFCBD5E1),
                            width: 1.2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        child: Text(
                          'Batal',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    // Tombol Ya, Keluar
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          backgroundColor: const Color(0xFFEF4444),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () async {
                          Navigator.of(dialogContext).pop(); // Tutup dialog
                          Navigator.of(context).pop(); // Tutup drawer

                          // Panggil API logout jika token tersedia
                          if (siswa?.token != null && siswa!.token!.isNotEmpty) {
                            ApiService.logoutSiswa(token: siswa!.token!);
                          }

                          // Arahkan ke halaman login dan hapus seluruh tumpukan halaman
                          Navigator.pushAndRemoveUntil(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (c, a, s) => const LoginSiswaPage(),
                              transitionDuration: const Duration(milliseconds: 400),
                              transitionsBuilder: (c, a, s, child) =>
                                  FadeTransition(opacity: a, child: child),
                            ),
                            (route) => false,
                          );
                        },
                        child: Text(
                          'Ya, Keluar',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../services/api_service.dart';
import '../../../../Auth/login_siswa.dart';
import '../../../../models/siswa_model.dart';

/// Section Pengaturan Akun: Berisi opsi Guru Pembimbing (chat), Pengingat Belajar Harian
/// (menggunakan CustomToggleSwitch), Unduh Transkrip Nilai (PDF), dan Tombol Logout Elegan.
class ProfilSettingsSection extends StatefulWidget {
  final SiswaModel? siswa;

  const ProfilSettingsSection({super.key, this.siswa});

  @override
  State<ProfilSettingsSection> createState() => _ProfilSettingsSectionState();
}

class _ProfilSettingsSectionState extends State<ProfilSettingsSection> {
  bool _isReminderActive = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFF1F5F9),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Ikon Gear Pengaturan + Judul "Pengaturan Akun"
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F5F9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.settings_rounded,
                  color: Color(0xFF64748B),
                  size: 17,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Pengaturan Akun',
                style: GoogleFonts.poppins(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // 1. Opsi Guru Pembimbing Bahasa Inggris (Chat Icon)
          _buildOptionCard(
            icon: Icons.people_alt_rounded,
            iconColor: const Color(0xFF0066D6),
            iconBgColor: const Color(0xFFE8F1FB),
            title: 'Guru Pembimbing Bahasa Inggris',
            subtitle: 'Bu Ratna, S.Pd. (NIP: 198402...)',
            trailing: InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Menghubungi Bu Ratna, S.Pd...'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F1FB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 16,
                  color: Color(0xFF0066D6),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // 2. Opsi Pengingat Belajar Harian (Menggunakan CustomToggleSwitch Reusable)
          _buildOptionCard(
            icon: Icons.notifications_active_outlined,
            iconColor: const Color(0xFF0066D6),
            iconBgColor: const Color(0xFFE8F1FB),
            title: 'Pengingat Belajar Harian',
            subtitle: 'Setiap hari pukul 19:30 WIB',
            trailing: CustomToggleSwitch(
              value: _isReminderActive,
              onChanged: (val) {
                setState(() => _isReminderActive = val);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      val
                          ? 'Pengingat belajar diaktifkan (19:30 WIB).'
                          : 'Pengingat belajar dinonaktifkan.',
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          // 3. Opsi Unduh Transkrip Nilai Belajar (PDF Download Icon)
          _buildOptionCard(
            icon: Icons.description_outlined,
            iconColor: const Color(0xFF0066D6),
            iconBgColor: const Color(0xFFE8F1FB),
            title: 'Unduh Transkrip Nilai Belajar (PDF)',
            subtitle: 'Dokumen resmi persiapan magang/PKL',
            trailing: InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Mengunduh transkrip nilai PDF...'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.download_rounded,
                  size: 17,
                  color: Color(0xFF334155),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 4. Tombol Estetik "Keluar dari Akun"
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _showLogoutConfirmationDialog(context),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE4E6), // Soft Rose Pink
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.logout_rounded,
                      color: Color(0xFFDC2626),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Keluar dari Akun',
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFDC2626),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFF1F5F9),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Icon Kotak Kiri
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Center(
              child: Icon(icon, color: iconColor, size: 18),
            ),
          ),

          const SizedBox(width: 12),

          // Judul & Subjudul
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Trailing Action (Toggle Switch / Icon Button)
          trailing,
        ],
      ),
    );
  }

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
                Text(
                  'Keluar dari Akun?',
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 6),
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
                Row(
                  children: [
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
                          Navigator.of(dialogContext).pop();
                          if (widget.siswa?.token != null && widget.siswa!.token!.isNotEmpty) {
                            ApiService.logoutSiswa(token: widget.siswa!.token!);
                          }
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

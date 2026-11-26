import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../services/api_service.dart';
import '../../../../services/pengingat_service.dart';
import '../../../../Auth/login_siswa.dart';
import '../../../../models/siswa_model.dart';

/// Section Pengaturan Akun: Berisi opsi Guru Pembimbing (chat), Pengingat Belajar Harian
/// (menu modal bawah dengan pengaturan jam, terapkan, matikan, & uji alarm realtime),
/// Unduh Transkrip Nilai (PDF), dan Tombol Logout Elegan.
class ProfilSettingsSection extends StatefulWidget {
  final SiswaModel? siswa;

  const ProfilSettingsSection({super.key, this.siswa});

  @override
  State<ProfilSettingsSection> createState() => _ProfilSettingsSectionState();
}

class _ProfilSettingsSectionState extends State<ProfilSettingsSection> {
  @override
  void initState() {
    super.initState();
    PengingatService.instance.addListener(_onPengingatUpdated);
  }

  @override
  void dispose() {
    PengingatService.instance.removeListener(_onPengingatUpdated);
    super.dispose();
  }

  void _onPengingatUpdated() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final pengingat = PengingatService.instance;

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

          // 2. Opsi Pengingat Belajar Harian (Klik membuka Menu Kecil di Bawah)
          _buildOptionCard(
            icon: pengingat.isAktif ? Icons.alarm_on_rounded : Icons.alarm_off_rounded,
            iconColor: pengingat.isAktif ? const Color(0xFF0066D6) : const Color(0xFF94A3B8),
            iconBgColor: pengingat.isAktif ? const Color(0xFFE8F1FB) : const Color(0xFFF1F5F9),
            title: 'Pengingat Belajar Harian',
            subtitle: pengingat.isAktif
                ? 'Aktif: Setiap hari pukul ${pengingat.waktuTampil}'
                : 'Pengingat mati (Ketuk untuk atur)',
            onTap: () => _showAturPengingatModal(context),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                  decoration: BoxDecoration(
                    color: pengingat.isAktif
                        ? const Color(0xFFE0F2FE)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    pengingat.isAktif ? pengingat.waktuTampil : 'Mati',
                    style: GoogleFonts.poppins(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: pengingat.isAktif
                          ? const Color(0xFF0369A1)
                          : const Color(0xFF94A3B8),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: Color(0xFF94A3B8),
                ),
              ],
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
                  color: const Color(0xFFFFE4E6),
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

  /// Membangun kartu opsi pengaturan
  Widget _buildOptionCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
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
              trailing,
            ],
          ),
        ),
      ),
    );
  }

  /// Menu kecil di bawah (Bottom Sheet Modal) untuk Atur Jam, Terapkan, & Matikan
  void _showAturPengingatModal(BuildContext context) {
    final pengingat = PengingatService.instance;

    int selectedJam = pengingat.jam;
    int selectedMenit = pengingat.menit;
    bool isAktifState = pengingat.isAktif;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            final jamStr = selectedJam.toString().padLeft(2, '0');
            final menitStr = selectedMenit.toString().padLeft(2, '0');
            final jamTampil = '$jamStr:$menitStr WIB';

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Indikator Drag Handle
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

                  // Header: Ikon Alarm + Judul + Tombol Tutup
                  Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F2FE),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.notifications_active_rounded,
                          color: Color(0xFF0284C7),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Atur Pengingat Belajar',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                            Text(
                              'Alarm notifikasi belajar otomatis realtime',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.pop(bottomSheetContext),
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

                  const SizedBox(height: 18),

                  // Kotak Jam Terpilih & Tombol Pemilih Jam
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF0F9FF), Color(0xFFE0F2FE)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFBAE6FD),
                        width: 1.2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Jam Pengingat Terpilih',
                          style: GoogleFonts.poppins(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0284C7),
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Tampilan Jam Besar Digital
                        Text(
                          jamTampil,
                          style: GoogleFonts.poppins(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF0369A1),
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Tombol Buka TimePicker
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF0066D6),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(
                                color: Color(0xFFBAE6FD),
                                width: 1.2,
                              ),
                            ),
                          ),
                          icon: const Icon(Icons.access_time_filled_rounded, size: 17),
                          label: Text(
                            'Ubah Jam & Menit',
                            style: GoogleFonts.poppins(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          onPressed: () async {
                            final TimeOfDay? picked = await showTimePicker(
                              context: bottomSheetContext,
                              initialTime: TimeOfDay(
                                hour: selectedJam,
                                minute: selectedMenit,
                              ),
                              helpText: 'PILIH JAM PENGINGAT BELAJAR',
                              confirmText: 'PILIH',
                              cancelText: 'BATAL',
                              builder: (pickerCtx, child) {
                                return Theme(
                                  data: Theme.of(pickerCtx).copyWith(
                                    colorScheme: const ColorScheme.light(
                                      primary: Color(0xFF0066D6),
                                      onPrimary: Colors.white,
                                      onSurface: Color(0xFF0F172A),
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );

                            if (picked != null) {
                              setModalState(() {
                                selectedJam = picked.hour;
                                selectedMenit = picked.minute;
                                isAktifState = true;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Pilihan Jam Cepat (Preset Chips)
                  Text(
                    'Pilihan Waktu Populer:',
                    style: GoogleFonts.poppins(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildPresetChip('09:00 (Pagi)', 9, 0, selectedJam, selectedMenit, (j, m) {
                          setModalState(() {
                            selectedJam = j;
                            selectedMenit = m;
                            isAktifState = true;
                          });
                        }),
                        const SizedBox(width: 8),
                        _buildPresetChip('14:00 (Siang)', 14, 0, selectedJam, selectedMenit, (j, m) {
                          setModalState(() {
                            selectedJam = j;
                            selectedMenit = m;
                            isAktifState = true;
                          });
                        }),
                        const SizedBox(width: 8),
                        _buildPresetChip('19:30 (Malam)', 19, 30, selectedJam, selectedMenit, (j, m) {
                          setModalState(() {
                            selectedJam = j;
                            selectedMenit = m;
                            isAktifState = true;
                          });
                        }),
                        const SizedBox(width: 8),
                        _buildPresetChip('21:00 (Malam)', 21, 0, selectedJam, selectedMenit, (j, m) {
                          setModalState(() {
                            selectedJam = j;
                            selectedMenit = m;
                            isAktifState = true;
                          });
                        }),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Baris Tombol Aksi: "Terapkan" & "Matikan"
                  Row(
                    children: [
                      // Tombol Matikan
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: const BorderSide(
                              color: Color(0xFFFCA5A5),
                              width: 1.2,
                            ),
                            backgroundColor: const Color(0xFFFFF1F2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          icon: const Icon(
                            Icons.notifications_off_rounded,
                            size: 16,
                            color: Color(0xFFE11D48),
                          ),
                          label: Text(
                            'Matikan',
                            style: GoogleFonts.poppins(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFE11D48),
                            ),
                          ),
                          onPressed: () async {
                            await pengingat.matikanPengingat();
                            if (!mounted) return;
                            Navigator.pop(bottomSheetContext);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Pengingat belajar telah dimatikan.'),
                                backgroundColor: Color(0xFF475569),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(width: 10),

                      // Tombol Terapkan
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            backgroundColor: const Color(0xFF0066D6),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          icon: const Icon(
                            Icons.check_circle_rounded,
                            size: 17,
                            color: Colors.white,
                          ),
                          label: Text(
                            'Terapkan Jam Ini',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () async {
                            await pengingat.simpanPengingat(
                              aktif: true,
                              jam: selectedJam,
                              menit: selectedMenit,
                            );
                            if (!mounted) return;
                            Navigator.pop(bottomSheetContext);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Pengingat berhasil diatur untuk setiap hari pukul $jamTampil!',
                                ),
                                backgroundColor: const Color(0xFF0066D6),
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// Helper Chip Pilihan Jam Cepat
  Widget _buildPresetChip(
    String label,
    int h,
    int m,
    int currentH,
    int currentM,
    Function(int, int) onSelect,
  ) {
    final isSelected = currentH == h && currentM == m;
    return InkWell(
      onTap: () => onSelect(h, m),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0066D6) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF0066D6) : const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }

  /// Dialog Konfirmasi Keluar dari Akun
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
                          await ApiService.clearSession();
                          if (!context.mounted) return;
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

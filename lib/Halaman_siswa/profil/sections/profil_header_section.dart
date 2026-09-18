import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Section Header Profil Siswa: Menampilkan Menu Hamburger, Sapaan "Halo, Profil",
/// Subjudul inspiratif, dan Tombol Notifikasi dengan Badge Merah.
/// Ukuran dan proporsinya konsisten dengan Beranda, Materi, Quiz, dan Game.
class ProfilHeaderSection extends StatelessWidget {
  final VoidCallback onMenuTap;
  final VoidCallback? onNotificationTap;

  const ProfilHeaderSection({
    super.key,
    required this.onMenuTap,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 1. Tombol Hamburger Menu (3 Garis Putih Tebal)
        InkWell(
          onTap: onMenuTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMenuBar(26),
                const SizedBox(height: 5),
                _buildMenuBar(20),
                const SizedBox(height: 5),
                _buildMenuBar(26),
              ],
            ),
          ),
        ),

        const SizedBox(width: 14),

        // 2. Teks Informasi: "Halo, Profil" & Subjudul
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Halo,',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.95),
                  height: 1.1,
                ),
              ),
              Text(
                'Profil',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.3,
                  height: 1.2,
                ),
              ),
              Text(
                'Kelola Profil Agar Lebih Menarik',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.85),
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),

        // 3. Tombol Lonceng Notifikasi dengan Badge Merah
        InkWell(
          onTap: onNotificationTap ??
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Belum ada notifikasi baru untuk profil.'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.notifications_none_rounded,
                  color: Color(0xFF1E293B),
                  size: 24,
                ),
                Positioned(
                  top: 11,
                  right: 12,
                  child: Container(
                    width: 7.5,
                    height: 7.5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuBar(double width) {
    return Container(
      width: width,
      height: 3.6,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Section Akses Cepat: Menampilkan Grid 2x2 Menu Cepat (Materi, Latihan, Listening, Games)
/// dengan ikon berwarna cerah dan segar (bukan hitam) sesuai permintaan pengguna.
class AksesCepatSection extends StatelessWidget {
  final VoidCallback? onMateriTap;
  final VoidCallback? onLatihanTap;
  final VoidCallback? onListeningTap;
  final VoidCallback? onGamesTap;

  const AksesCepatSection({
    super.key,
    this.onMateriTap,
    this.onLatihanTap,
    this.onListeningTap,
    this.onGamesTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Judul Section
        Text(
          'Akses Cepat',
          style: GoogleFonts.poppins(
            fontSize: 14.5,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
          ),
        ),

        const SizedBox(height: 10),

        // Baris 1: Materi & Latihan
        Row(
          children: [
            Expanded(
              child: _buildAksesCard(
                judul: 'Materi',
                subjudul: 'Belajar materi\nBahasa Inggris',
                icon: Icons.menu_book_rounded,
                iconColor: const Color(0xFF0284C7), // Sky Blue Cerah
                iconBgColor: const Color(0xFFE0F2FE),
                onTap: onMateriTap,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildAksesCard(
                judul: 'Latihan',
                subjudul: 'Kerjakan latihan\nsoal',
                icon: Icons.edit_note_rounded,
                iconColor: const Color(0xFFEA580C), // Amber/Orange Hangat
                iconBgColor: const Color(0xFFFFEDD5),
                onTap: onLatihanTap,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // Baris 2: Listening & Games
        Row(
          children: [
            Expanded(
              child: _buildAksesCard(
                judul: 'Listening',
                subjudul: 'Latihan\nmendengarkan',
                icon: Icons.headphones_rounded,
                iconColor: const Color(0xFF7C3AED), // Ungu/Violet Elegan
                iconBgColor: const Color(0xFFEDE9FE),
                onTap: onListeningTap,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildAksesCard(
                judul: 'Games',
                subjudul: 'Mainkan game\nedukasi',
                icon: Icons.sports_esports_rounded,
                iconColor: const Color(0xFF059669), // Emerald Mint Segar
                iconBgColor: const Color(0xFFD1FAE5),
                onTap: onGamesTap,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAksesCard({
    required String judul,
    required String subjudul,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF5FF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFDBEAFE),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00386B).withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Ikon Berwarna Cerah dengan Latar Belakang Lingkaran Halus
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 20,
              ),
            ),

            const SizedBox(width: 8),

            // Teks Judul & Subjudul
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    judul,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subjudul,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF64748B),
                      height: 1.15,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 4),

            // Tombol Lingkaran Hitam dengan Panah Putih
            Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Color(0xFF0F172A),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chevron_right_rounded,
                color: Colors.white,
                size: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

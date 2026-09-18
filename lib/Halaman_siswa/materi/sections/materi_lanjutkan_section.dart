import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/materi_thumbnail.dart';

/// Section Lanjutkan Pembelajaran: Menampilkan Kartu Progres Materi Terakhir
/// dengan Tombol Aksi CustomButton & MateriThumbnail konsisten Beranda.
class MateriLanjutkanSection extends StatelessWidget {
  final String title;
  final String description;
  final String category;
  final VoidCallback? onLanjutkanTap;

  const MateriLanjutkanSection({
    super.key,
    this.title = 'Descriptive Text',
    this.description = 'Memahami apa itu Descriptive text dan mengetahui fungsi dan tujuannya',
    this.category = 'Text',
    this.onLanjutkanTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE5EDF7),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F3156).withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris Atas: Icon Play Gradien Biru & MateriThumbnail Reusable Konsisten
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF2CB8FE),
                      Color(0xFF0066D6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x330066D6),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),

              // Thumbnail Materi Menggunakan Komponen Reusable Konsisten
              MateriThumbnail(
                category: category,
                size: 46,
                borderRadius: BorderRadius.circular(14),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Judul Materi
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
              letterSpacing: -0.2,
            ),
          ),

          const SizedBox(height: 4),

          // Deskripsi Materi
          Text(
            description,
            style: GoogleFonts.poppins(
              fontSize: 12.5,
              fontWeight: FontWeight.normal,
              color: const Color(0xFF64748B),
              height: 1.4,
            ),
          ),

          const SizedBox(height: 16),

          // Tombol Reusable: Lanjutkan Pembelajaran (Warna Biru Konsisten dengan Beranda)
          CustomButton(
            text: 'Lanjutkan Pembelajaran',
            height: 44,
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
            borderRadius: BorderRadius.circular(14),
            icon: Icons.chevron_right_rounded,
            iconSize: 18,
            onTap: onLanjutkanTap,
          ),
        ],
      ),
    );
  }
}

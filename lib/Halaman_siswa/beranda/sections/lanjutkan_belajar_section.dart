import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/custom_button.dart';

/// Section Lanjutkan Belajar: Menampilkan Materi Terakhir yang Sedang Dipelajari
/// & Tombol Lanjutkan menggunakan CustomButton konsisten.
class LanjutkanBelajarSection extends StatelessWidget {
  final String judulMateri;
  final String subjudul;
  final int persen;
  final VoidCallback? onLanjutkanTap;

  const LanjutkanBelajarSection({
    super.key,
    this.judulMateri = 'Descriptive Text',
    this.subjudul = 'Materi terakhir yang kamu pelajari',
    this.persen = 70,
    this.onLanjutkanTap,
  });

  @override
  Widget build(BuildContext context) {
    final double progressValue = (persen / 100.0).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Judul Section
        Text(
          'Lanjutkan Belajar',
          style: GoogleFonts.poppins(
            fontSize: 14.5,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
          ),
        ),

        const SizedBox(height: 10),

        // Kartu Lanjutkan Belajar
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFEEF5FF),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFDBEAFE),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00386B).withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              // 1. Ikon Buku (Warna Biru Cerah Berenergi di dalam Lingkaran Soft)
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFD6E6FE),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFBFDBFE),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  color: Color(0xFF0066D6),
                  size: 22,
                ),
              ),

              const SizedBox(width: 12),

              // 2. Info Materi & Mini Progress Bar
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      judulMateri,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subjudul,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Progress Mini Bar + Persen
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: SizedBox(
                              height: 5,
                              child: LinearProgressIndicator(
                                value: progressValue,
                                backgroundColor: const Color(0xFFD0E1F9),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color(0xFF006D67),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '%',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0062D2),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // 3. Tombol "Lanjutkan >" menggunakan CustomButton
              CustomButton(
                text: 'Lanjutkan',
                height: 33,
                width: null, // Wrap content
                padding: const EdgeInsets.symmetric(horizontal: 12),
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                borderRadius: BorderRadius.circular(20),
                icon: Icons.chevron_right_rounded,
                iconSize: 15,
                onTap: onLanjutkanTap,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

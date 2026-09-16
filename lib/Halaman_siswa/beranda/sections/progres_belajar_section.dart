import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Section Progres Belajar: Menampilkan Statistik Unit Selesai dan Progress Bar.
class ProgresBelajarSection extends StatelessWidget {
  final int persen;
  final int unitSelesai;
  final int totalUnit;
  final VoidCallback? onDetailTap;

  const ProgresBelajarSection({
    super.key,
    this.persen = 70,
    this.unitSelesai = 4,
    this.totalUnit = 6,
    this.onDetailTap,
  });

  @override
  Widget build(BuildContext context) {
    final double progressValue = (persen / 100.0).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00386B).withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFF1F5F9),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Baris Judul & Tombol "Lihat detail"
          Row(
            children: [
              // Ikon Chart Analytics (Biru Cerah)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFF0066D6).withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.insert_chart_outlined_rounded,
                  color: Color(0xFF0066D6),
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Progres Belajar',
                style: GoogleFonts.poppins(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const Spacer(),

              // Tombol Pil "Lihat detail >"
              InkWell(
                onTap: onDetailTap,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Lihat detail',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0066D6),
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(
                        Icons.chevron_right_rounded,
                        size: 14,
                        color: Color(0xFF0066D6),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // 2. Angka Persentase Besar
          Text(
            '%',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0062D2),
              letterSpacing: -0.5,
              height: 1.1,
            ),
          ),

          const SizedBox(height: 4),

          // 3. Subteks: Unit 4 dari 6 Selesai
          Row(
            children: [
              const Icon(
                Icons.verified_outlined,
                size: 15,
                color: Color(0xFF0066D6),
              ),
              const SizedBox(width: 5),
              Text(
                'Unit  dari  Selesai',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // 4. Progress Bar Tebal & Halus
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 7,
              child: LinearProgressIndicator(
                value: progressValue,
                backgroundColor: const Color(0xFFE9F1FC),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF006D67), // Warna Teal Gelap Elegan sesuai referensi
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

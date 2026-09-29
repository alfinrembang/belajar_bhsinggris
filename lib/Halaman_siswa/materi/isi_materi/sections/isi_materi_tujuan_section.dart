import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Section Tujuan Pembelajaran: Kartu Melayang dengan Ikon Centang Biru
/// dan Daftar Poin Harapan Kompetensi Pembelajaran.
class IsiMateriTujuanSection extends StatelessWidget {
  final String judul;
  final String subjudul;
  final List<String> poinTujuan;

  const IsiMateriTujuanSection({
    super.key,
    this.judul = 'Tujuan Pembelajaran',
    this.subjudul = 'Setelah Mempelajari Materi Ini , Kamu Di Harapkan Dapat:',
    this.poinTujuan = const [
      'Memahami Pengertian Descriptiv Text',
      'Mengetahui Tujuan & Struktur Descriptive Text',
      'Mengenali Ciri Kebahasaan Descriptive Text',
      'Membuat Text Descriptive Sederhana',
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.3,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header: Ikon Centang Biru + Teks Tujuan Pembelajaran
          Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF0066D6), // Vibrant Electric Blue
                size: 24,
              ),
              const SizedBox(width: 10),
              Text(
                judul,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0066D6),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 2. Subjudul
          Text(
            subjudul,
            style: GoogleFonts.poppins(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0F172A),
            ),
          ),

          const SizedBox(height: 14),

          // 3. Daftar Checklist Poin Tujuan
          Column(
            children: poinTujuan.map((poin) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF0066D6),
                      size: 21,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        poin,
                        style: GoogleFonts.poppins(
                          fontSize: 12.2,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0F172A),
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

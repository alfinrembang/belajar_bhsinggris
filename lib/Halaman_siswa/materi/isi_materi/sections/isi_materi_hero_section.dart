import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Section Hero Banner: Kartu Soft Blue berisikan Judul Materi Besar,
/// Deskripsi Singkat, dan Ilustrasi Maskot Rakun (rakun_materi.png).
class IsiMateriHeroSection extends StatelessWidget {
  final String judul;
  final String deskripsi;
  final String assetRakun;

  const IsiMateriHeroSection({
    super.key,
    this.judul = 'Descriptive\nText',
    this.deskripsi =
        'jenis teks dalam bahasa Inggris yang bertujuan untuk menggambarkan atau menjelaskan suatu objek secara detail dan spesifik',
    this.assetRakun = 'assets/images/rakun_materi.png',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFDCEBFE), // Soft Blue Banner sesuai desain mockup
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.fromLTRB(18, 20, 10, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Sisi Kiri: Judul Besar & Deskripsi Teks
          Expanded(
            flex: 11,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  judul,
                  style: GoogleFonts.poppins(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1E3A8A), // Deep Blue Navy
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  deskripsi,
                  style: GoogleFonts.poppins(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF334155), // Dark Slate
                    height: 1.42,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Sisi Kanan: Maskot Rakun Bertas Ransel
          Expanded(
            flex: 9,
            child: Image.asset(
              assetRakun,
              height: 160,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(
                    Icons.school_rounded,
                    size: 80,
                    color: Color(0xFF0066D6),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

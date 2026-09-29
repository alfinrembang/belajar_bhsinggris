import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Section Banner Informasi Motivasi Bawah.
class PencapaianInfoBannerSection extends StatelessWidget {
  const PencapaianInfoBannerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF), // Soft Pastel Blue
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Kotak Ikon Bintang Biru
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFDBEAFE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.star_rounded,
              size: 20,
              color: Color(0xFF2563EB), // Royal Blue
            ),
          ),
          const SizedBox(width: 12),
          // Teks Motivasi
          Expanded(
            child: Text(
              'Selesaikan lebih banyak aktivitas untuk membuka lencana-lencana spesial lainnya!',
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1E3A8A),
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

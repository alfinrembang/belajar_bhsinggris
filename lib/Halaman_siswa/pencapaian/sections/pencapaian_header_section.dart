import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Header Section halaman Pencapaian.
/// Menampilkan tombol hamburger menu dan judul "Pencapaian".
class PencapaianHeaderSection extends StatelessWidget {
  final VoidCallback onMenuTap;

  const PencapaianHeaderSection({
    super.key,
    required this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Tombol Hamburger Menu (buka Sidebar)
        GestureDetector(
          onTap: onMenuTap,
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0E4E93).withValues(alpha: 0.10),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.menu_rounded,
                color: Color(0xFF0E4E93),
                size: 20,
              ),
            ),
          ),
        ),

        const SizedBox(width: 14),

        // Judul Halaman
        Text(
          'Pencapaian',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),

        const Spacer(),
      ],
    );
  }
}

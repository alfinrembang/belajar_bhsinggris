import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Section Header Isi Quiz: Tombol Tutup (X) & Judul Kuis.
class IsiQuizHeaderSection extends StatelessWidget {
  final String title;
  final VoidCallback onCloseTap;

  const IsiQuizHeaderSection({
    super.key,
    required this.title,
    required this.onCloseTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 1. Tombol (X) Bulat Elegan
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onCloseTap,
            borderRadius: BorderRadius.circular(22),
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: Color(0xFFEFF6FF), // Soft Pastel Blue
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.close_rounded,
                  color: Color(0xFF0F172A),
                  size: 22,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 14),

        // 2. Judul Kuis
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
              letterSpacing: -0.2,
            ),
          ),
        ),
      ],
    );
  }
}

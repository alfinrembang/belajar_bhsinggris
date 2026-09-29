import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Section Header Halaman Pencapaian: Tombol Kembali & Judul "Pencapaian".
class PencapaianHeaderSection extends StatelessWidget {
  final VoidCallback? onBackTap;

  const PencapaianHeaderSection({
    super.key,
    this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onBackTap ?? () => Navigator.of(context).pop(),
            borderRadius: BorderRadius.circular(12),
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.arrow_back_rounded,
                color: Color(0xFF0F172A),
                size: 24,
              ),
            ),
          ),
        ),
        Expanded(
          child: Text(
            'Pencapaian',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
            ),
          ),
        ),
        // Spacer penyeimbang tombol back
        const SizedBox(width: 40),
      ],
    );
  }
}

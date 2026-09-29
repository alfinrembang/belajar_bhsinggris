import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Section Tombol Aksi: [← Sebelumnya] dan [Lanjut →] / [Selesai ✓].
class IsiQuizActionButtonsSection extends StatelessWidget {
  final bool hasPrevious;
  final bool isLast;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const IsiQuizActionButtonsSection({
    super.key,
    required this.hasPrevious,
    required this.isLast,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 1. Tombol [← Sebelumnya]
        if (hasPrevious)
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPrevious,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFFCBD5E1),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0F172A).withValues(alpha: 0.02),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.arrow_back_rounded,
                      size: 16,
                      color: Color(0xFF0F172A),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Sebelumnya',
                      style: GoogleFonts.poppins(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          const SizedBox(width: 10),

        // 2. Tombol [Lanjut →] atau [Selesai ✓]
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onNext,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF0056D2), // Solid Electric Blue
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0056D2).withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isLast ? 'Selesai' : 'Lanjut',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    isLast ? Icons.check_rounded : Icons.arrow_forward_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

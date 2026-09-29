import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Section Bottom Nav: Tombol Sebelumnya & Tombol Lanjut.
class IsiMateriBottomNavSection extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback? onSebelumnyaTap;
  final VoidCallback? onLanjutTap;

  const IsiMateriBottomNavSection({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.onSebelumnyaTap,
    this.onLanjutTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool canGoBack = currentStep > 1;
    final bool isLastStep = currentStep >= totalSteps;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 1. Tombol Sebelumnya (Outline Putih Ber-border)
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: canGoBack ? onSebelumnyaTap : null,
              borderRadius: BorderRadius.circular(12),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: canGoBack ? 1.0 : 0.4,
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFCBD5E1),
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.arrow_back_rounded,
                        size: 18,
                        color: Color(0xFF0F172A),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Sebelumnya',
                        style: GoogleFonts.poppins(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 2. Tombol Lanjut (Biru Solid dengan Panah Kanan)
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onLanjutTap,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 22),
                decoration: BoxDecoration(
                  color: const Color(0xFF0066D6), // Vibrant Electric Blue
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0066D6).withValues(alpha: 0.28),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isLastStep ? 'Selesai' : 'Lanjut',
                      style: GoogleFonts.poppins(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      isLastStep ? Icons.check_rounded : Icons.arrow_forward_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

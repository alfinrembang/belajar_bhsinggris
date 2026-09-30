import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Section Stepper Progres: Menampilkan Teks "Materi X Dari Y" & Garis Tahapan Ber-node Dinamis.
/// Garis dan titik tahapan otomatis berwarna biru untuk tahap yang aktif/dilewati,
/// dan abu-abu lembut untuk tahap berikutnya.
class IsiMateriStepperSection extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const IsiMateriStepperSection({
    super.key,
    this.currentStep = 1,
    this.totalSteps = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Teks Label "Materi X Dari Y"
        RichText(
          text: TextSpan(
            style: GoogleFonts.poppins(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
            ),
            children: [
              const TextSpan(text: 'Materi '),
              TextSpan(
                text: '$currentStep',
                style: const TextStyle(
                  color: Color(0xFF0066D6), // Vibrant Electric Blue
                ),
              ),
              TextSpan(text: ' Dari $totalSteps'),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // 2. Bar Garis Progres Dinamis dengan Titik Node Lingkaran
        SizedBox(
          height: 14,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double progress = totalSteps > 1
                  ? ((currentStep - 1) / (totalSteps - 1)).clamp(0.0, 1.0)
                  : 1.0;

              return Stack(
                alignment: Alignment.center,
                children: [
                  // Garis Track Abu-abu Penuh (Tahap yang Belum Terlewati)
                  Container(
                    height: 4,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0), // Soft Inactive Gray
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // Garis Track Biru Dinamis (Tahap yang Sudah Terlewati / Aktif)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 320),
                      curve: Curves.easeInOut,
                      height: 4,
                      width: constraints.maxWidth * progress,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0066D6), // Vibrant Active Blue
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Titik-titik Node Sesuai Jumlah Langkah
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(totalSteps, (index) {
                      final stepIndex = index + 1;
                      final isPassedOrCurrent = stepIndex <= currentStep;
                      final isCurrent = stepIndex == currentStep;

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isPassedOrCurrent
                                ? const Color(0xFF0066D6) // Active Blue Border
                                : const Color(0xFFCBD5E1), // Inactive Gray Border
                            width: 2,
                          ),
                          boxShadow: isCurrent
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFF0066D6)
                                        .withValues(alpha: 0.35),
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  ),
                                ]
                              : null,
                        ),
                      );
                    }),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

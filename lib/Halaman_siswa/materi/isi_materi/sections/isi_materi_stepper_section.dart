import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Section Stepper Progres: Menampilkan Teks "Materi X Dari Y" & Garis Tahapan Ber-node.
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
        // 1. Teks Label "Materi 1 Dari 4"
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

        // 2. Bar Garis Progres dengan 4 Titik Node Lingkaran
        SizedBox(
          height: 14,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Garis Track Utama (Biru Halus & Modern)
              Container(
                height: 4,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF0066D6),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Titik-titik Node Sesuai Jumlah Langkah
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(totalSteps, (index) {
                  final stepIndex = index + 1;
                  final isActive = stepIndex <= currentStep;

                  return Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: isActive ? Colors.white : const Color(0xFFE2E8F0),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF0066D6),
                        width: 2,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Section Stepper Progres: Teks "Materi X/5" & Bar Segmen 5 Langkah.
class ListeningStepperSection extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const ListeningStepperSection({
    super.key,
    required this.currentStep,
    this.totalSteps = 5,
  });

  @override
  Widget build(BuildContext context) {
    final double progressFraction = currentStep / totalSteps;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Teks "Materi 1/5"
        Text(
          'Materi $currentStep/$totalSteps',
          style: GoogleFonts.poppins(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
          ),
        ),

        const SizedBox(height: 8),

        // Bar Progres Segmen Sesuai Mockup
        SizedBox(
          height: 12,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Garis Track Latar Belakang (Biru Muda Halus)
              Container(
                height: 5,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0EDFE),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),

              // Bar Terisi (Biru Solid)
              Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: progressFraction.clamp(0.05, 1.0),
                  child: Container(
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0056D2), // Electric Blue
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),

              // Titik-titik Node Segmen Langkah
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(totalSteps, (index) {
                  final stepIndex = index + 1;
                  final isPassedOrCurrent = stepIndex <= currentStep;

                  return Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: isPassedOrCurrent ? const Color(0xFF0056D2) : const Color(0xFFBFDBFE),
                      shape: BoxShape.circle,
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

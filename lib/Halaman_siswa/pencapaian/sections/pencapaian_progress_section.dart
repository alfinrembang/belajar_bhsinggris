import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Section Progress Keseluruhan: Pesan Motivasi, Rasio 5/13, & Linear Bar.
class PencapaianProgressSection extends StatelessWidget {
  final int totalTerbuka;
  final int totalLencana;

  const PencapaianProgressSection({
    super.key,
    this.totalTerbuka = 5,
    this.totalLencana = 13,
  });

  @override
  Widget build(BuildContext context) {
    final double ratio = totalLencana > 0 ? (totalTerbuka / totalLencana) : 0.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00386B).withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul Bar
          Text(
            'Progress Keseluruhan',
            style: GoogleFonts.poppins(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),

          // Pesan Motivasi & Rasio
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Kamu hebat! Terus pertahankan!',
                style: GoogleFonts.poppins(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF475569),
                ),
              ),
              Text(
                '$totalTerbuka / $totalLencana',
                style: GoogleFonts.poppins(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Linear Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 6.5,
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF0066D6), // Vibrant Electric Blue
              ),
            ),
          ),
        ],
      ),
    );
  }
}

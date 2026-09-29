import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Section Ringkasan Pencapaian.
/// Menampilkan jumlah lencana Terbuka & Terkunci serta progress keseluruhan.
class PencapaianSummarySection extends StatelessWidget {
  final int totalTerbuka;
  final int totalTerkunci;
  final int selesai;
  final int totalLencana;

  const PencapaianSummarySection({
    super.key,
    this.totalTerbuka = 5,
    this.totalTerkunci = 8,
    this.selesai = 5,
    this.totalLencana = 13,
  });

  @override
  Widget build(BuildContext context) {
    final progressPersen = totalLencana > 0 ? (selesai / totalLencana) : 0.0;

    return Column(
      children: [
        // Kartu Ringkasan Lencana (Terbuka & Terkunci)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0E4E93).withValues(alpha: 0.07),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Lencana Terbuka
              Expanded(
                child: Row(
                  children: [
                    // Icon Bintang / Trofi
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF9C3),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.emoji_events_rounded,
                          color: Color(0xFFCA8A04),
                          size: 26,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lencana Prestasi',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Text(
                              '$totalTerbuka',
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF0066D6),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Terbuka',
                              style: GoogleFonts.poppins(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF0066D6),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Divider Vertikal
              Container(
                width: 1,
                height: 40,
                color: const Color(0xFFE2E8F0),
              ),

              const SizedBox(width: 16),

              // Lencana Terkunci
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.lock_outline_rounded,
                        color: Color(0xFF94A3B8),
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '$totalTerkunci',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Terkunci',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Progress Keseluruhan
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0E4E93).withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progress Keseluruhan',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  Text(
                    '$selesai / $totalLencana',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0066D6),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Kamu hebat! Terus pertahankan!',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(height: 10),
              // Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: progressPersen,
                  minHeight: 8,
                  backgroundColor: const Color(0xFFE2E8F0),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF0066D6),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

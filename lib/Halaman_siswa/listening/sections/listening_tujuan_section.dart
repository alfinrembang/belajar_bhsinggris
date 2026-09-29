import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Section Kartu Tujuan Pembelajaran: Ikon Target Bulat Biru & 3 Poin Checklist.
class ListeningTujuanSection extends StatelessWidget {
  const ListeningTujuanSection({super.key});

  static const List<String> poinTujuan = [
    'Memahami informasi utama dari percakapan atau pengumuman',
    'Menangkap detail penting (nama, waktu, tempat)',
    'Menjawab pertanyaan sesuai audio',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header: Ikon Target Bulat Biru + Judul "Tujuan Pembelajaran"
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFF0056D2), // Blue Circle
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.track_changes_rounded,
                    color: Colors.white,
                    size: 19,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Tujuan Pembelajaran',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0056D2), // Electric Blue
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // 2. Daftar 3 Poin Checklist Biru Sesuai Mockup
          Column(
            children: poinTujuan.map((poin) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF0056D2), // Blue Checkmark
                      size: 21,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        poin,
                        style: GoogleFonts.poppins(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0F172A),
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

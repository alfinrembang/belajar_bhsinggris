import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Section Kartu Tujuan Pembelajaran: Ikon Target Bulat Biru & Poin Checklist.
class ListeningTujuanSection extends StatelessWidget {
  final List<String>? poinTujuan;
  final String? transkrip;

  const ListeningTujuanSection({
    super.key,
    this.poinTujuan,
    this.transkrip,
  });

  static const List<String> defaultPoinTujuan = [
    'Memahami informasi utama dari percakapan atau pengumuman',
    'Menangkap detail penting (nama, waktu, tempat)',
    'Menjawab pertanyaan sesuai audio percakapan',
  ];

  @override
  Widget build(BuildContext context) {
    final effectivePoin = (poinTujuan != null && poinTujuan!.isNotEmpty)
        ? poinTujuan!
        : defaultPoinTujuan;

    return Column(
      children: [
        // Kartu Tujuan Pembelajaran
        Container(
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
              // Header: Ikon Target Bulat Biru + Judul "Tujuan Pembelajaran"
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

              // Daftar Poin Checklist Biru
              Column(
                children: effectivePoin.map((poin) {
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
        ),

        // Kartu Transkrip Percakapan (Jika Ada)
        if (transkrip != null && transkrip!.trim().isNotEmpty) ...[
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFE2E8F0),
                width: 1.2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.article_outlined,
                      size: 20,
                      color: Color(0xFF0056D2),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Teks Transkrip Percakapan',
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0056D2),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Text(
                    transkrip!,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF334155),
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

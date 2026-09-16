import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Section Hero Card: Menampilkan Sapaan Pengguna, Kelas, No. Absen, & Karakter Rakun Menyapa.
class HeroCardSection extends StatelessWidget {
  final String nama;
  final String kelas;
  final String noAbsen;

  const HeroCardSection({
    super.key,
    this.nama = 'Budi Pratama',
    this.kelas = 'XII RPL 1',
    this.noAbsen = '14',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 108, // Dikembalikan ke ukuran asli (box tetap sleek & proporsional)
      decoration: BoxDecoration(
        color: const Color(0xFFDCEFFE),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00386B).withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(21),
        child: Stack(
          children: [
            // 1. Teks dan Badge di sisi kiri (Ruang lega sehingga emoji 👋 tidak terpotong)
            Positioned(
              top: 14,
              left: 16,
              right: 145,
              bottom: 14,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Halo, $nama! \u{1F44B}',
                    maxLines: 1,
                    overflow: TextOverflow.visible,
                    style: GoogleFonts.poppins(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Baris Badge: [🎓 XII RPL 1] • No. Absen 14 •
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        // Badge Kelas
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3.5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0075DE).withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFF0075DE).withValues(alpha: 0.25),
                              width: 0.8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.school_rounded,
                                color: Color(0xFF0066D6),
                                size: 13,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                kelas,
                                style: GoogleFonts.poppins(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF0066D6),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 6),
                        const Text(
                          '\u2022',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 6),

                        Text(
                          'No. Absen $noAbsen',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF475569),
                          ),
                        ),

                        const SizedBox(width: 6),
                        const Text(
                          '\u2022',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 2. Karakter Rakun Menyapa (Membentang penuh dari atas ke bawah kartu)
            Positioned(
              right: 0,
              bottom: 0,
              top: 2,
              child: Image.asset(
                'assets/images/rakun_hello.png',
                fit: BoxFit.contain,
                alignment: Alignment.bottomRight,
                errorBuilder: (context, error, stackTrace) => const SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Section Konten Tahap 3: Contoh Cerita / Teks Bacaan Pembelajaran.
/// Menampilkan teks contoh penerapan bacaan atau cerita pendek dengan gambar ilustrasi dari Dashboard Guru.
class IsiMateriStep3Section extends StatelessWidget {
  final String judul;
  final String contohTeks;
  final String? gambarUrl;

  const IsiMateriStep3Section({
    super.key,
    this.judul = 'Contoh Teks Bacaan',
    this.contohTeks =
        'Borobudur is a ninth-century Mahayana Buddhist temple located in Magelang Regency, Central Java, Indonesia. It is recognized as the world\'s largest Buddhist temple. The monument consists of nine stacked platforms, six square and three circular, topped by a central dome.',
    this.gambarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // =====================================================================
        // 1. HEADER SEKSI: Contoh Teks / Cerita Bacaan
        // =====================================================================
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Contoh Teks & Cerita',
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1D4ED8),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFBFDBFE)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.menu_book_rounded, size: 14, color: Color(0xFF0066D6)),
                  const SizedBox(width: 4),
                  Text(
                    'Reading Story',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0066D6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // =====================================================================
        // 2. GAMBAR ILUSTRASI CERITA (DARI DASHBOARD GURU)
        // =====================================================================
        if (gambarUrl != null && gambarUrl!.trim().isNotEmpty) ...[
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF0066D6).withValues(alpha: 0.18),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0066D6).withValues(alpha: 0.08),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18.5),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  gambarUrl!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: const Color(0xFFEFF6FF),
                      child: const Center(
                        child: SizedBox(
                          width: 26,
                          height: 26,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Color(0xFF0066D6),
                          ),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: const Color(0xFFF8FAFC),
                    padding: const EdgeInsets.all(16),
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.broken_image_rounded,
                            color: Color(0xFF94A3B8),
                            size: 36,
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Gagal memuat gambar ilustrasi',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
        ],

        // =====================================================================
        // 3. KARTU CONTOH TEKS / CERITA BACAAN
        // =====================================================================
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF0066D6),
              width: 1.8,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0066D6).withValues(alpha: 0.06),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Kotak Contoh
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                decoration: const BoxDecoration(
                  color: Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(17),
                    topRight: Radius.circular(17),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.auto_stories_rounded,
                      color: Color(0xFF0066D6),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Reading Passage: $judul',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0066D6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Paragraf Contoh Teks Cerita
              Padding(
                padding: const EdgeInsets.all(18),
                child: Text(
                  contohTeks,
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    fontWeight: FontWeight.normal,
                    color: const Color(0xFF1E293B),
                    height: 1.7,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // =====================================================================
        // 4. TIPS MEMBACA & MEMAHAMI
        // =====================================================================
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDF4),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFBBF7D0)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.lightbulb_outline_rounded,
                color: Color(0xFF16A34A),
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Petunjuk Belajar',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF15803D),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Pahami konteks cerita dan kosakata penting di atas sebelum melanjutkan ke latihan soal pemahaman (pilihan ganda & listening) di tahap berikutnya.',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: const Color(0xFF166534),
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),
      ],
    );
  }
}

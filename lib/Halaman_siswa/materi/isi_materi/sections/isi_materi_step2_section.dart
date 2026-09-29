import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Section Konten Tahap 2: Definisi Descriptive Text, Purpose (Tujuan), & Contoh Penggunaan.
/// Dibuat secara modular dan presisi sesuai desain mockup visual.
class IsiMateriStep2Section extends StatelessWidget {
  final String titleWhatIs;
  final String descWhatIs;
  final String tipsWhatIs;
  final String titlePurpose;
  final String descPurpose;
  final List<Map<String, dynamic>> contohList;

  const IsiMateriStep2Section({
    super.key,
    this.titleWhatIs = 'What is Descriptive Text?',
    this.descWhatIs =
        'jenis teks dalam bahasa Inggris yang bertujuan untuk menggambarkan atau menjelaskan suatu objek secara detail dan spesifik',
    this.tipsWhatIs =
        'jenis teks dalam bahasa Inggris yang bertujuan untuk menggambarkan atau menjelaskan suatu objek secara detail dan spesifik',
    this.titlePurpose = 'Purpose (Tujuan)',
    this.descPurpose =
        'menggambarkan, menjelaskan, atau mengungkapkan suatu objek secara spesifik dan terperinci agar pembaca dapat membayangkannya seolah–olah melihat atau mengalaminya secara langsung',
    this.contohList = const [
      {
        'color': Color(0xFF76BA79), // Soft Green
        'text': 'Describing a friends\nappereaance & personality',
      },
      {
        'color': Color(0xFFF0A13A), // Warm Amber
        'text': 'Describing a place\nThat you like',
      },
      {
        'color': Color(0xFF5B9BE6), // Sky Blue
        'text': 'Describing an animal\nThat you have',
      },
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // =====================================================================
        // 1. BAGIAN: What is Descriptive Text?
        // =====================================================================
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                titleWhatIs,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1D4ED8), // Vibrant Royal Blue
                ),
              ),
            ),
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF2FD), // Soft Blue Accent
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Card 1: Penjelasan Utama
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF4FB), // Light Grayish Blue
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            descWhatIs,
            style: GoogleFonts.poppins(
              fontSize: 11.8,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0F172A),
              height: 1.42,
            ),
          ),
        ),

        const SizedBox(height: 10),

        // Card 2: Tips Box
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F1FC), // Soft Pastel Blue
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tips',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1D4ED8),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                tipsWhatIs,
                style: GoogleFonts.poppins(
                  fontSize: 11.8,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF0F172A),
                  height: 1.42,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 22),

        // =====================================================================
        // 2. BAGIAN: Purpose (Tujuan)
        // =====================================================================
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                titlePurpose,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1D4ED8),
                ),
              ),
            ),
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFFDEEE9), // Soft Peach/Pink Accent
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Card Tujuan
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF2EF), // Soft Light Peach/Pink
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            descPurpose,
            style: GoogleFonts.poppins(
              fontSize: 11.8,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0F172A),
              height: 1.45,
            ),
          ),
        ),

        const SizedBox(height: 22),

        // =====================================================================
        // 3. BAGIAN: Contoh Penggunaan
        // =====================================================================
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFEBF3FC), // Soft Blue Container
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Contoh Penggunaan',
                style: GoogleFonts.poppins(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1D4ED8),
                ),
              ),
              const SizedBox(height: 14),

              // Daftar Kartu Contoh
              ...contohList.map((item) {
                final color = item['color'] as Color;
                final text = item['text'] as String;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0F172A).withValues(alpha: 0.02),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Kotak Warna Ikonik
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        const SizedBox(width: 14),
                        // Teks Contoh
                        Expanded(
                          child: Text(
                            text,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0F172A),
                              height: 1.25,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),

        const SizedBox(height: 16),
      ],
    );
  }
}

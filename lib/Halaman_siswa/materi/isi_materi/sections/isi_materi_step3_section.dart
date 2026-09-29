import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Section Konten Tahap 3: Generic Structure (Struktur Teks), Language Features
/// (Ciri Kebahasaan dengan Timeline Node), & Kotak Tips.
/// Dibuat secara modular, estetik, dan presisi sesuai desain mockup visual.
class IsiMateriStep3Section extends StatelessWidget {
  const IsiMateriStep3Section({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // =====================================================================
        // 1. BAGIAN: Generic Structure (Struktur)
        // =====================================================================
        Text(
          'Generic Structure\n(Struktur)',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1D4ED8), // Vibrant Royal Blue
            height: 1.25,
          ),
        ),

        const SizedBox(height: 14),

        // Card 1: Identification (Aksen Hijau Mint)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF2FAF4), // Soft Mint Green
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Badge & Judul
              Row(
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: const BoxDecoration(
                      color: Color(0xFF5DB075), // Fresh Green
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '1',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Identification',
                    style: GoogleFonts.poppins(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF48A462),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Penjelasan
              Text(
                'introduce the subject that will be described.',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E293B),
                  height: 1.35,
                ),
              ),

              const SizedBox(height: 10),

              // Label Contoh
              Text(
                'Example:',
                style: GoogleFonts.poppins(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF64748B),
                ),
              ),

              const SizedBox(height: 6),

              // Chip Contoh
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2F4E6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'My Cat, Milo, is very cute.',
                  style: GoogleFonts.poppins(
                    fontSize: 11.8,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Card 2: Description (Aksen Soft Blue)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F6FE), // Soft Blue
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Badge & Judul
              Row(
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1D4ED8), // Vibrant Royal Blue
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '2',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Description',
                    style: GoogleFonts.poppins(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1D4ED8),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Penjelasan
              Text(
                'introduce the subject that will be described.',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E293B),
                  height: 1.35,
                ),
              ),

              const SizedBox(height: 10),

              // Label Contoh
              Text(
                'Example:',
                style: GoogleFonts.poppins(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF64748B),
                ),
              ),

              const SizedBox(height: 6),

              // Chip Contoh
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0EEFD),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'My Cat, Milo, is very cute.',
                  style: GoogleFonts.poppins(
                    fontSize: 11.8,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // =====================================================================
        // 2. BAGIAN: Language Features (Ciri Kebahasaan)
        // =====================================================================
        Text(
          'Language Features\n(Ciri Kebahasaan)',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1D4ED8),
            height: 1.25,
          ),
        ),

        const SizedBox(height: 16),

        // Timeline Daftar Node Kebahasaan
        _buildTimelineItem(
          title: 'Using Simple Present Tense',
          subtitle: '(e.g. is, has, like, have)',
          isLast: false,
        ),
        _buildTimelineItem(
          title: 'Using Adjectives',
          subtitle: '(e.g. beautiful, big, friendly)',
          isLast: false,
        ),
        _buildTimelineItem(
          title: 'Using Specific Nonus',
          subtitle: '(e.g. cat, garden, teacher)',
          isLast: false,
        ),
        _buildTimelineItem(
          title: 'Using Linking Verbs',
          subtitle: '(e.g. is, are, has)',
          isLast: false,
        ),
        _buildTimelineItem(
          title: 'Using Action Verbs',
          subtitle: '(e.g. looks, comes, appears)',
          isLast: true,
        ),

        const SizedBox(height: 20),

        // =====================================================================
        // 3. BAGIAN: Tips Box (Kuning / Amber Hangat)
        // =====================================================================
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7ED), // Soft Amber Cream
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    '💡',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Tips',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFB45309), // Amber Brown
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Adjectives are very improtant in descriptive text because they describe more detail',
                style: GoogleFonts.poppins(
                  fontSize: 11.8,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF334155),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),
      ],
    );
  }

  /// Helper untuk merender item timeline node bergaris biru
  Widget _buildTimelineItem({
    required String title,
    required String subtitle,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kolom Garis & Dot Lingkaran
          SizedBox(
            width: 18,
            child: Column(
              children: [
                Container(
                  width: 9,
                  height: 9,
                  decoration: const BoxDecoration(
                    color: Color(0xFF0066D6), // Vibrant Electric Blue
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: const Color(0xFF93C5FD), // Soft Blue Track
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Kolom Teks Judul & Subtitle
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 12.2,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

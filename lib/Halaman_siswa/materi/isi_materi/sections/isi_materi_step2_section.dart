import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Section Konten Tahap 2: Definisi Teori, Purpose (Tujuan), & Contoh Penggunaan.
/// Didesain presisi 100% pixel-perfect sesuai mockup visual yang dikirim user.
class IsiMateriStep2Section extends StatelessWidget {
  final String? judul;
  final String? kategori;
  final String? penjelasan;
  final String? titleWhatIs;
  final String? descWhatIs;
  final String? tipsWhatIs;
  final String? titlePurpose;
  final String? descPurpose;
  final List<Map<String, dynamic>>? contohList;

  const IsiMateriStep2Section({
    super.key,
    this.judul,
    this.kategori,
    this.penjelasan,
    this.titleWhatIs,
    this.descWhatIs,
    this.tipsWhatIs,
    this.titlePurpose,
    this.descPurpose,
    this.contohList,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveJudul = (judul ?? 'Descriptive Text');
    final isGrammar = effectiveJudul.toLowerCase().contains('tense') ||
        (kategori?.toLowerCase() == 'grammar');
    final isConversation = effectiveJudul.toLowerCase().contains('opinion') ||
        (kategori?.toLowerCase() == 'conversation');
    final isVocabulary = effectiveJudul.toLowerCase().contains('vocab') ||
        (kategori?.toLowerCase() == 'vocabulary');

    String effectiveTitleWhatIs = titleWhatIs ?? 'What is Descriptive Text?';
    String effectiveDescWhatIs = descWhatIs ??
        'jenis teks dalam bahasa Inggris yang bertujuan untuk menggambarkan atau menjelaskan suatu objek secara detail dan spesifik';
    String effectiveTipsWhatIs = tipsWhatIs ??
        'jenis teks dalam bahasa Inggris yang bertujuan untuk menggambarkan atau menjelaskan suatu objek secara detail dan spesifik';
    String effectiveTitlePurpose = titlePurpose ?? 'Purpose (Tujuan)';
    String effectiveDescPurpose = descPurpose ??
        'menggambarkan, menjelaskan, atau mengungkapkan suatu objek secara spesifik dan terperinci agar pembaca dapat membayangkannya seolah-olah melihat atau mengalaminya secara langsung';

    List<Map<String, dynamic>> effectiveContohList = contohList ?? const [
      {
        'color': Color(0xFF70B974), // Soft Green
        'text': 'Describing a friends\nappereaance & personality',
      },
      {
        'color': Color(0xFFECA038), // Warm Amber
        'text': 'Describing a place\nThat you like',
      },
      {
        'color': Color(0xFF5396E3), // Sky Blue
        'text': 'Describing an animal\nThat you have',
      },
    ];

    if (isGrammar) {
      effectiveTitleWhatIs = titleWhatIs ?? 'What is Present Tenses?';
      effectiveDescWhatIs = descWhatIs ??
          'Tata bahasa waktu dalam bahasa Inggris untuk menyatakan rutinitas harian, kebenaran umum, serta aksi yang sedang berlangsung saat ini.';
      effectiveTipsWhatIs = tipsWhatIs ??
          'Gunakan Simple Present (Verb 1 s/es) untuk rutinitas, dan to be + Verb-ing untuk aksi yang sedang berlangsung.';
      effectiveDescPurpose = descPurpose ??
          'Membedakan secara tepat kapan suatu aktivitas merupakan kebiasaan rutin tetap atau peristiwa yang sedang terjadi sekarang.';
      effectiveContohList = contohList ?? const [
        {
          'color': Color(0xFF70B974),
          'text': 'Expressing daily habits\n& morning routines',
        },
        {
          'color': Color(0xFFECA038),
          'text': 'Stating scientific facts\n& general truths',
        },
        {
          'color': Color(0xFF5396E3),
          'text': 'Describing current actions\nhappening right now',
        },
      ];
    } else if (isConversation) {
      effectiveTitleWhatIs = titleWhatIs ?? 'What is Giving Opinions?';
      effectiveDescWhatIs = descWhatIs ??
          'Keterampilan berbicara bahasa Inggris untuk menyampaikan sudut pandang pribadi serta menanggapi gagasan orang lain secara santun.';
      effectiveTipsWhatIs = tipsWhatIs ??
          'Awali dengan frasa \'In my opinion\' dan gunakan frasa santun seperti \'I see your point, but...\' untuk penolakan yang profesional.';
      effectiveDescPurpose = descPurpose ??
          'Membangun komunikasi dua arah yang interaktif, menghargai perspektif rekan diskusi, dan melatih diplomasi percakapan.';
      effectiveContohList = contohList ?? const [
        {
          'color': Color(0xFF70B974),
          'text': 'Sharing personal views\nin group discussions',
        },
        {
          'color': Color(0xFFECA038),
          'text': 'Agreeing politely\nwith team ideas',
        },
        {
          'color': Color(0xFF5396E3),
          'text': 'Expressing disagreement\nin a respectful way',
        },
      ];
    } else if (isVocabulary) {
      effectiveTitleWhatIs = titleWhatIs ?? 'What is Career Vocabulary?';
      effectiveDescWhatIs = descWhatIs ??
          'Kumpulan kosakata dan istilah kunci dalam dunia profesional, komunikasi perkantoran, dan keterampilan karier abad ke-21.';
      effectiveTipsWhatIs = tipsWhatIs ??
          'Pelajari kosakata dalam bentuk kolokasi profesional seperti \'meet a deadline\' dan \'constructive feedback\'.';
      effectiveDescPurpose = descPurpose ??
          'Mempersiapkan siswa agar percaya diri saat wawancara kerja, kolaborasi tim profesional, dan presentasi proyek global.';
      effectiveContohList = contohList ?? const [
        {
          'color': Color(0xFF70B974),
          'text': 'Collaboration & teamwork\nin project meetings',
        },
        {
          'color': Color(0xFFECA038),
          'text': 'Problem-solving & initiative\nat the workplace',
        },
        {
          'color': Color(0xFF5396E3),
          'text': 'Managing strict deadlines\n& work efficiency',
        },
      ];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // =====================================================================
        // 1. BAGIAN: What is ...?
        // =====================================================================
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                effectiveTitleWhatIs,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1D4ED8), // Vibrant Royal Blue
                ),
              ),
            ),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF5FC), // Soft Blue Accent Squircle
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Card 1: Penjelasan Utama (Grey-Blue)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF4FB), // Light Grayish Blue
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            effectiveDescWhatIs,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0F172A),
              height: 1.45,
            ),
          ),
        ),

        const SizedBox(height: 10),

        // Card 2: Tips Box (Soft Blue)
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
                effectiveTipsWhatIs,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF0F172A),
                  height: 1.45,
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
                effectiveTitlePurpose,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1D4ED8),
                ),
              ),
            ),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFFDEEE9), // Soft Peach/Pink Accent Squircle
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Card 3: Tujuan Box (Soft Peach/Pink)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF2EF), // Soft Light Peach/Pink
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            effectiveDescPurpose,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0F172A),
              height: 1.45,
            ),
          ),
        ),

        const SizedBox(height: 22),

        // =====================================================================
        // 3. BAGIAN: Contoh Penggunaan (Container Biru Muda dengan 3 Kartu Berwarna)
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

              // Daftar 3 Kartu Contoh Berwarna
              ...effectiveContohList.map((item) {
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
                        // Kotak Warna Ikonik Sesuai Mockup (Green / Amber / Blue)
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

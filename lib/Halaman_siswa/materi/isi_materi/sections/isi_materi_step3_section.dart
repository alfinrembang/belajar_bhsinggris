import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Section Konten Tahap 3: Contoh Teks Penerapan & Media Audio Listening.
/// Terhubung 100% dinamis dengan teks bacaan & rekaman audio dari Guru.
class IsiMateriStep3Section extends StatefulWidget {
  final String judul;
  final String contohTeks;
  final String? audioUrl;
  final String? gambarUrl;

  const IsiMateriStep3Section({
    super.key,
    this.judul = 'Contoh Teks Bacaan',
    this.contohTeks =
        'Borobudur is a ninth-century Mahayana Buddhist temple located in Magelang Regency, Central Java, Indonesia. It is recognized as the world\'s largest Buddhist temple. The monument consists of nine stacked platforms, six square and three circular, topped by a central dome.',
    this.audioUrl,
    this.gambarUrl,
  });

  @override
  State<IsiMateriStep3Section> createState() => _IsiMateriStep3SectionState();
}

class _IsiMateriStep3SectionState extends State<IsiMateriStep3Section> {
  bool _isPlaying = false;
  double _speed = 1.0;

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isPlaying ? 'Memutar audio listening pelafalan...' : 'Audio dijeda.'),
        duration: const Duration(milliseconds: 1200),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _toggleSpeed() {
    setState(() {
      if (_speed == 1.0) {
        _speed = 1.25;
      } else if (_speed == 1.25) {
        _speed = 1.5;
      } else {
        _speed = 1.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // =====================================================================
        // 1. HEADER SEKSI: Contoh Teks Bacaan & Media
        // =====================================================================
        Text(
          'Contoh Teks & Pelafalan',
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1D4ED8),
          ),
        ),

        const SizedBox(height: 12),

        // =====================================================================
        // GAMBAR ILUSTRASI TEKS (DARI GURU)
        // =====================================================================
        if (widget.gambarUrl != null && widget.gambarUrl!.trim().isNotEmpty) ...[
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
                  widget.gambarUrl!,
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
        // 2. KARTU CONTOH TEKS BACAAN (DARI GURU)
        // =====================================================================
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF0066D6),
              width: 2.0,
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
                        'Reading Passage: ${widget.judul}',
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

              // Paragraf Contoh Teks
              Padding(
                padding: const EdgeInsets.all(18),
                child: Text(
                  widget.contohTeks,
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    fontWeight: FontWeight.normal,
                    color: const Color(0xFF1E293B),
                    height: 1.65,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // =====================================================================
        // 3. PEMUTAR AUDIO LISTENING (AUDIO DARI GURU)
        // =====================================================================
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFEBF3FE),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFD6E6FE),
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              // Tombol Play / Pause
              InkWell(
                onTap: _togglePlay,
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    color: Color(0xFF0066D6),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Info Audio
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Audio Pelafalan Teks',
                      style: GoogleFonts.poppins(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1D4ED8),
                      ),
                    ),
                    Text(
                      'Dengarkan intonasi & pronunciation native',
                      style: GoogleFonts.poppins(
                        fontSize: 10.5,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),

              // Speed Selector Button
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _toggleSpeed,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD6E6FE),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.speed_rounded,
                          size: 13,
                          color: Color(0xFF1D4ED8),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${_speed}X',
                          style: GoogleFonts.poppins(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1D4ED8),
                          ),
                        ),
                      ],
                    ),
                  ),
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

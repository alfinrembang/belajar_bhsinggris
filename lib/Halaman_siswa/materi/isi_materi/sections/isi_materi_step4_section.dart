import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Section Konten Tahap 4: Contoh Teks Lengkap (Example), Latihan Listening Audio Player,
/// dan Soal Pilihan Ganda Interaktif.
/// Dibuat secara modular, presisi, dan interaktif sesuai desain mockup visual.
class IsiMateriStep4Section extends StatefulWidget {
  final String titleExample;
  final String sampleTitle;
  final String sampleText;
  final String instructionText;
  final String questionText;
  final List<String> options;

  const IsiMateriStep4Section({
    super.key,
    this.titleExample = 'Example (contoh)',
    this.sampleTitle = 'My best pren',
    this.sampleText =
        'her name is cindy she is my best frined she is tall and she has long hair seha has big round eyes and abeautiful smile,cindy is kind, friendly,and always helps me when i nedd helep',
    this.instructionText =
        'Dengarkan audio singkat di atas, lalu pilih karakteristik kepribadian dari rekan kerja yang dideskripsikan',
    this.questionText = 'Dari audio di atas manakah jawaban yang menurutmu benar',
    this.options = const [
      'Shy & quiet',
      'Shy & quiet',
      'Shy & quiet',
      'Shy & quiet',
    ],
  });

  @override
  State<IsiMateriStep4Section> createState() => _IsiMateriStep4SectionState();
}

class _IsiMateriStep4SectionState extends State<IsiMateriStep4Section> {
  bool _isPlaying = false;
  int _selectedOptionIndex = 1; // Default opsi B terpilih sesuai mockup visual
  double _speed = 1.0;

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isPlaying ? 'Memutar audio listening...' : 'Audio dijeda.'),
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
        // 1. BAGIAN: Example (contoh)
        // =====================================================================
        Text(
          widget.titleExample,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1D4ED8), // Vibrant Royal Blue
          ),
        ),

        const SizedBox(height: 12),

        // Kotak Contoh Teks dengan Border Biru Tebal
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFF0066D6), // Vibrant Electric Blue Border
              width: 2.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0066D6).withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Kotak: Judul Contoh "My best pren"
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: const BoxDecoration(
                  color: Color(0xFFEDF7EE), // Soft Mint Green
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Center(
                  child: Text(
                    widget.sampleTitle,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2E7D32), // Deep Forest Green
                    ),
                  ),
                ),
              ),

              // Isi Teks Contoh
              Padding(
                padding: const EdgeInsets.all(14),
                child: Text(
                  widget.sampleText,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0F172A),
                    height: 1.42,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // =====================================================================
        // 2. BAGIAN: Latihan Listening dan soal
        // =====================================================================
        Text(
          'Latihan Listening dan soal',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1D4ED8),
          ),
        ),

        const SizedBox(height: 14),

        // Kartu Pembungkus Soal & Audio
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
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
              // Baris Status Audio
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Chip Kategori Listening
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF5FE),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.headphones_rounded,
                          size: 15,
                          color: Color(0xFF0066D6),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Listening Descriptiv Text',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Indikator Audio Siap
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF16A34A), // Green Dot
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Audio Siap',
                        style: GoogleFonts.poppins(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF16A34A),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ===============================================================
              // AUDIO PLAYER BOX (Waveform + Play Button)
              // ===============================================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFEBF3FE), // Soft Blue Canvas
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Tombol Play / Pause Biru
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _togglePlay,
                            borderRadius: BorderRadius.circular(22),
                            child: Container(
                              width: 42,
                              height: 42,
                              decoration: const BoxDecoration(
                                color: Color(0xFF0066D6), // Vibrant Electric Blue
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _isPlaying
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        // Durasi Berjalan
                        Text(
                          _isPlaying ? '0:14' : '0:06',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1D4ED8),
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Waveform Visualizer Bars
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: _buildWaveformBars(),
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Durasi Total
                        Text(
                          '0:24',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Chip Pengatur Kecepatan Audio (1X) di Sisi Kanan
                    Align(
                      alignment: Alignment.centerRight,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _toggleSpeed,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
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
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Petunjuk Soal
              Text(
                widget.instructionText,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                  height: 1.35,
                ),
              ),

              const SizedBox(height: 12),

              // Teks Pertanyaan
              Text(
                widget.questionText,
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1D4ED8),
                  height: 1.35,
                ),
              ),

              const SizedBox(height: 14),

              // ===============================================================
              // 4 PILIHAN GANDA (A, B, C, D)
              // ===============================================================
              ...List.generate(widget.options.length, (index) {
                final isSelected = _selectedOptionIndex == index;
                final huruf = String.fromCharCode(65 + index); // A, B, C, D
                final text = widget.options[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedOptionIndex = index;
                        });
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFEFF6FF) // Light Selected Blue
                              : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF2563EB) // Selected Border
                                : const Color(0xFFE2E8F0),
                            width: isSelected ? 1.6 : 1.1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected
                                  ? const Color(0xFF2563EB).withValues(alpha: 0.08)
                                  : Colors.black.withValues(alpha: 0.02),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Badge Huruf Opsi (Bulat)
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF0066D6) // Solid Blue
                                    : const Color(0xFFF1F5F9), // Soft Gray
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  huruf,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF64748B),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 14),

                            // Teks Jawaban
                            Expanded(
                              child: Text(
                                text,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? const Color(0xFF0066D6)
                                      : const Color(0xFF475569),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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

  /// Helper untuk membangun baris batang audio waveform
  List<Widget> _buildWaveformBars() {
    final heights = [
      12.0, 18.0, 26.0, 16.0, 24.0, 30.0, 22.0,
      14.0, 20.0, 28.0, 18.0, 12.0, 16.0, 24.0
    ];

    return List.generate(heights.length, (i) {
      // 5 batang pertama berwarna biru menyala (menandakan audio sedang diputar di 0:06)
      final isPlayed = i < 6;

      return Container(
        width: 3,
        height: heights[i],
        margin: const EdgeInsets.symmetric(horizontal: 1.5),
        decoration: BoxDecoration(
          color: isPlayed
              ? const Color(0xFF0066D6)
              : const Color(0xFFCBD5E1),
          borderRadius: BorderRadius.circular(1.5),
        ),
      );
    });
  }
}

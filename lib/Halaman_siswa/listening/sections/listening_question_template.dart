import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Reusable Widget untuk Halaman Latihan Listening (Sesuai Mockup Desain Pengguna):
/// - Judul Biru Elektrik (Dengarkan Percakapan X)
/// - Instruction Banner dengan Ikon Headphone
/// - Audio Player Card (Play/Pause, Judul Audio, Timer, Seekbar, Icon Volume)
/// - Pertanyaan (Nomor & Teks)
/// - Kartu Opsi Pilihan Jawaban A, B, C, D
class ListeningQuestionTemplate extends StatefulWidget {
  final String title;
  final String audioTitle;
  final String totalDuration;
  final int questionNumber;
  final String questionText;
  final List<String> options;
  final int correctIndex;
  final int? selectedOption;
  final ValueChanged<int> onSelectOption;
  final Widget? bottomWidget;

  const ListeningQuestionTemplate({
    super.key,
    required this.title,
    required this.audioTitle,
    required this.totalDuration,
    required this.questionNumber,
    required this.questionText,
    required this.options,
    required this.correctIndex,
    this.selectedOption,
    required this.onSelectOption,
    this.bottomWidget,
  });

  @override
  State<ListeningQuestionTemplate> createState() =>
      _ListeningQuestionTemplateState();
}

class _ListeningQuestionTemplateState extends State<ListeningQuestionTemplate> {
  bool _isPlaying = false;
  bool _isMuted = false;
  double _sliderValue = 0.0;
  Timer? _timer;
  int _currentSeconds = 0;
  late int _totalSeconds;

  @override
  void initState() {
    super.initState();
    _totalSeconds = _parseDuration(widget.totalDuration);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  int _parseDuration(String duration) {
    try {
      final parts = duration.split(':');
      if (parts.length == 2) {
        return int.parse(parts[0]) * 60 + int.parse(parts[1]);
      }
    } catch (_) {}
    return 84; // default 01:24
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _timer?.cancel();
        _timer = Timer.periodic(const Duration(seconds: 1), (t) {
          if (_currentSeconds < _totalSeconds) {
            setState(() {
              _currentSeconds++;
              _sliderValue = _currentSeconds / _totalSeconds;
            });
          } else {
            _timer?.cancel();
            setState(() {
              _isPlaying = false;
              _currentSeconds = 0;
              _sliderValue = 0.0;
            });
          }
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Judul Utama (Biru Elektrik Sesuai Mockup)
        Text(
          widget.title,
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0056D2), // Electric Royal Blue
            letterSpacing: -0.3,
          ),
        ),

        const SizedBox(height: 14),

        // 2. Banner Instruksi dengan Ikon Headphone
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFEBF3FE), // Soft Blue Background
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFDBEAFE),
              width: 1.2,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.headphones_rounded,
                color: Color(0xFF0056D2),
                size: 26,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Dengarkan audio berikut dengan seksama, lalu pilih jawaban yang paling tepat.',
                  style: GoogleFonts.poppins(
                    fontSize: 12.2,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF334155),
                    height: 1.38,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // 3. Audio Player Card (Sesuai Mockup)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F7FF), // Soft Tint Blue
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFDBEAFE),
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              // Tombol Play / Pause Biru Solid
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _togglePlay,
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0056D2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 14),

              // Info Audio: Judul, Timer, & Slider Progres
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.audioTitle,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${_formatTime(_currentSeconds)} / ${widget.totalDuration}',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Slider Track Bar
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 3.5,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
                        activeTrackColor: const Color(0xFF0056D2),
                        inactiveTrackColor: const Color(0xFFCBD5E1),
                        thumbColor: const Color(0xFF0056D2),
                      ),
                      child: Slider(
                        value: _sliderValue.clamp(0.0, 1.0),
                        onChanged: (val) {
                          setState(() {
                            _sliderValue = val;
                            _currentSeconds = (val * _totalSeconds).round();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 6),

              // Ikon Volume / Speaker
              IconButton(
                onPressed: _toggleMute,
                icon: Icon(
                  _isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                  color: const Color(0xFF0F172A),
                  size: 22,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        // 4. Pertanyaan (Nomor & Teks)
        Text(
          '${widget.questionNumber}. ${widget.questionText}',
          style: GoogleFonts.poppins(
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF00386B), // Deep Navy
            height: 1.35,
          ),
        ),

        const SizedBox(height: 14),

        // 5. Pilihan Jawaban A, B, C, D (Sesuai Mockup)
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.options.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final isSelected = widget.selectedOption == index;
            final letter = String.fromCharCode(65 + index); // A, B, C, D
            final optionText = widget.options[index];

            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => widget.onSelectOption(index),
                borderRadius: BorderRadius.circular(16),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF0056D2) : const Color(0xFFE2E8F0),
                      width: isSelected ? 1.4 : 1.1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isSelected
                            ? const Color(0xFF0056D2).withValues(alpha: 0.06)
                            : const Color(0xFF00386B).withValues(alpha: 0.02),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Badge Huruf (A, B, C, D)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF0056D2) : const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            letter,
                            style: GoogleFonts.poppins(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? Colors.white : const Color(0xFF0056D2),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 14),

                      // Teks Pilihan Jawaban
                      Expanded(
                        child: Text(
                          optionText,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected ? const Color(0xFF0F172A) : const Color(0xFF334155),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),

        if (widget.bottomWidget != null) ...[
          const SizedBox(height: 16),
          widget.bottomWidget!,
        ],
      ],
    );
  }
}

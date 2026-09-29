import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Widget Pemutar Audio Listening Interaktif dengan Animasi Waveform.
class IsiQuizAudioPlayerWidget extends StatefulWidget {
  final String audioTitle;
  final String durationText;

  const IsiQuizAudioPlayerWidget({
    super.key,
    this.audioTitle = 'Audio Percakapan Listening',
    this.durationText = '00:45',
  });

  @override
  State<IsiQuizAudioPlayerWidget> createState() =>
      _IsiQuizAudioPlayerWidgetState();
}

class _IsiQuizAudioPlayerWidgetState extends State<IsiQuizAudioPlayerWidget>
    with SingleTickerProviderStateMixin {
  bool _isPlaying = false;
  double _progress = 0.35; // default 35%
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _waveController.repeat(reverse: true);
      } else {
        _waveController.stop();
      }
    });
  }

  void _restartAudio() {
    setState(() {
      _progress = 0.0;
      _isPlaying = true;
      _waveController.repeat(reverse: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Bar Audio: Ikon Speaker & Judul
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFDBEAFE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.headphones_rounded,
                  size: 16,
                  color: Color(0xFF0056D2),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.audioTitle,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF334155),
                  ),
                ),
              ),
              IconButton(
                onPressed: _restartAudio,
                icon: const Icon(
                  Icons.replay_rounded,
                  size: 18,
                  color: Color(0xFF64748B),
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                tooltip: 'Putar Ulang',
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Baris Kontrol Utama: Tombol Play, Waveform & Slider
          Row(
            children: [
              // Tombol Play / Pause
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _togglePlay,
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0056D2),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0056D2).withValues(alpha: 0.28),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
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
              ),

              const SizedBox(width: 12),

              // Visualizer Waveform Animasi & Slider
              Expanded(
                child: Column(
                  children: [
                    // Animated Waveform Bars
                    AnimatedBuilder(
                      animation: _waveController,
                      builder: (context, child) {
                        return SizedBox(
                          height: 20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: List.generate(18, (i) {
                              final double baseHeight = 4.0;
                              final double animFactor = _isPlaying
                                  ? (sin((_waveController.value * 2 * pi) + (i * 0.4)).abs() * 14)
                                  : 4.0;
                              final bool isPassed = (i / 18) <= _progress;

                              return Container(
                                width: 3,
                                height: max(baseHeight, animFactor),
                                decoration: BoxDecoration(
                                  color: isPassed
                                      ? const Color(0xFF0056D2)
                                      : const Color(0xFFCBD5E1),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              );
                            }),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 4),

                    // Progress Slider Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: _progress,
                        minHeight: 5,
                        backgroundColor: const Color(0xFFE2E8F0),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF0056D2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // Durasi Waktu
              Text(
                widget.durationText,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

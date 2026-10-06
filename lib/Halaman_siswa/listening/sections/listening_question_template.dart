import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../services/api_service.dart';

/// Reusable Widget untuk Halaman Latihan Listening (Sesuai Mockup Desain Pengguna):
/// - Judul Biru Elektrik (Dengarkan Percakapan X)
/// - Instruction Banner dengan Ikon Headphone
/// - Audio Player Card Terintegrasi Hardware Audio (Play/Pause, Judul Audio, Timer, Seekbar, Icon Volume)
/// - Pertanyaan (Nomor & Teks)
/// - Kartu Opsi Pilihan Jawaban A, B, C, D
class ListeningQuestionTemplate extends StatefulWidget {
  final String title;
  final String audioTitle;
  final String totalDuration;
  final String? audioUrl;
  final int questionNumber;
  final String? rentangSoal;
  final int audioNomor;
  final bool isNewAudio;
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
    this.audioUrl,
    required this.questionNumber,
    this.rentangSoal,
    this.audioNomor = 1,
    this.isNewAudio = false,
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
  late final AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool _isMuted = false;
  double _sliderValue = 0.0;
  int _currentSeconds = 0;
  late int _totalSeconds;

  // Stream Subscriptions untuk Audioplayer
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _playerCompleteSubscription;

  // Fallback timer jika URL audio belum siap
  Timer? _fallbackTimer;

  @override
  void initState() {
    super.initState();
    _totalSeconds = _parseDuration(widget.totalDuration);
    _initAudioPlayer();
  }

  void _initAudioPlayer() {
    _audioPlayer = AudioPlayer();

    // Dengarkan perubahan state pemutar (Playing / Paused / Stopped)
    _playerStateSubscription = _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });

    // Dengarkan posisi detik pemutaran audio
    _positionSubscription = _audioPlayer.onPositionChanged.listen((position) {
      if (!mounted) return;
      setState(() {
        _currentSeconds = position.inSeconds;
        if (_totalSeconds > 0) {
          _sliderValue = (_currentSeconds / _totalSeconds).clamp(0.0, 1.0);
        }
      });
    });

    // Dengarkan total durasi audio aktual
    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      if (!mounted) return;
      if (duration.inSeconds > 0) {
        setState(() {
          _totalSeconds = duration.inSeconds;
        });
      }
    });

    // Reset posisi saat audio selesai berputar
    _playerCompleteSubscription = _audioPlayer.onPlayerComplete.listen((_) {
      if (!mounted) return;
      setState(() {
        _isPlaying = false;
        _currentSeconds = 0;
        _sliderValue = 0.0;
      });
    });
  }

  @override
  void dispose() {
    _fallbackTimer?.cancel();
    _playerStateSubscription?.cancel();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _audioPlayer.stop();
    _audioPlayer.dispose();
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

  Future<void> _togglePlay() async {
    final rawUrl = widget.audioUrl?.trim() ?? '';

    if (_isPlaying) {
      // Pause pemutaran audio
      await _audioPlayer.pause();
      _fallbackTimer?.cancel();
    } else {
      if (rawUrl.isNotEmpty) {
        // Putar audio aktual lewat AudioPlayer
        final resolvedUrl = ApiService.resolveAudioUrl(rawUrl);
        try {
          if (_currentSeconds > 0 && _currentSeconds < _totalSeconds) {
            await _audioPlayer.resume();
          } else {
            await _audioPlayer.play(UrlSource(resolvedUrl));
          }
        } catch (e) {
          debugPrint('Gagal memutar audio: $e');
          _startFallbackTimer();
        }
      } else {
        // Fallback timer jika URL audio kosong
        _startFallbackTimer();
      }
    }
  }

  void _startFallbackTimer() {
    setState(() {
      _isPlaying = true;
    });
    _fallbackTimer?.cancel();
    _fallbackTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_currentSeconds < _totalSeconds) {
        setState(() {
          _currentSeconds++;
          _sliderValue = _currentSeconds / _totalSeconds;
        });
      } else {
        _fallbackTimer?.cancel();
        setState(() {
          _isPlaying = false;
          _currentSeconds = 0;
          _sliderValue = 0.0;
        });
      }
    });
  }

  Future<void> _seekAudio(double val) async {
    final targetSec = (val * _totalSeconds).round();
    setState(() {
      _sliderValue = val;
      _currentSeconds = targetSec;
    });

    try {
      await _audioPlayer.seek(Duration(seconds: targetSec));
    } catch (_) {}
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _audioPlayer.setVolume(_isMuted ? 0.0 : 1.0);
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
            letterSpacing: -0.4,
          ),
        ),

        const SizedBox(height: 12),

        // 2. Banner Instruksi (Icon Headphone & Teks Instruksi Sesuai Mockup)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9), // Soft Neutral
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFE2E8F0),
              width: 1.1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  color: Color(0xFF0056D2),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.headphones_rounded,
                    color: Colors.white,
                    size: 19,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Dengarkan rekaman audio di bawah ini dengan teliti, kemudian pilih jawaban yang paling tepat.',
                  style: GoogleFonts.poppins(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF334155),
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Banner Informasi Audio Baru (Biar Siswa Gak Kaget saat Audio Berganti)
        if (widget.isNewAudio) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFFDE68A),
                width: 1.1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF59E0B),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.notifications_active_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rekaman Audio Berganti (Track #${widget.audioNomor})',
                        style: GoogleFonts.poppins(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF92400E),
                        ),
                      ),
                      Text(
                        'Dengarkan percakapan baru ini untuk menjawab pertanyaan nomor ini.',
                        style: GoogleFonts.poppins(
                          fontSize: 10.5,
                          color: const Color(0xFFB45309),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],

        // 3. Audio Player Card (Sesuai Mockup & Terintegrasi Hardware Audio)
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
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0056D2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Track #${widget.audioNomor}',
                            style: GoogleFonts.poppins(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        if (widget.rentangSoal != null && widget.rentangSoal!.isNotEmpty) ...[
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              '(${widget.rentangSoal})',
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF0056D2),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),
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
                        onChanged: _seekAudio,
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

import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../services/api_service.dart';

/// Section Konten Tahap 4: Latihan Soal Pemahaman (Mini Quiz Gabungan Pilihan Ganda & Listening).
/// 100% Dinamis dari tabel materi_soals di Laravel.
class IsiMateriStep4Section extends StatefulWidget {
  final List<dynamic>? soals;
  final int xpReward;
  final void Function(Map<String, String> jawabanSiswa, int benar, int total)? onSelesai;
  final void Function(Map<String, String> jawabanSiswa, int totalChecked, int totalSoal)? onProgressChanged;

  const IsiMateriStep4Section({
    super.key,
    this.soals,
    this.xpReward = 50,
    this.onSelesai,
    this.onProgressChanged,
  });

  @override
  State<IsiMateriStep4Section> createState() => _IsiMateriStep4SectionState();
}

class _IsiMateriStep4SectionState extends State<IsiMateriStep4Section> {
  int _activeSoalIndex = 0;
  final Map<int, String> _selectedAnswers = {};
  final Map<int, bool> _checkedAnswers = {};

  // Integrasi Hardware Audio Player dengan audioplayers
  late final AudioPlayer _audioPlayer;
  bool _isPlayingAudio = false;
  bool _isLoadingAudio = false;
  Duration _audioPosition = Duration.zero;
  Duration _audioDuration = Duration.zero;
  String? _currentlyLoadedUrl;

  StreamSubscription? _playerStateSub;
  StreamSubscription? _positionSub;
  StreamSubscription? _durationSub;
  StreamSubscription? _completeSub;

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  void _initAudioPlayer() {
    _audioPlayer = AudioPlayer();

    _playerStateSub = _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        _isPlayingAudio = state == PlayerState.playing;
      });
    });

    _positionSub = _audioPlayer.onPositionChanged.listen((pos) {
      if (!mounted) return;
      setState(() {
        _audioPosition = pos;
      });
    });

    _durationSub = _audioPlayer.onDurationChanged.listen((dur) {
      if (!mounted) return;
      setState(() {
        _audioDuration = dur;
      });
    });

    _completeSub = _audioPlayer.onPlayerComplete.listen((_) {
      if (!mounted) return;
      setState(() {
        _isPlayingAudio = false;
        _audioPosition = Duration.zero;
      });
    });
  }

  @override
  void dispose() {
    _playerStateSub?.cancel();
    _positionSub?.cancel();
    _durationSub?.cancel();
    _completeSub?.cancel();
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _changeSoal(int newIndex) {
    if (_isPlayingAudio) {
      _audioPlayer.pause();
    }
    setState(() {
      _activeSoalIndex = newIndex;
      _audioPosition = Duration.zero;
      _currentlyLoadedUrl = null;
    });
  }

  Future<void> _toggleAudioSoal(String? rawUrl) async {
    if (rawUrl == null || rawUrl.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('File audio untuk butir soal listening ini tidak ditemukan.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final resolvedUrl = ApiService.resolveAudioUrl(rawUrl);

    if (_isPlayingAudio) {
      await _audioPlayer.pause();
    } else {
      try {
        setState(() => _isLoadingAudio = true);
        if (_currentlyLoadedUrl != resolvedUrl) {
          await _audioPlayer.setSource(UrlSource(resolvedUrl));
          _currentlyLoadedUrl = resolvedUrl;
        }
        await _audioPlayer.resume();
      } catch (e) {
        debugPrint('Error playing audio listening: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal memutar audio: $e'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoadingAudio = false);
        }
      }
    }
  }

  Future<void> _replayAudio(String? rawUrl) async {
    if (rawUrl == null || rawUrl.trim().isEmpty) return;
    final resolvedUrl = ApiService.resolveAudioUrl(rawUrl);
    try {
      await _audioPlayer.seek(Duration.zero);
      await _audioPlayer.play(UrlSource(resolvedUrl));
      _currentlyLoadedUrl = resolvedUrl;
    } catch (e) {
      debugPrint('Replay error: $e');
    }
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _selectOption(String choiceKey) {
    if (_checkedAnswers[_activeSoalIndex] == true) return;
    setState(() {
      _selectedAnswers[_activeSoalIndex] = choiceKey;
    });
  }

  void _checkAnswer(String kunciJawaban) {
    final selected = _selectedAnswers[_activeSoalIndex];
    if (selected == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih salah satu jawaban (A, B, C, atau D) terlebih dahulu!'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(milliseconds: 1500),
        ),
      );
      return;
    }

    setState(() {
      _checkedAnswers[_activeSoalIndex] = true;
    });

    // Notifikasi progres ke parent
    final hasDynamic = widget.soals != null && widget.soals!.isNotEmpty;
    final totalCount = hasDynamic ? widget.soals!.length : 1;
    final Map<String, String> progressMap = {};
    int checkedCount = 0;
    for (int i = 0; i < totalCount; i++) {
      if (_checkedAnswers[i] == true && _selectedAnswers[i] != null) {
        checkedCount++;
        final s = (widget.soals ?? [])[i];
        final sId = (s['id'] ?? (i + 1)).toString();
        progressMap[sId] = _selectedAnswers[i]!;
      }
    }
    widget.onProgressChanged?.call(progressMap, checkedCount, totalCount);

    final isCorrect = selected.trim().toUpperCase() == kunciJawaban.trim().toUpperCase();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isCorrect
              ? 'Jawaban Benar! +${(widget.xpReward / (widget.soals?.length ?? 5)).round()} XP'
              : 'Jawaban Kurang Tepat. Simak pembahasannya di bawah.',
        ),
        backgroundColor: isCorrect ? const Color(0xFF059669) : const Color(0xFFDC2626),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasDynamicSoals = widget.soals != null && widget.soals!.isNotEmpty;
    final totalSoal = hasDynamicSoals ? widget.soals!.length : 1;
    final currentSoal = hasDynamicSoals
        ? (widget.soals![_activeSoalIndex] as Map<String, dynamic>)
        : null;

    final pertanyaan = currentSoal != null
        ? (currentSoal['pertanyaan']?.toString() ?? '')
        : 'What is the main purpose of this lesson?';

    final tipeSoal = currentSoal != null
        ? (currentSoal['tipe_soal']?.toString() ?? 'pilgan')
        : 'pilgan';

    final audioSoalUrl = currentSoal != null
        ? currentSoal['audio_soal_url']?.toString()
        : null;

    final isListening = tipeSoal == 'listening' || (audioSoalUrl != null && audioSoalUrl.isNotEmpty);

    final kunciJawaban = currentSoal != null
        ? (currentSoal['kunci_jawaban']?.toString() ?? 'A')
        : 'A';

    final pembahasan = currentSoal != null
        ? (currentSoal['pembahasan']?.toString() ?? '')
        : '';

    final Map<String, String> pilihanMap = {};
    if (currentSoal != null && currentSoal['pilihan'] is Map) {
      final rawPilihan = currentSoal['pilihan'] as Map;
      for (var k in ['A', 'B', 'C', 'D']) {
        if (rawPilihan[k] != null) {
          pilihanMap[k] = rawPilihan[k].toString();
        }
      }
    } else {
      pilihanMap['A'] = 'To entertain readers with a story';
      pilihanMap['B'] = 'To describe a specific object';
      pilihanMap['C'] = 'To give instructions clearly';
      pilihanMap['D'] = 'To explain scientific facts';
    }

    final selectedKey = _selectedAnswers[_activeSoalIndex];
    final isChecked = _checkedAnswers[_activeSoalIndex] == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // =====================================================================
        // HEADER: Latihan Soal Pemahaman
        // =====================================================================
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Latihan Soal Pemahaman',
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1D4ED8),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.bolt_rounded, size: 14, color: Color(0xFFD97706)),
                  const SizedBox(width: 3),
                  Text(
                    '+${widget.xpReward} XP',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFB45309),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // =====================================================================
        // KARTU WADAH LATIHAN SOAL INTERAKTIF
        // =====================================================================
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFE2E8F0),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Baris Info Nomor & Tipe Soal
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Soal ${_activeSoalIndex + 1} dari $totalSoal',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isListening
                          ? const Color(0xFFEDE9FE)
                          : const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isListening
                            ? const Color(0xFFDDD6FE)
                            : const Color(0xFFBFDBFE),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isListening ? Icons.headphones_rounded : Icons.edit_note_rounded,
                          size: 14,
                          color: isListening ? const Color(0xFF7C3AED) : const Color(0xFF0066D6),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isListening ? 'Soal Listening' : 'Pilihan Ganda',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: isListening
                                ? const Color(0xFF7C3AED)
                                : const Color(0xFF0066D6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Pager Navigasi Nomor Soal (1, 2, 3, 4, 5...)
              if (totalSoal > 1)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: List.generate(totalSoal, (idx) {
                      final isActive = _activeSoalIndex == idx;
                      final isAnswered = _selectedAnswers.containsKey(idx);
                      final isAnsChecked = _checkedAnswers[idx] == true;

                      // Deteksi apakah soal nomor ini bertipe listening
                      bool itemIsListening = false;
                      if (hasDynamicSoals && idx < widget.soals!.length) {
                        final item = widget.soals![idx] as Map<String, dynamic>;
                        itemIsListening = item['tipe_soal'] == 'listening' ||
                            (item['audio_soal_url'] != null && item['audio_soal_url'].toString().isNotEmpty);
                      }

                      Color btnColor = const Color(0xFFF1F5F9);
                      Color textColor = const Color(0xFF64748B);

                      if (isActive) {
                        btnColor = itemIsListening ? const Color(0xFF7C3AED) : const Color(0xFF0066D6);
                        textColor = Colors.white;
                      } else if (isAnsChecked) {
                        final chosen = _selectedAnswers[idx];
                        final curKunci = hasDynamicSoals
                            ? (widget.soals![idx]['kunci_jawaban']?.toString() ?? '')
                            : '';
                        final correct = chosen?.toUpperCase() == curKunci.toUpperCase();
                        btnColor = correct ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2);
                        textColor = correct ? const Color(0xFF059669) : const Color(0xFFDC2626);
                      } else if (isAnswered) {
                        btnColor = const Color(0xFFE0E7FF);
                        textColor = const Color(0xFF3730A3);
                      }

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: InkWell(
                          onTap: () => _changeSoal(idx),
                          borderRadius: BorderRadius.circular(10),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            width: 40,
                            height: 38,
                            decoration: BoxDecoration(
                              color: btnColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isActive
                                    ? (itemIsListening ? const Color(0xFF6D28D9) : const Color(0xFF0052B4))
                                    : Colors.transparent,
                                width: 1.2,
                              ),
                              boxShadow: isActive
                                  ? [
                                      BoxShadow(
                                        color: (itemIsListening ? const Color(0xFF7C3AED) : const Color(0xFF0066D6))
                                            .withValues(alpha: 0.25),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Text(
                                  '${idx + 1}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: textColor,
                                  ),
                                ),
                                if (itemIsListening)
                                  Positioned(
                                    top: 3,
                                    right: 4,
                                    child: Icon(
                                      Icons.headphones_rounded,
                                      size: 9,
                                      color: isActive ? Colors.white70 : const Color(0xFF7C3AED),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

              const SizedBox(height: 14),

              // ===============================================================
              // AUDIO PLAYER ELEGAN UNTUK SOAL LISTENING
              // ===============================================================
              if (isListening) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F3FF),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFDDD6FE), width: 1.3),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Audio Box
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color(0xFFEDE9FE),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.headphones_rounded,
                              color: Color(0xFF7C3AED),
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Audio Rekaman Soal',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF5B21B6),
                                  ),
                                ),
                                Text(
                                  'Dengarkan audio dengan teliti untuk menemukan jawaban',
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    color: const Color(0xFF7C3AED),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_isLoadingAudio)
                            const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF7C3AED),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Player Controller: Play/Pause, Slider, Timer, Replay
                      Row(
                        children: [
                          // Tombol Play / Pause
                          InkWell(
                            onTap: () => _toggleAudioSoal(audioSoalUrl),
                            borderRadius: BorderRadius.circular(22),
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: const Color(0xFF7C3AED),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Icon(
                                  _isPlayingAudio
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                  color: Colors.white,
                                  size: 26,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          // Tombol Putar Ulang (Replay dari awal)
                          InkWell(
                            onTap: () => _replayAudio(audioSoalUrl),
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0xFFDDD6FE)),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.replay_rounded,
                                  color: Color(0xFF6D28D9),
                                  size: 18,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          // Progress Bar Slider & Timer Waktu
                          Expanded(
                            child: Column(
                              children: [
                                SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    trackHeight: 4,
                                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                                    activeTrackColor: const Color(0xFF7C3AED),
                                    inactiveTrackColor: const Color(0xFFDDD6FE),
                                    thumbColor: const Color(0xFF7C3AED),
                                  ),
                                  child: Slider(
                                    value: (_audioDuration.inMilliseconds > 0)
                                        ? (_audioPosition.inMilliseconds / _audioDuration.inMilliseconds)
                                            .clamp(0.0, 1.0)
                                        : 0.0,
                                    onChanged: (val) {
                                      if (_audioDuration.inMilliseconds > 0) {
                                        final newPos = Duration(
                                          milliseconds: (val * _audioDuration.inMilliseconds).round(),
                                        );
                                        _audioPlayer.seek(newPos);
                                      }
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 6),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _formatDuration(_audioPosition),
                                        style: GoogleFonts.poppins(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF6D28D9),
                                        ),
                                      ),
                                      Text(
                                        _formatDuration(_audioDuration),
                                        style: GoogleFonts.poppins(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF8B5CF6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
              ],

              // Teks Pertanyaan Soal
              Text(
                pertanyaan,
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E293B),
                  height: 1.45,
                ),
              ),

              const SizedBox(height: 14),

              // ===============================================================
              // 4 PILIHAN JAWABAN (A, B, C, D)
              // ===============================================================
              ...pilihanMap.entries.map((entry) {
                final key = entry.key;
                final text = entry.value;
                final isSelected = selectedKey == key;
                final isCorrectKey = key.toUpperCase() == kunciJawaban.toUpperCase();

                Color cardBg = Colors.white;
                Color borderColor = const Color(0xFFE2E8F0);
                Color badgeBg = const Color(0xFFF1F5F9);
                Color badgeText = const Color(0xFF64748B);

                if (isChecked) {
                  if (isCorrectKey) {
                    cardBg = const Color(0xFFF0FDF4);
                    borderColor = const Color(0xFF10B981);
                    badgeBg = const Color(0xFF10B981);
                    badgeText = Colors.white;
                  } else if (isSelected && !isCorrectKey) {
                    cardBg = const Color(0xFFFEF2F2);
                    borderColor = const Color(0xFFEF4444);
                    badgeBg = const Color(0xFFEF4444);
                    badgeText = Colors.white;
                  }
                } else if (isSelected) {
                  cardBg = isListening ? const Color(0xFFF5F3FF) : const Color(0xFFEFF6FF);
                  borderColor = isListening ? const Color(0xFF7C3AED) : const Color(0xFF2563EB);
                  badgeBg = isListening ? const Color(0xFF7C3AED) : const Color(0xFF0066D6);
                  badgeText = Colors.white;
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onTap: () => _selectOption(key),
                    borderRadius: BorderRadius.circular(14),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: borderColor,
                          width: (isSelected || (isChecked && isCorrectKey)) ? 1.6 : 1.1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: badgeBg,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                key,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: badgeText,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              text,
                              style: GoogleFonts.poppins(
                                fontSize: 12.5,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: const Color(0xFF1E293B),
                              ),
                            ),
                          ),
                          if (isChecked && isCorrectKey)
                            const Icon(
                              Icons.check_circle_rounded,
                              color: Color(0xFF10B981),
                              size: 20,
                            )
                          else if (isChecked && isSelected && !isCorrectKey)
                            const Icon(
                              Icons.cancel_rounded,
                              color: Color(0xFFEF4444),
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),

              // Kotak Pembahasan (Jika sudah dicek)
              if (isChecked && pembahasan.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.lightbulb_rounded, color: Color(0xFFD97706), size: 16),
                          const SizedBox(width: 6),
                          Text(
                            'Pembahasan:',
                            style: GoogleFonts.poppins(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        pembahasan,
                        style: GoogleFonts.poppins(
                          fontSize: 11.5,
                          color: const Color(0xFF475569),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 16),

              // Baris Tombol Aksi: Cek Jawaban / Navigasi
              Row(
                children: [
                  if (_activeSoalIndex > 0)
                    IconButton(
                      onPressed: () => _changeSoal(_activeSoalIndex - 1),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFFF1F5F9),
                        foregroundColor: const Color(0xFF475569),
                      ),
                    ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isChecked
                          ? (_activeSoalIndex < totalSoal - 1
                              ? () => _changeSoal(_activeSoalIndex + 1)
                              : () {
                                  final listSoal = widget.soals ?? [];
                                  int unansweredIndex = -1;
                                  for (int i = 0; i < listSoal.length; i++) {
                                    if (_checkedAnswers[i] != true || _selectedAnswers[i] == null) {
                                      unansweredIndex = i;
                                      break;
                                    }
                                  }

                                  if (unansweredIndex != -1) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('⚠️ Soal nomor  belum dijawab dan diperiksa! Selesaikan semua soal terlebih dahulu.'),
                                        backgroundColor: const Color(0xFFDC2626),
                                        behavior: SnackBarBehavior.floating,
                                        duration: const Duration(seconds: 3),
                                      ),
                                    );
                                    _changeSoal(unansweredIndex);
                                    return;
                                  }

                                  if (_isPlayingAudio) {
                                    _audioPlayer.pause();
                                  }

                                  final Map<String, String> jawabanMap = {};
                                  int benarCount = 0;
                                  for (int i = 0; i < listSoal.length; i++) {
                                    final s = listSoal[i];
                                    final sId = (s['id'] ?? (i + 1)).toString();
                                    final chosen = _selectedAnswers[i] ?? '';
                                    jawabanMap[sId] = chosen;
                                    final kunci = (s['kunci_jawaban'] ?? '').toString().trim().toUpperCase();
                                    if (chosen.trim().toUpperCase() == kunci && kunci.isNotEmpty) {
                                      benarCount++;
                                    }
                                  }
                                  widget.onSelesai?.call(jawabanMap, benarCount, listSoal.length);
                                })
                          : () => _checkAnswer(kunciJawaban),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isChecked
                            ? const Color(0xFF059669)
                            : (isListening ? const Color(0xFF7C3AED) : const Color(0xFF0066D6)),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        isChecked
                            ? (_activeSoalIndex < totalSoal - 1
                                ? 'Lanjut ke Soal Berikutnya →'
                                : 'Semua Soal Selesai ✓')
                            : 'Periksa Jawaban',
                        style: GoogleFonts.poppins(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  if (_activeSoalIndex < totalSoal - 1) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => _changeSoal(_activeSoalIndex + 1),
                      icon: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFFF1F5F9),
                        foregroundColor: const Color(0xFF475569),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),
      ],
    );
  }
}

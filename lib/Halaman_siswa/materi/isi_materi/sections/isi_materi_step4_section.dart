import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Section Konten Tahap 4: Latihan Soal Pemahaman (Mini Quiz 5 Soal dari Guru).
/// 100% Dinamis dari tabel materi_soals di Laravel.
class IsiMateriStep4Section extends StatefulWidget {
  final List<dynamic>? soals;
  final int xpReward;
  final VoidCallback? onSelesai;

  const IsiMateriStep4Section({
    super.key,
    this.soals,
    this.xpReward = 50,
    this.onSelesai,
  });

  @override
  State<IsiMateriStep4Section> createState() => _IsiMateriStep4SectionState();
}

class _IsiMateriStep4SectionState extends State<IsiMateriStep4Section> {
  int _activeSoalIndex = 0;
  final Map<int, String> _selectedAnswers = {};
  final Map<int, bool> _checkedAnswers = {};
  bool _isPlayingAudioSoal = false;

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

    final isCorrect = selected.trim().toUpperCase() == kunciJawaban.trim().toUpperCase();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isCorrect
              ? '🎉 Jawaban Benar! +${(widget.xpReward / (widget.soals?.length ?? 5)).round()} XP'
              : '❌ Jawaban Kurang Tepat. Simak pembahasannya di bawah.',
        ),
        backgroundColor: isCorrect ? const Color(0xFF059669) : const Color(0xFFDC2626),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _toggleAudioSoal() {
    setState(() {
      _isPlayingAudioSoal = !_isPlayingAudioSoal;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isPlayingAudioSoal ? 'Memutar audio listening soal...' : 'Audio soal dijeda.'),
        duration: const Duration(milliseconds: 1200),
        behavior: SnackBarBehavior.floating,
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
        : 'What is the main purpose of a descriptive text?';

    final tipeSoal = currentSoal != null
        ? (currentSoal['tipe_soal']?.toString() ?? 'pilgan')
        : 'pilgan';

    final audioSoalUrl = currentSoal != null
        ? currentSoal['audio_soal_url']?.toString()
        : null;

    final kunciJawaban = currentSoal != null
        ? (currentSoal['kunci_jawaban']?.toString() ?? 'B')
        : 'B';

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
      pilihanMap['A'] = 'To entertain readers with a fictional story';
      pilihanMap['B'] = 'To describe a specific person, place, or object';
      pilihanMap['C'] = 'To tell the steps to make something';
      pilihanMap['D'] = 'To report daily news events';
    }

    final selectedKey = _selectedAnswers[_activeSoalIndex];
    final isChecked = _checkedAnswers[_activeSoalIndex] == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // =====================================================================
        // HEADER: Latihan Soal Pemahaman
        // =====================================================================
        Text(
          'Latihan Soal Pemahaman',
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1D4ED8),
          ),
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
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                    decoration: BoxDecoration(
                      color: tipeSoal == 'listening'
                          ? const Color(0xFFEDE9FE)
                          : const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      tipeSoal == 'listening' ? '🎧 Soal Listening' : '📝 Pilihan Ganda',
                      style: GoogleFonts.poppins(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: tipeSoal == 'listening'
                            ? const Color(0xFF7C3AED)
                            : const Color(0xFF0066D6),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Pager Navigasi Nomor Soal (1, 2, 3, 4, 5)
              if (totalSoal > 1)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: List.generate(totalSoal, (idx) {
                      final isActive = _activeSoalIndex == idx;
                      final isAnswered = _selectedAnswers.containsKey(idx);
                      final isAnsChecked = _checkedAnswers[idx] == true;

                      Color btnColor = const Color(0xFFF1F5F9);
                      Color textColor = const Color(0xFF64748B);

                      if (isActive) {
                        btnColor = const Color(0xFF0066D6);
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
                          onTap: () {
                            setState(() {
                              _activeSoalIndex = idx;
                            });
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: btnColor,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: isActive
                                  ? [
                                      BoxShadow(
                                        color: const Color(0xFF0066D6).withValues(alpha: 0.25),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                '${idx + 1}',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: textColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

              const SizedBox(height: 14),

              // Audio Khusus Soal Listening jika ada
              if (tipeSoal == 'listening' || audioSoalUrl != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F3FF),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFDDD6FE)),
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: _toggleAudioSoal,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: Color(0xFF7C3AED),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              _isPlayingAudioSoal ? Icons.pause_rounded : Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dengarkan Audio Soal Ini',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF6D28D9),
                              ),
                            ),
                            Text(
                              'Klik play untuk mendengarkan audio rekaman',
                              style: GoogleFonts.poppins(
                                fontSize: 10.5,
                                color: const Color(0xFF7C3AED),
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

              // Teks Pertanyaan
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

              // 4 Pilihan Jawaban (A, B, C, D)
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
                  cardBg = const Color(0xFFEFF6FF);
                  borderColor = const Color(0xFF2563EB);
                  badgeBg = const Color(0xFF0066D6);
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
                      onPressed: () {
                        setState(() {
                          _activeSoalIndex--;
                        });
                      },
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
                              ? () {
                                  setState(() {
                                    _activeSoalIndex++;
                                  });
                                }
                              : () {
                                  widget.onSelesai?.call();
                                })
                          : () => _checkAnswer(kunciJawaban),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isChecked
                            ? const Color(0xFF059669)
                            : const Color(0xFF0066D6),
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
                      onPressed: () {
                        setState(() {
                          _activeSoalIndex++;
                        });
                      },
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

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../models/siswa_model.dart';
import '../../../../services/api_service.dart';
import '../../../../widgets/custom_button.dart';
import 'game_coin_manager.dart';
import 'puzzle_finish_page.dart';

/// Data pembungkus saat potongan puzzle di-drag
class PuzzleDragData {
  final int pieceId;
  final int? fromSlot; // null jika dari tray, atau index 0..8 jika dari papan

  const PuzzleDragData({required this.pieceId, this.fromSlot});
}

/// Halaman Bermain Puzzle Fungsional & Fleksibel:
/// - Kepingan BEBAS dipasang di slot mana saja (jika salah, gambar akan amburadul).
/// - Kepingan yang sudah di papan BISA dipindah-pindah / ditukar (Swap) antar slot.
/// - Kepingan dari papan BISA dikembalikan ke nampan bawah.
/// - Puzzle HANYA dianggap selesai jika SEMUA kepingan berada di posisi yang tepat.
class PuzzlePlayPage extends StatefulWidget {
  final int level;
  final int pieces;
  final String difficulty;
  final SiswaModel? siswa;
  final bool isAlreadyCompleted;

  const PuzzlePlayPage({
    super.key,
    required this.level,
    required this.pieces,
    this.difficulty = 'mudah',
    this.siswa,
    this.isAlreadyCompleted = false,
  });

  @override
  State<PuzzlePlayPage> createState() => _PuzzlePlayPageState();
}

class _PuzzlePlayPageState extends State<PuzzlePlayPage> {
  late int rows;
  late int cols;
  late int totalPieces;
  late String imageAsset;

  // Koleksi gambar puzzle custom (diacak di semua level)
  static const List<String> puzzleImageList = [
    'assets/images/puzzle/Colossus of Rhodes at Sunset.png',
    'assets/images/puzzle/Cosmic Vista of Rings and Galaxies.png',
    'assets/images/puzzle/Golden Hour Fishing at Mountain Lake.png',
    'assets/images/puzzle/Golden Mountain Valley at Sunrise.png',
  ];

  // State Papan & Kepingan
  late List<int?> boardSlots;
  late List<int> trayPieces;

  // Seleksi Ketuk (Tap-to-Place / Swap)
  int? selectedTrayPiece;
  int? selectedBoardSlot;

  // Countdown Timer
  Timer? _countdownTimer;
  late int _remainingSeconds;
  late int _initialSeconds;
  bool _isGameOver = false;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _initGame() {
    if (widget.difficulty == 'mudah' && widget.level == 1) {
      rows = 2;
      cols = 2;
    } else {
      rows = 3;
      cols = 3;
    }
    totalPieces = rows * cols;

    // Pemilihan gambar secara random agar tidak membosankan di semua level
    final rand = Random();
    imageAsset = puzzleImageList[rand.nextInt(puzzleImageList.length)];

    if (widget.difficulty == 'mudah') {
      _initialSeconds = 120;
    } else if (widget.difficulty == 'sedang') {
      _initialSeconds = 150;
    } else {
      _initialSeconds = 165;
    }
    _remainingSeconds = _initialSeconds;

    boardSlots = List<int?>.filled(totalPieces, null);
    trayPieces = _generateShuffledTray(totalPieces);

    selectedTrayPiece = null;
    selectedBoardSlot = null;
    _isGameOver = false;
    _isCompleted = false;

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _handleTimeOut();
      }
    });
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  /// Menghasilkan kepingan di nampan yang DIJAMIN teracak total
  /// (tidak ada yang berada di posisi aslinya 0, 1, 2, 3...)
  List<int> _generateShuffledTray(int count) {
    final rand = Random();
    List<int> list = List<int>.generate(count, (index) => index);

    int attempts = 0;
    while (attempts < 60) {
      list.shuffle(rand);
      attempts++;

      int matchCount = 0;
      bool isSequential = true;

      for (int i = 0; i < count; i++) {
        if (list[i] == i) matchCount++;
        if (i > 0 && list[i] != list[i - 1] + 1) {
          isSequential = false;
        }
      }

      // Kriteria tantangan: tidak boleh berurutan dan posisi yang sama maksimal 0 (derangement) jika 4 potongan
      if (!isSequential && matchCount <= (count <= 4 ? 0 : 1)) {
        break;
      }
    }
    return list;
  }

  void _handleTimeOut() {
    _countdownTimer?.cancel();
    setState(() {
      _isGameOver = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 16,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFFCA5A5), width: 2),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.hourglass_empty_rounded,
                      color: Color(0xFFEF4444),
                      size: 36,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Waktu Habis!',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Waktumu telah habis sebelum puzzle berhasil disusun. Ayo coba lagi dan atur strategimu!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 12.5,
                    color: const Color(0xFF64748B),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Coba Lagi',
                  icon: Icons.replay_rounded,
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() {
                      _initGame();
                    });
                  },
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Kembali ke Level',
                    style: GoogleFonts.poppins(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Pasang kepingan dari nampan ke slot (bebas di slot mana saja)
  void _placeFromTray(int pieceId, int targetSlot) {
    if (_isGameOver || _isCompleted) return;

    setState(() {
      final existingPiece = boardSlots[targetSlot];
      boardSlots[targetSlot] = pieceId;
      trayPieces.remove(pieceId);

      // Jika slot tujuan sudah ada kepingan, kembalikan kepingan lama ke nampan
      if (existingPiece != null) {
        trayPieces.add(existingPiece);
      }

      selectedTrayPiece = null;
      selectedBoardSlot = null;
    });

    _checkWinCondition();
  }

  /// Pindahkan atau tukar (swap) kepingan antar slot di papan
  void _moveOrSwapBoardSlot(int fromSlot, int targetSlot) {
    if (_isGameOver || _isCompleted) return;
    if (fromSlot == targetSlot) {
      setState(() {
        selectedBoardSlot = null;
      });
      return;
    }

    setState(() {
      final pieceFrom = boardSlots[fromSlot];
      final pieceTarget = boardSlots[targetSlot];

      boardSlots[targetSlot] = pieceFrom;
      boardSlots[fromSlot] = pieceTarget; // Berpindah atau bertukar

      selectedBoardSlot = null;
      selectedTrayPiece = null;
    });

    _checkWinCondition();
  }

  /// Kembalikan kepingan dari papan ke nampan bawah
  void _returnBoardPieceToTray(int fromSlot) {
    if (_isGameOver || _isCompleted) return;

    final piece = boardSlots[fromSlot];
    if (piece != null) {
      setState(() {
        boardSlots[fromSlot] = null;
        trayPieces.add(piece);
        selectedBoardSlot = null;
        selectedTrayPiece = null;
      });
    }
  }

  /// Cek kondisi kemenangan:
  /// Harus SEMUA slot terisi DAN SETIAP kepingan berada di posisi yang benar (index == pieceId)
  void _checkWinCondition() {
    final allFilled = boardSlots.every((p) => p != null);
    if (!allFilled) return;

    bool allCorrect = true;
    for (int i = 0; i < totalPieces; i++) {
      if (boardSlots[i] != i) {
        allCorrect = false;
        break;
      }
    }

    if (allCorrect) {
      _handleGameWin();
    }
  }

  Future<void> _handleGameWin() async {
    _isCompleted = true;
    _countdownTimer?.cancel();

    final timeSpentSeconds = _initialSeconds - _remainingSeconds;
    final timeSpentFormatted = _formatTime(timeSpentSeconds);

    int stars = 3;
    if (timeSpentSeconds > (_initialSeconds * 0.65)) {
      stars = 1;
    } else if (timeSpentSeconds > (_initialSeconds * 0.4)) {
      stars = 2;
    }

    // Koin reward: 0 jika level sudah pernah diselesaikan, atau 20 + (stars * 5) jika pertama kali
    int coinsEarned = widget.isAlreadyCompleted ? 0 : (20 + (stars * 5));
    if (coinsEarned > 0) {
      GameCoinManager.addCoins(coinsEarned);
    }

    String bestTime = timeSpentFormatted;
    try {
      final res = await ApiService.submitPuzzleSelesai(
        siswaId: widget.siswa?.id,
        difficulty: widget.difficulty,
        level: widget.level,
        stars: stars,
        timeSpent: timeSpentFormatted,
        coinsEarned: coinsEarned,
      );

      if (res['success'] == true && res['data'] != null) {
        if (res['data']['best_time'] != null) {
          bestTime = res['data']['best_time'].toString();
        }
        if (res['coins_awarded'] != null) {
          coinsEarned = (res['coins_awarded'] as num).toInt();
        } else if (res['data']['coins_awarded'] != null) {
          coinsEarned = (res['data']['coins_awarded'] as num).toInt();
        }
        if (res['koin'] != null) {
          GameCoinManager.setCoins(res['koin'] as int);
        }
      }
    } catch (_) {}

    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (c, a, s) => PuzzleFinishPage(
            level: widget.level,
            difficulty: widget.difficulty,
            siswa: widget.siswa,
            timeSpent: timeSpentFormatted,
            bestTime: bestTime,
            stars: stars,
            coinsEarned: coinsEarned,
            imageAsset: imageAsset,
          ),
          transitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (c, a, s, child) =>
              FadeTransition(opacity: a, child: child),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final placedCount = boardSlots.where((p) => p != null).length;
    final isAllFilled = placedCount == totalPieces;
    bool isAllCorrect = false;
    if (isAllFilled) {
      isAllCorrect = true;
      for (int i = 0; i < totalPieces; i++) {
        if (boardSlots[i] != i) {
          isAllCorrect = false;
          break;
        }
      }
    }

    final isLowTime = _remainingSeconds <= 30;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFE),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Header (Kembali, Level & Info, Timer & Koin)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A)),
                    ),
                  ),

                  // Info Level
                  Column(
                    children: [
                      Text(
                        'Level ${widget.level}',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        '$totalPieces Potongan',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),

                  // Timer & Koin
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: isLowTime ? const Color(0xFFFEE2E2) : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isLowTime ? const Color(0xFFEF4444) : const Color(0xFFE2E8F0),
                            width: isLowTime ? 1.5 : 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.timer_outlined,
                              color: isLowTime ? const Color(0xFFEF4444) : const Color(0xFF0F172A),
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatTime(_remainingSeconds),
                              style: GoogleFonts.poppins(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                color: isLowTime ? const Color(0xFFEF4444) : const Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      ValueListenableBuilder<int>(
                        valueListenable: GameCoinManager.coins,
                        builder: (context, currentCoins, child) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: const Color(0xFFFDE68A)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.monetization_on_rounded, color: Color(0xFFD97706), size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  '$currentCoins',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFFD97706),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 6),

            // Banner Status jika Semua Terpasang tapi Amburadul (Salah Posisi)
            if (isAllFilled && !isAllCorrect)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFF59E0B)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: Color(0xFFD97706), size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Gambar masih amburadul! Geser/tukar potongan yang salah agar pas.',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFB45309),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // 2. Area Papan Puzzle Utama (Bisa Disusun Bebas & Ditukar)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE2E8F0), width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0E4E93).withValues(alpha: 0.08),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final boardWidth = constraints.maxWidth;
                          final boardHeight = constraints.maxHeight;
                          final pieceW = boardWidth / cols;
                          final pieceH = boardHeight / rows;

                          return Column(
                            children: List.generate(rows, (r) {
                              return Expanded(
                                child: Row(
                                  children: List.generate(cols, (c) {
                                    final slotIndex = (r * cols) + c;
                                    return Expanded(
                                      child: _buildBoardSlot(
                                        slotIndex: slotIndex,
                                        pieceW: pieceW,
                                        pieceH: pieceH,
                                        boardW: boardWidth,
                                        boardH: boardHeight,
                                      ),
                                    );
                                  }),
                                ),
                              );
                            }),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 6),

            // Petunjuk Interaktif
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Terpasang: $placedCount / $totalPieces',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  if (selectedBoardSlot != null)
                    GestureDetector(
                      onTap: () => _returnBoardPieceToTray(selectedBoardSlot!),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFFCA5A5)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.undo_rounded, size: 12, color: Color(0xFFDC2626)),
                            const SizedBox(width: 4),
                            Text(
                              'Kembalikan ke nampan',
                              style: GoogleFonts.poppins(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFDC2626),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (selectedTrayPiece != null)
                    Text(
                      'Ketuk kotak slot tujuan',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0066D6),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // 3. Nampan Kepingan Puzzle Bawah (DropTarget untuk mengembalikan kepingan)
            Container(
              height: 86,
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: DragTarget<PuzzleDragData>(
                onWillAcceptWithDetails: (details) => details.data.fromSlot != null,
                onAcceptWithDetails: (details) {
                  // Drag dari papan ke nampan -> kembalikan kepingan
                  if (details.data.fromSlot != null) {
                    _returnBoardPieceToTray(details.data.fromSlot!);
                  }
                },
                builder: (context, candidateData, rejectedData) {
                  final isHovered = candidateData.isNotEmpty;

                  return GestureDetector(
                    onTap: () {
                      // Jika ada slot di papan yang terpilih, ketuk nampan untuk mengembalikan kepingan
                      if (selectedBoardSlot != null) {
                        _returnBoardPieceToTray(selectedBoardSlot!);
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isHovered
                            ? const Color(0xFFE9D5FF)
                            : const Color(0xFFF3E8FF).withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isHovered
                              ? const Color(0xFF9333EA)
                              : const Color(0xFFD8B4FE).withValues(alpha: 0.6),
                          width: isHovered ? 2.0 : 1.5,
                        ),
                      ),
                      child: trayPieces.isEmpty
                          ? Center(
                              child: Text(
                                'Semua kepingan berada di papan.\n(Geser kembali ke sini jika ingin melepas)',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF7E22CE),
                                ),
                              ),
                            )
                          : ListView.separated(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemCount: trayPieces.length,
                              separatorBuilder: (context, index) => const SizedBox(width: 10),
                              itemBuilder: (context, index) {
                                final pieceId = trayPieces[index];
                                final isSelected = selectedTrayPiece == pieceId;

                                return Center(
                                  child: _buildTrayPieceItem(
                                    pieceId: pieceId,
                                    isSelected: isSelected,
                                  ),
                                );
                              },
                            ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Membangun slot pada papan (DragTarget & Draggable jika ada kepingan di dalamnya)
  Widget _buildBoardSlot({
    required int slotIndex,
    required double pieceW,
    required double pieceH,
    required double boardW,
    required double boardH,
  }) {
    final placedPiece = boardSlots[slotIndex];
    final isSelected = selectedBoardSlot == slotIndex;

    return DragTarget<PuzzleDragData>(
      onWillAcceptWithDetails: (details) => true, // BEBAS pasang/tukar apa saja!
      onAcceptWithDetails: (details) {
        final data = details.data;
        if (data.fromSlot == null) {
          // Dari Nampan ke Papan
          _placeFromTray(data.pieceId, slotIndex);
        } else {
          // Dari Papan ke Papan (Pindah / Tukar Posisi)
          _moveOrSwapBoardSlot(data.fromSlot!, slotIndex);
        }
      },
      builder: (context, candidateData, rejectedData) {
        final isHovered = candidateData.isNotEmpty;

        Widget slotContent = Container(
          margin: const EdgeInsets.all(2.5),
          decoration: BoxDecoration(
            color: placedPiece != null
                ? Colors.white
                : isHovered
                    ? const Color(0xFFDBEAFE)
                    : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF2563EB)
                  : isHovered
                      ? const Color(0xFF0066D6)
                      : placedPiece != null
                          ? const Color(0xFFCBD5E1)
                          : const Color(0xFFE2E8F0),
              width: isSelected || isHovered ? 2.5 : 1.2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Jika ada potongan terpasang (menampilkan potongan apapun yang ditaruh!)
                if (placedPiece != null)
                  _buildPieceSlice(
                    pieceIndex: placedPiece,
                    pieceWidth: pieceW,
                    pieceHeight: pieceH,
                    boardWidth: boardW,
                    boardHeight: boardH,
                    opacity: 1.0,
                  )
                else ...[
                  // Slot kosong: siluet samar
                  _buildPieceSlice(
                    pieceIndex: slotIndex,
                    pieceWidth: pieceW,
                    pieceHeight: pieceH,
                    boardWidth: boardW,
                    boardHeight: boardH,
                    opacity: 0.14,
                  ),
                  Center(
                    child: Icon(
                      Icons.extension_rounded,
                      color: const Color(0xFF0066D6).withValues(alpha: 0.5),
                      size: 20,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );

        // Jika slot berisi kepingan, jadikan ia Draggable agar bisa dipindah/ditukar
        if (placedPiece != null) {
          slotContent = Draggable<PuzzleDragData>(
            data: PuzzleDragData(pieceId: placedPiece, fromSlot: slotIndex),
            feedback: Material(
              color: Colors.transparent,
              child: SizedBox(
                width: pieceW,
                height: pieceH,
                child: slotContent,
              ),
            ),
            childWhenDragging: Opacity(
              opacity: 0.25,
              child: slotContent,
            ),
            child: slotContent,
          );
        }

        return GestureDetector(
          onTap: () {
            // Logika Ketuk:
            if (selectedTrayPiece != null) {
              // Pasang dari nampan ke slot ini
              _placeFromTray(selectedTrayPiece!, slotIndex);
            } else if (selectedBoardSlot != null) {
              // Pindah / Tukar dari slot lain ke slot ini
              _moveOrSwapBoardSlot(selectedBoardSlot!, slotIndex);
            } else if (placedPiece != null) {
              // Pilih kepingan ini untuk dipindah
              setState(() {
                selectedBoardSlot = slotIndex;
              });
            }
          },
          child: slotContent,
        );
      },
    );
  }

  /// Kepingan di nampan bawah
  Widget _buildTrayPieceItem({
    required int pieceId,
    required bool isSelected,
  }) {
    const itemSize = 54.0;

    Widget pieceWidget({bool isDragging = false}) {
      return SizedBox(
        width: itemSize,
        height: itemSize,
        child: Container(
          width: itemSize,
          height: itemSize,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF0066D6)
                  : const Color(0xFFCBD5E1),
              width: isSelected ? 2.5 : 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? const Color(0xFF0066D6).withValues(alpha: 0.35)
                    : Colors.black.withValues(alpha: isDragging ? 0.20 : 0.08),
                blurRadius: isDragging ? 8 : 4,
                offset: Offset(0, isDragging ? 4 : 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: Stack(
              fit: StackFit.expand,
              children: [
                _buildPieceSlice(
                  pieceIndex: pieceId,
                  pieceWidth: itemSize,
                  pieceHeight: itemSize,
                  boardWidth: itemSize * cols,
                  boardHeight: itemSize * rows,
                  opacity: 1.0,
                ),
                Positioned(
                  top: 2,
                  left: 2,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.50),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: const Icon(
                      Icons.extension_rounded,
                      color: Colors.white,
                      size: 9,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: itemSize,
      height: itemSize,
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (selectedTrayPiece == pieceId) {
              selectedTrayPiece = null;
            } else {
              selectedTrayPiece = pieceId;
              selectedBoardSlot = null; // batalkan pilihan papan
            }
          });
        },
        child: Draggable<PuzzleDragData>(
          data: PuzzleDragData(pieceId: pieceId, fromSlot: null),
          feedback: Material(
            color: Colors.transparent,
            child: pieceWidget(isDragging: true),
          ),
          childWhenDragging: Opacity(
            opacity: 0.35,
            child: pieceWidget(),
          ),
          child: pieceWidget(),
        ),
      ),
    );
  }

  /// Pemotongan potongan gambar
  Widget _buildPieceSlice({
    required int pieceIndex,
    required double pieceWidth,
    required double pieceHeight,
    required double boardWidth,
    required double boardHeight,
    required double opacity,
  }) {
    final r = pieceIndex ~/ cols;
    final c = pieceIndex % cols;

    final alignX = cols <= 1 ? 0.0 : -1.0 + (c * 2.0 / (cols - 1));
    final alignY = rows <= 1 ? 0.0 : -1.0 + (r * 2.0 / (rows - 1));

    return Opacity(
      opacity: opacity,
      child: SizedBox(
        width: pieceWidth,
        height: pieceHeight,
        child: OverflowBox(
          minWidth: boardWidth,
          maxWidth: boardWidth,
          minHeight: boardHeight,
          maxHeight: boardHeight,
          alignment: Alignment(alignX, alignY),
          child: Image.asset(
            imageAsset,
            fit: BoxFit.cover,
            width: boardWidth,
            height: boardHeight,
          ),
        ),
      ),
    );
  }
}

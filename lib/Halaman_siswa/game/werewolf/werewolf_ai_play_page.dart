import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../models/siswa_model.dart';
import '../game_coin_manager.dart';
import 'werewolf_models.dart';
import 'werewolf_words_data.dart';

/// Halaman Permainan Tebak Serigala (Wolf vs Sheep) Mode Lawan Bot AI.
/// Mengintegrasikan sistem role acak (1 Serigala, 4 Domba),
/// timer 15 detik pengisian ciri-ciri dengan opsi kunci jawaban atau kosong,
/// voting demokratis dengan profil pemilih di bawah nama,
/// dan siklus eliminasi bertahap hingga Serigala tertangkap atau mencapai 1 vs 1.
class WerewolfAiPlayPage extends StatefulWidget {
  final SiswaModel? siswa;
  final List<Map<String, dynamic>>? customLobbyPlayers;

  const WerewolfAiPlayPage({
    super.key,
    this.siswa,
    this.customLobbyPlayers,
  });

  @override
  State<WerewolfAiPlayPage> createState() => _WerewolfAiPlayPageState();
}

class _WerewolfAiPlayPageState extends State<WerewolfAiPlayPage> {
  late WerewolfWordPair _currentWordPair;
  late List<WerewolfPlayer> _players;
  late WerewolfPlayer _humanPlayer;

  WerewolfPhase _phase = WerewolfPhase.revealCard;
  int _roundNumber = 1;
  bool _isCardRevealed = false;
  String? _selectedVoteTargetId;
  WerewolfPlayer? _lastEliminatedPlayer;
  WerewolfRole? _winningRole;

  // Timer 15 Detik untuk Fase Pengisian Ciri-Ciri
  Timer? _clueTimer;
  int _clueSecondsRemaining = 15;

  // Timer Auto-Reveal Kartu (7 detik auto-buka, lalu countdown 15 detik)
  Timer? _revealAutoTimer;
  int _revealCountdownSeconds = 15;
  bool _revealTimerStarted = false;

  // Status Aksi Serigala Membunuh (1x per match)
  bool _hasUsedWolfKillInMatch = false;
  String? _selectedWolfKillTargetId;
  WerewolfPlayer? _wolfKilledVictim;

  // Timer 15 Detik untuk Fase Aksi Serigala (Memilih Mangsa)
  Timer? _wolfActionTimer;
  int _wolfActionSecondsRemaining = 15;

  // Timer 30 Detik untuk Sesi Voting Domba vs Serigala
  Timer? _votingTimer;
  int _votingSecondsRemaining = 30;

  // Menyimpan daftar siapa saja yang mem-vote setiap pemain di ronde ini
  Map<String, List<WerewolfPlayer>> _roundVoters = {};
  List<WerewolfPlayer> _roundCandidateList = [];

  final TextEditingController _clueInputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WerewolfWordsData.syncFromApi();
    _startNewGameSession();
  }

  @override
  void dispose() {
    _clueTimer?.cancel();
    _votingTimer?.cancel();
    _revealAutoTimer?.cancel();
    _wolfActionTimer?.cancel();
    _clueInputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Memulai sesi permainan baru dengan pemilihan role & kata yang sepenuhnya acak
  void _startNewGameSession() {
    _clueTimer?.cancel();
    _votingTimer?.cancel();
    _revealAutoTimer?.cancel();
    _revealTimerStarted = false;
    _revealCountdownSeconds = 15;
    _currentWordPair = WerewolfWordsData.getRandomPair();
    _roundNumber = 1;
    _phase = WerewolfPhase.revealCard;
    _isCardRevealed = false;
    _selectedVoteTargetId = null;
    _selectedWolfKillTargetId = null;
    _wolfKilledVictim = null;
    _hasUsedWolfKillInMatch = false;
    _lastEliminatedPlayer = null;
    _winningRole = null;
    _clueSecondsRemaining = 15;
    _votingSecondsRemaining = 30;
    _roundVoters = {};
    _roundCandidateList = [];
    _wolfActionTimer?.cancel();
    _wolfActionSecondsRemaining = 15;
    _clueInputController.clear();

    final random = Random();
    _players = [];

    if (widget.customLobbyPlayers != null && widget.customLobbyPlayers!.isNotEmpty) {
      // Skenario Mode Mabar (Room): Menggunakan pemain yang ada di Room
      final lobby = List<Map<String, dynamic>>.from(widget.customLobbyPlayers!);
      final totalCount = lobby.length;
      final wolfIndex = random.nextInt(totalCount);

      WerewolfPlayer? mainUser;

      for (int i = 0; i < totalCount; i++) {
        final item = lobby[i];
        final isWolf = (i == wolfIndex);
        final role = isWolf ? WerewolfRole.serigala : WerewolfRole.domba;
        final isBot = item['isBot'] == true;
        final word = isWolf ? _currentWordPair.serigalaWord : _currentWordPair.dombaWord;
        final meaning = isWolf ? _currentWordPair.serigalaMeaning : _currentWordPair.dombaMeaning;

        final player = WerewolfPlayer(
          id: 'p_${i + 1}',
          name: item['name'] as String? ?? 'Pemain ${i + 1}',
          avatarEmoji: item['emoji'] as String? ?? '👤',
          avatarColor: item['color'] as Color? ?? const Color(0xFF6366F1),
          isBot: isBot,
          role: role,
          word: word,
          meaning: meaning,
        );

        if (!isBot && mainUser == null) {
          mainUser = player;
        }
        _players.add(player);
      }

      _humanPlayer = mainUser ?? _players.first;
    } else {
      // Skenario Default Single Player (Lawan Bot AI 10 Pemain)
      final humanName = widget.siswa?.namaLengkap.split(' ').first ?? 'Kamu';
      final botProfiles = [
        {'name': 'Budi', 'emoji': '🧑‍💻', 'color': const Color(0xFF3B82F6)},
        {'name': 'Siti', 'emoji': '👩‍🎓', 'color': const Color(0xFFEC4899)},
        {'name': 'Rizki', 'emoji': '😎', 'color': const Color(0xFFF59E0B)},
        {'name': 'Citra', 'emoji': '🎨', 'color': const Color(0xFF10B981)},
        {'name': 'Doni', 'emoji': '⚽', 'color': const Color(0xFF06B6D4)},
        {'name': 'Maya', 'emoji': '🌸', 'color': const Color(0xFF8B5CF6)},
        {'name': 'Rian', 'emoji': '🎸', 'color': const Color(0xFFEF4444)},
        {'name': 'Nabila', 'emoji': '📚', 'color': const Color(0xFF14B8A6)},
        {'name': 'Farhan', 'emoji': '🚀', 'color': const Color(0xFFF97316)},
      ];

      final wolfIndex = random.nextInt(10);

      // Human player (Index 0)
      final humanRole = (wolfIndex == 0) ? WerewolfRole.serigala : WerewolfRole.domba;
      _humanPlayer = WerewolfPlayer(
        id: 'p_human',
        name: humanName,
        avatarEmoji: '⭐',
        avatarColor: const Color(0xFF6366F1),
        isBot: false,
        role: humanRole,
        word: humanRole == WerewolfRole.serigala ? _currentWordPair.serigalaWord : _currentWordPair.dombaWord,
        meaning: humanRole == WerewolfRole.serigala ? _currentWordPair.serigalaMeaning : _currentWordPair.dombaMeaning,
      );
      _players.add(_humanPlayer);

      // 9 Bot Players
      for (int i = 0; i < botProfiles.length; i++) {
        final prof = botProfiles[i];
        final isWolf = (wolfIndex == (i + 1));
        final role = isWolf ? WerewolfRole.serigala : WerewolfRole.domba;
        _players.add(
          WerewolfPlayer(
            id: 'p_bot_${i + 1}',
            name: prof['name'] as String,
            avatarEmoji: prof['emoji'] as String,
            avatarColor: prof['color'] as Color,
            isBot: true,
            role: role,
            word: role == WerewolfRole.serigala ? _currentWordPair.serigalaWord : _currentWordPair.dombaWord,
            meaning: role == WerewolfRole.serigala ? _currentWordPair.serigalaMeaning : _currentWordPair.dombaMeaning,
          ),
        );
      }
    }

    setState(() {});

    // Otomatis mulai timer 15 detik sejak awal buka kartu (detik ke-7 kartu buka sendiri)
    _startRevealCountdown();
  }

  List<WerewolfPlayer> get _alivePlayers => _players.where((p) => p.isAlive).toList();

  /// Memulai countdown timer 15 detik untuk pengisian ciri-ciri
  /// Mulai hitung mundur 15 detik untuk fase buka kartu.
  /// Pada detik ke-7 (8 detik berlalu), kartu otomatis terbuka.
  /// Saat mencapai 0, otomatis masuk fase input ciri-ciri.
  void _startRevealCountdown() {
    if (_revealTimerStarted) return;
    _revealTimerStarted = true;
    _revealCountdownSeconds = 15;
    _revealAutoTimer?.cancel();

    _revealAutoTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_revealCountdownSeconds > 1) {
        setState(() {
          _revealCountdownSeconds--;
        });

        // Auto-reveal kartu pada detik ke-7 (setelah 8 detik berlalu)
        if (_revealCountdownSeconds == 7 && !_isCardRevealed) {
          setState(() {
            _isCardRevealed = true;
          });
        }
      } else {
        timer.cancel();
        setState(() {
          _revealCountdownSeconds = 0;
        });
        // Otomatis masuk ke fase input clue ketika countdown habis
        _onRevealTimerFinished();
      }
    });
  }

  /// Dipanggil saat reveal timer selesai (0 detik) -> pindah ke input clue
  void _onRevealTimerFinished() {
    _revealAutoTimer?.cancel();
    if (!_isCardRevealed) {
      _isCardRevealed = true;
    }
    setState(() {
      _phase = WerewolfPhase.inputClue;
    });
    _startClueTimer();
  }

  void _startClueTimer() {
    _clueTimer?.cancel();
    _clueSecondsRemaining = 15;
    _clueTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_clueSecondsRemaining > 1) {
        setState(() {
          _clueSecondsRemaining--;
        });
      } else {
        timer.cancel();
        setState(() {
          _clueSecondsRemaining = 0;
        });
        _handleClueTimeExpired();
      }
    });
  }

  /// Waktu 15 detik habis: jika belum diisi, otomatis isi kosong '-'
  void _handleClueTimeExpired() {
    final currentText = _clueInputController.text.trim();
    final clueToUse = currentText.isNotEmpty ? currentText : '-';
    _processClueSubmission(clueToUse, wasTimeout: true);
  }

  /// Dialog konfirmasi untuk mengunci jawaban atau lanjut mengedit
  void _showLockClueConfirmationDialog() {
    final text = _clueInputController.text.trim();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: Color(0xFF334155)),
        ),
        title: Row(
          children: [
            const Text('🔒', style: TextStyle(fontSize: 22)),
            const SizedBox(width: 10),
            Text(
              'Kunci Jawaban?',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text.isNotEmpty
                  ? 'Ciri-ciri yang kamu tulis:'
                  : 'Kamu belum mengisi ciri-ciri (akan dikirim kosong):',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: const Color(0xFF94A3B8),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF475569)),
              ),
              child: Text(
                text.isNotEmpty ? '"$text"' : '-(Kosong)',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: text.isNotEmpty ? const Color(0xFFFCD34D) : const Color(0xFF64748B),
                  fontStyle: text.isNotEmpty ? FontStyle.normal : FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Apakah kamu yakin ingin mengunci jawaban ini sekarang?',
              style: GoogleFonts.poppins(
                fontSize: 11.5,
                color: const Color(0xFFCBD5E1),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // Tidak kunci, kembali mengedit
            },
            child: Text(
              'Ubah Lagi',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _processClueSubmission(text.isNotEmpty ? text : '-');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              'Ya, Kunci Jawaban!',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Proses penyimpanan ciri-ciri dan transisi ke fase membaca
  void _processClueSubmission(String clueText, {bool wasTimeout = false}) {
    _clueTimer?.cancel();

    // Simpan ciri-ciri pemain manusia
    _humanPlayer.currentClue = clueText;
    _humanPlayer.clueHistory.add(clueText);
    _clueInputController.clear();

    // Generate ciri-ciri unik dan bervariasi untuk bot AI yang masih hidup (hingga 9 bot)
    final random = Random();
    final dombaPool = List<String>.from(_currentWordPair.botDombaClues);
    dombaPool.addAll([
      'It relates to ${_currentWordPair.theme.toLowerCase()} and is commonly found in daily life.',
      'You can easily recognize it by its unique qualities and purpose.',
      'It is widely used and well-known among students and teachers.',
      'In English class, we often describe this by its characteristics.',
      'I can say it is very popular and everyone has seen or used it.',
    ]);
    dombaPool.shuffle(random);

    final serigalaPool = List<String>.from(_currentWordPair.botSerigalaClues);
    serigalaPool.addAll([
      'It has something to do with the general category and sounds very familiar.',
      'I believe it shares similar qualities with other items in this theme.',
      'It is widely enjoyed and has a recognizable feature.',
    ]);
    serigalaPool.shuffle(random);

    int dombaClueIdx = 0;
    int serigalaClueIdx = 0;

    for (final player in _alivePlayers) {
      if (player.isBot) {
        String botClue;
        if (player.isDomba) {
          botClue = dombaPool[dombaClueIdx % dombaPool.length];
          dombaClueIdx++;
        } else {
          botClue = serigalaPool[serigalaClueIdx % serigalaPool.length];
          serigalaClueIdx++;
        }
        player.currentClue = botClue;
        player.clueHistory.add(botClue);
      }
    }

    if (wasTimeout && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⏱️ Waktu 15 detik habis! Jawaban otomatis dikunci.'),
          backgroundColor: Color(0xFFF59E0B),
          duration: Duration(seconds: 2),
        ),
      );
    }

    setState(() {
      _phase = WerewolfPhase.readingClues;
    });
  }

  /// Lanjut dari membaca ciri-ciri:
  /// Jika Serigala belum menggunakan aksi bunuh di match ini, masuk ke fase Aksi Serigala.
  /// Jika sudah terpakai, langsung masuk ke fase Voting dengan waktu 30 detik.
  void _proceedFromReadingClues() {
    if (!_hasUsedWolfKillInMatch && _alivePlayers.length > 2) {
      _startWolfActionPhase();
    } else {
      _startVotingPhase();
    }
  }

  /// Memulai Fase Aksi Rahasia Serigala (POV Serigala / Malam)
  void _startWolfActionPhase() {
    _selectedWolfKillTargetId = null;
    _wolfKilledVictim = null;
    _wolfActionTimer?.cancel();
    _wolfActionSecondsRemaining = 15;

    if (!_humanPlayer.isSerigala) {
      // Jika pemain manusia adalah Domba (Serigala adalah bot),
      // bot serigala secara cerdas memangsa salah satu bot domba yang masih hidup
      final botDombaAlive = _alivePlayers.where((p) => p.isBot && p.isDomba).toList();
      if (botDombaAlive.isNotEmpty) {
        final victim = botDombaAlive[Random().nextInt(botDombaAlive.length)];
        victim.isAlive = false;
        victim.isKilledByWolf = true;
        _wolfKilledVictim = victim;
        _hasUsedWolfKillInMatch = true;
      }
    } else {
      // Jika pemain manusia adalah Serigala (POV Serigala), mulai timer 15 detik untuk memilih mangsa
      _startWolfActionTimer();
    }

    setState(() {
      _phase = WerewolfPhase.wolfAction;
    });
  }

  /// Timer 15 Detik untuk Serigala Memilih Mangsa
  void _startWolfActionTimer() {
    _wolfActionTimer?.cancel();
    _wolfActionSecondsRemaining = 15;

    _wolfActionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_wolfActionSecondsRemaining > 1) {
        setState(() {
          _wolfActionSecondsRemaining--;
        });
      } else {
        timer.cancel();
        setState(() {
          _wolfActionSecondsRemaining = 0;
        });
        _handleWolfActionTimeout();
      }
    });
  }

  /// Jika waktu 15 detik Serigala habis, sistem otomatis memilihkan mangsa acak
  void _handleWolfActionTimeout() {
    _wolfActionTimer?.cancel();
    if (_wolfKilledVictim != null) return; // Sudah memangsa

    final validTargets = _alivePlayers.where((p) => p.id != _humanPlayer.id && p.isAlive).toList();
    if (validTargets.isNotEmpty) {
      final victim = validTargets[Random().nextInt(validTargets.length)];
      setState(() {
        victim.isAlive = false;
        victim.isKilledByWolf = true;
        _wolfKilledVictim = victim;
        _hasUsedWolfKillInMatch = true;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('⏱️ Waktu memilih mangsa habis! ${victim.name} otomatis diterkam.'),
            backgroundColor: const Color(0xFFEF4444),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  /// Eksekusi pembunuhan oleh Serigala (POV Pemain Manusia)
  void _executeHumanWolfKill() {
    _wolfActionTimer?.cancel();
    if (_selectedWolfKillTargetId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilihlah salah satu Domba untuk dimangsa!'),
          backgroundColor: Color(0xFFEF4444),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final target = _players.firstWhere((p) => p.id == _selectedWolfKillTargetId);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFFEF4444)),
          ),
          title: Row(
            children: [
              const Text('🩸', style: TextStyle(fontSize: 22)),
              const SizedBox(width: 8),
              Text(
                'Eksekusi Mangsa?',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          content: Text(
            'Apakah kamu yakin ingin memangsa ${target.name}? Pemain ini akan langsung tereliminasi dari permainan sebelum sesi voting!',
            style: GoogleFonts.poppins(
              fontSize: 12.5,
              color: const Color(0xFFCBD5E1),
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Batal',
                style: GoogleFonts.poppins(color: const Color(0xFF94A3B8), fontWeight: FontWeight.w600),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                setState(() {
                  target.isAlive = false;
                  target.isKilledByWolf = true;
                  _wolfKilledVictim = target;
                  _hasUsedWolfKillInMatch = true;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                'Ya, Terkam!',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Memulai sesi voting (Domba vs Serigala) dengan waktu 30 detik
  void _startVotingPhase() {
    _votingTimer?.cancel();
    _votingSecondsRemaining = 30;

    for (final p in _players) {
      p.votesReceived = 0;
    }
    _selectedVoteTargetId = null;

    setState(() {
      _phase = WerewolfPhase.voting;
    });

    _startVotingTimer();
  }

  /// Timer Countdown 30 Detik untuk Fase Voting
  void _startVotingTimer() {
    _votingTimer?.cancel();
    _votingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_votingSecondsRemaining > 1) {
        setState(() {
          _votingSecondsRemaining--;
        });
      } else {
        timer.cancel();
        setState(() {
          _votingSecondsRemaining = 0;
        });
        _handleVotingTimeExpired();
      }
    });
  }

  /// Penanganan saat waktu voting 30 detik habis
  void _handleVotingTimeExpired() {
    _votingTimer?.cancel();

    if (!_humanPlayer.isAlive) {
      _executeVoting();
      return;
    }

    // Jika siswa belum memilih sasaran sampai waktu habis, pilihkan 1 kandidat acak
    if (_selectedVoteTargetId == null) {
      final validTargets = _alivePlayers.where((p) => p.id != _humanPlayer.id).toList();
      if (validTargets.isNotEmpty) {
        final randomTarget = validTargets[Random().nextInt(validTargets.length)];
        _selectedVoteTargetId = randomTarget.id;
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('⏱️ Waktu voting 30 detik habis! Suaramu otomatis dikunci.'),
        backgroundColor: Color(0xFFEF4444),
        duration: Duration(seconds: 2),
      ),
    );

    _executeVoting();
  }

  /// Eksekusi voting pemain dan perhitungan suara bot AI
  void _executeVoting() {
    _votingTimer?.cancel();

    if (_humanPlayer.isAlive && _selectedVoteTargetId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilihlah salah satu pemain yang ingin kamu vote!'),
          backgroundColor: Color(0xFFF59E0B),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Simpan daftar kandidat aktif saat voting dimulai
    final aliveList = List<WerewolfPlayer>.from(_alivePlayers);
    _roundCandidateList = List<WerewolfPlayer>.from(aliveList);

    // Inisialisasi peta profil pemilih (voters map)
    _roundVoters = {};
    for (final p in aliveList) {
      p.votesReceived = 0;
      _roundVoters[p.id] = [];
    }

    // 1. Tambah vote dari pemain manusia jika masih hidup
    if (_humanPlayer.isAlive && _selectedVoteTargetId != null) {
      final humanTarget = _players.firstWhere((p) => p.id == _selectedVoteTargetId);
      humanTarget.votesReceived++;
      _roundVoters[humanTarget.id]?.add(_humanPlayer);
    }

    // 2. Generate vote cerdas & natural (AI Lebih Kalem, Tidak Tamat di Ronde 1!)
    final random = Random();
    for (final bot in aliveList) {
      if (!bot.isBot) continue;

      // Bot tidak boleh mem-vote dirinya sendiri
      final validTargets = aliveList.where((p) => p.id != bot.id).toList();
      if (validTargets.isEmpty) continue;

      WerewolfPlayer targetToVote;

      if (bot.isSerigala) {
        // Serigala cerdik: mengkambinghitamkan Domba lain
        final dombaTargets = validTargets.where((p) => p.isDomba).toList();
        if (dombaTargets.isNotEmpty) {
          // Ikut mendorong vote domba yang mulai dicurigai pemain lain untuk mengalihkan perhatian
          dombaTargets.sort((a, b) => b.votesReceived.compareTo(a.votesReceived));
          if (dombaTargets.first.votesReceived > 0 && random.nextBool()) {
            targetToVote = dombaTargets.first;
          } else {
            targetToVote = dombaTargets[random.nextInt(dombaTargets.length)];
          }
        } else {
          targetToVote = validTargets[random.nextInt(validTargets.length)];
        }
      } else {
        // Domba bot: AI Lebih Kalem & Bertahap
        // Ronde 1: Peluang curiga serigala hanya 16% (84% mencurigai domba lain, membagi suara)
        // Ronde 2: Curiga serigala naik ke 30%
        // Ronde 3: Curiga serigala naik ke 45%
        // Ronde 4+: Curiga serigala naik ke 58%
        double wolfSuspicionChance = 0.16;
        if (_roundNumber == 2) {
          wolfSuspicionChance = 0.30;
        } else if (_roundNumber == 3) {
          wolfSuspicionChance = 0.45;
        } else if (_roundNumber >= 4) {
          wolfSuspicionChance = 0.58;
        }

        final wolfTarget = validTargets.where((p) => p.isSerigala).firstOrNull;
        if (wolfTarget != null && random.nextDouble() < wolfSuspicionChance) {
          targetToVote = wolfTarget;
        } else {
          // Sebarkan tuduhan ke domba-domba lain secara alami agar terjadi perdebatan seru
          final otherSheep = validTargets.where((p) => !p.isSerigala).toList();
          if (otherSheep.isNotEmpty && random.nextDouble() < 0.85) {
            targetToVote = otherSheep[random.nextInt(otherSheep.length)];
          } else {
            targetToVote = validTargets[random.nextInt(validTargets.length)];
          }
        }
      }

      targetToVote.votesReceived++;
      _roundVoters[targetToVote.id]?.add(bot);
    }

    // Cari pemain yang mendapat vote terbanyak (dengan penanganan suara seri/tie)
    aliveList.sort((a, b) => b.votesReceived.compareTo(a.votesReceived));
    final maxVotes = aliveList.first.votesReceived;
    final topCandidates = aliveList.where((p) => p.votesReceived == maxVotes).toList();
    // Jika ada nilai seri, pilih salah satu di antara kandidat seri secara acak
    final eliminated = topCandidates[random.nextInt(topCandidates.length)];
    eliminated.isAlive = false;
    _lastEliminatedPlayer = eliminated;

    // Evaluasi Syarat Menang (Win Conditions)
    // 1. Jika yang tereliminasi adalah Serigala -> Domba Menang!
    if (eliminated.isSerigala) {
      _winningRole = WerewolfRole.domba;
      _distributeRewards();
      _phase = WerewolfPhase.eliminationResult;
      setState(() {});
      return;
    }

    // 2. Jika yang tereliminasi adalah Domba (Voting Salah Sasaran):
    // Cek jumlah pemain yang tersisa hidup
    final remainingAlive = _alivePlayers;
    final remainingWolves = remainingAlive.where((p) => p.isSerigala).length;
    final remainingSheep = remainingAlive.where((p) => p.isDomba).length;

    // Jika eliminasi berlanjut sampai hanya tersisa 1 Serigala dan 1 Domba (1 vs 1) -> Serigala Menang!
    if (remainingWolves >= remainingSheep && remainingAlive.length <= 2) {
      _winningRole = WerewolfRole.serigala;
      _distributeRewards();
      _phase = WerewolfPhase.eliminationResult;
      setState(() {});
      return;
    }

    // Voting salah sasaran dan permainan BELUM SELESAI -> Lanjut ke ronde berikutnya
    _winningRole = null;
    _phase = WerewolfPhase.eliminationResult;
    setState(() {});
  }

  /// Memberikan Koin dan EXP untuk SELURUH PEMAIN di akhir permainan
  /// Nilai disesuaikan dengan status MENANG vs KALAH
  void _distributeRewards() {
    final isDombaWin = _winningRole == WerewolfRole.domba;

    for (final player in _players) {
      final isWinner = (player.isDomba && isDombaWin) || (player.isSerigala && !isDombaWin);

      if (isWinner) {
        if (player.isSerigala) {
          player.earnedCoins = 250;
          player.earnedExp = 200;
        } else {
          player.earnedCoins = 200;
          player.earnedExp = 150;
        }
      } else {
        player.earnedCoins = 60;
        player.earnedExp = 50;
      }
    }

    // Tambahkan Koin & EXP ke akun siswa secara persisten
    GameCoinManager.addCoins(_humanPlayer.earnedCoins);
    GameCoinManager.addExp(_humanPlayer.earnedExp);
  }

  /// Lanjut ke ronde berikutnya
  void _nextRound() {
    _roundNumber++;
    _selectedVoteTargetId = null;
    _selectedWolfKillTargetId = null;
    _wolfKilledVictim = null;
    _lastEliminatedPlayer = null;
    _votingTimer?.cancel();
    _wolfActionTimer?.cancel();
    _votingSecondsRemaining = 30;
    _wolfActionSecondsRemaining = 15;

    if (!_humanPlayer.isAlive) {
      // Jika pemain manusia tereliminasi, bot AI tetap menghasilkan ciri-ciri baru,
      // dan siswa lanjut menonton sebagai observer / penonton investigasi
      final random = Random();
      final dombaPool = List<String>.from(_currentWordPair.botDombaClues);
      dombaPool.addAll([
        'It relates to ${_currentWordPair.theme.toLowerCase()} and is commonly found in daily life.',
        'You can easily recognize it by its unique qualities and purpose.',
        'It is widely used and well-known among students and teachers.',
      ]);
      dombaPool.shuffle(random);

      final serigalaPool = List<String>.from(_currentWordPair.botSerigalaClues);
      serigalaPool.shuffle(random);

      int dIdx = 0;
      int sIdx = 0;
      for (final player in _alivePlayers) {
        if (player.isBot) {
          final botClue = player.isDomba
              ? dombaPool[dIdx++ % dombaPool.length]
              : serigalaPool[sIdx++ % serigalaPool.length];
          player.currentClue = botClue;
          player.clueHistory.add(botClue);
        }
      }
      _phase = WerewolfPhase.readingClues;
    } else {
      _phase = WerewolfPhase.inputClue;
      _startClueTimer();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Latar Malam Misteri Elegan
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text(
              'Tebak Serigala',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            Text(
              'Ronde $_roundNumber • ${_alivePlayers.length} Pemain Tersisa',
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          // Saldo Koin
          ValueListenableBuilder<int>(
            valueListenable: GameCoinManager.coins,
            builder: (context, coins, _) {
              return Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🪙', style: TextStyle(fontSize: 13)),
                    const SizedBox(width: 5),
                    Text(
                      '$coins',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFFCD34D),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _buildCurrentPhaseContent(),
        ),
      ),
    );
  }

  Widget _buildCurrentPhaseContent() {
    switch (_phase) {
      case WerewolfPhase.revealCard:
        return _buildRevealCardView();
      case WerewolfPhase.inputClue:
        return _buildInputClueView();
      case WerewolfPhase.readingClues:
        return _buildReadingCluesView();
      case WerewolfPhase.wolfAction:
        return _buildWolfActionView();
      case WerewolfPhase.voting:
        return _buildVotingView();
      case WerewolfPhase.eliminationResult:
        return _buildEliminationResultView();
      case WerewolfPhase.gameOver:
        return _buildGameOverView();
    }
  }

  // ==========================================
  // FASE 1: Buka Kartu Rahasia (Role & Kata)
  // ==========================================
  Widget _buildRevealCardView() {
    // Warna timer dinamis
    final Color revealTimerColor = !_revealTimerStarted
        ? const Color(0xFF6366F1)
        : (_revealCountdownSeconds > 10
            ? const Color(0xFF10B981)
            : (_revealCountdownSeconds > 5 ? const Color(0xFFF59E0B) : const Color(0xFFEF4444)));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(22),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            'Kartu Rahasiamu',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _revealTimerStarted
                ? 'Waktu berjalan! Kartu terbuka otomatis pada detik ke-7. Hafalkan peranmu & bersiap!'
                : 'Ketuk kartu di bawah untuk membuka peran & kata rahasiamu. Timer 15 detik otomatis dimulai!',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12.5,
              color: const Color(0xFF94A3B8),
              height: 1.4,
            ),
          ),

          // Timer Countdown Bar (saat sudah dimulai)
          if (_revealTimerStarted) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: revealTimerColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: revealTimerColor, width: 1),
              ),
              child: Row(
                children: [
                  Icon(Icons.timer_outlined, size: 18, color: revealTimerColor),
                  const SizedBox(width: 8),
                  Text(
                    'Waktu Tersisa: ${_revealCountdownSeconds}s',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: revealTimerColor,
                    ),
                  ),
                  const Spacer(),
                  if (!_isCardRevealed)
                    Text(
                      'Kartu terbuka di 7s',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  if (_isCardRevealed)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '✓ Terbuka',
                        style: GoogleFonts.poppins(fontSize: 10, color: const Color(0xFF34D399), fontWeight: FontWeight.w600),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (_revealCountdownSeconds / 15.0).clamp(0.0, 1.0),
                minHeight: 5,
                backgroundColor: const Color(0xFF334155),
                valueColor: AlwaysStoppedAnimation<Color>(revealTimerColor),
              ),
            ),
          ],

          const SizedBox(height: 24),

          // Kartu Rahasia yang Dapat Dibalik (dengan Asset Gambar Presisi)
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 320),
              child: GestureDetector(
                onTap: () {
                  if (!_isCardRevealed) {
                    setState(() {
                      _isCardRevealed = true;
                    });
                  }
                  // Mulai timer saat kartu pertama kali diklik
                  _startRevealCountdown();
                },
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 450),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(
                        scale: Tween<double>(begin: 0.95, end: 1.0).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: _isCardRevealed
                      // === KARTU DEPAN (terbuka) ===
                      ? AspectRatio(
                          key: const ValueKey('card_front'),
                          aspectRatio: 1024 / 1536, // Rasio 2:3 presisi sesuai asset kartu
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                color: _humanPlayer.isSerigala
                                    ? const Color(0xFFEF4444)
                                    : const Color(0xFF10B981),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: (_humanPlayer.isSerigala
                                          ? const Color(0xFFEF4444)
                                          : const Color(0xFF10B981))
                                      .withValues(alpha: 0.38),
                                  blurRadius: 28,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  // Background: Asset kartu depan (pas rapih sesuai kotak)
                                  Image.asset(
                                    'assets/images/kartu depan.png',
                                    fit: BoxFit.fill,
                                  ),
                                  // Overlay warna sangat tipis sesuai role
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: _humanPlayer.isSerigala
                                            ? [
                                                const Color(0xFF7F1D1D).withValues(alpha: 0.08),
                                                const Color(0xFF991B1B).withValues(alpha: 0.03),
                                              ]
                                            : [
                                                const Color(0xFF065F46).withValues(alpha: 0.06),
                                                const Color(0xFF047857).withValues(alpha: 0.02),
                                              ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                  ),
                                  // Konten kartu tersusun rapi di dalam bingkai perak
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 26),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        // 1. Badge Role
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: _humanPlayer.isSerigala
                                                ? const Color(0xFF991B1B)
                                                : const Color(0xFF065F46),
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(
                                              color: _humanPlayer.isSerigala
                                                  ? const Color(0xFFFCA5A5)
                                                  : const Color(0xFF6EE7B7),
                                              width: 1,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(alpha: 0.15),
                                                blurRadius: 6,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(_humanPlayer.roleEmoji, style: const TextStyle(fontSize: 16)),
                                              const SizedBox(width: 6),
                                              Text(
                                                _humanPlayer.roleName.toUpperCase(),
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12.5,
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.white,
                                                  letterSpacing: 1.5,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // 2. Kata Bahasa Inggris & Arti (FittedBox agar tidak overflow)
                                        Column(
                                          children: [
                                            FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                _humanPlayer.word,
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 34,
                                                  fontWeight: FontWeight.w900,
                                                  color: const Color(0xFF0F172A),
                                                  letterSpacing: 2,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 3),
                                            Text(
                                              '(${_humanPlayer.meaning})',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF475569),
                                              ),
                                            ),
                                          ],
                                        ),

                                        // 3. Tema Kategori
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: _humanPlayer.isSerigala
                                                ? const Color(0xFFFEE2E2)
                                                : const Color(0xFFD1FAE5),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: _humanPlayer.isSerigala
                                                  ? const Color(0xFFFCA5A5)
                                                  : const Color(0xFF6EE7B7),
                                              width: 0.8,
                                            ),
                                          ),
                                          child: Text(
                                            'Kategori: ${_currentWordPair.theme}',
                                            style: GoogleFonts.poppins(
                                              fontSize: 11,
                                              color: _humanPlayer.isSerigala
                                                  ? const Color(0xFF991B1B)
                                                  : const Color(0xFF065F46),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),

                                        // 4. Deskripsi Panduan Peran
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF0F172A).withValues(alpha: 0.05),
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(
                                              color: const Color(0xFFCBD5E1).withValues(alpha: 0.6),
                                              width: 0.8,
                                            ),
                                          ),
                                          child: Text(
                                            _humanPlayer.isSerigala
                                                ? 'Kamu adalah Serigala! Berikan ciri-ciri mengecoh agar tidak tertangkap.'
                                                : 'Kamu adalah Domba! Temukan siapa serigala dari ciri-ciri yang mencurigakan.',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              fontSize: 10.5,
                                              color: const Color(0xFF334155),
                                              height: 1.35,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      // === KARTU BELAKANG (tertutup) ===
                      : AspectRatio(
                          key: const ValueKey('card_back'),
                          aspectRatio: 1024 / 1536, // Rasio 2:3 presisi sesuai asset kartu
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                color: const Color(0xFF6366F1).withValues(alpha: 0.6),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF6366F1).withValues(alpha: 0.35),
                                  blurRadius: 28,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  // Background: Asset kartu belakang (tampil utuh & pas tanpa terpotong)
                                  Image.asset(
                                    'assets/images/kartu belakang.png',
                                    fit: BoxFit.fill,
                                  ),
                                  // Overlay gradien halus di bagian bawah agar tombol ketuk terbaca
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    height: 120,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withValues(alpha: 0.65),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Tombol Petunjuk Buka Kartu di Bawah (tidak menutupi artwork tengah)
                                  Positioned(
                                    left: 20,
                                    right: 20,
                                    bottom: 20,
                                    child: Center(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF0F172A).withValues(alpha: 0.85),
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: const Color(0xFF818CF8).withValues(alpha: 0.7),
                                            width: 1.2,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFF6366F1).withValues(alpha: 0.35),
                                              blurRadius: 10,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.touch_app_rounded,
                                              color: Color(0xFFFCD34D),
                                              size: 17,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Ketuk untuk Membuka Kartu',
                                              style: GoogleFonts.poppins(
                                                fontSize: 11.5,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                                letterSpacing: 0.5,
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
                          ),
                        ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 36),

          // Tombol: Mulai Timer (jika belum diklik) atau Lanjut (jika sudah terbuka)
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                if (!_revealTimerStarted) {
                  // Belum klik kartu -> mulai timer & buka kartu
                  setState(() {
                    _isCardRevealed = true;
                  });
                  _startRevealCountdown();
                } else if (_isCardRevealed) {
                  // Sudah terbuka -> langsung masuk input clue (skip sisa timer)
                  _revealAutoTimer?.cancel();
                  _onRevealTimerFinished();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _revealTimerStarted
                    ? const Color(0xFF10B981)
                    : const Color(0xFF6366F1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: Text(
                _revealTimerStarted
                    ? (_isCardRevealed
                        ? 'Siap! Lanjut ke Ronde $_roundNumber ➔ (${_revealCountdownSeconds}s)'
                        : 'Menunggu kartu terbuka... (${_revealCountdownSeconds}s)')
                    : 'Mulai Ronde $_roundNumber (Waktu 15 Detik)',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // FASE 2: Form Pengisian Ciri-Ciri (Timer 15 Detik & Kunci Jawaban)
  // ==========================================
  Widget _buildInputClueView() {
    final isLowTime = _clueSecondsRemaining <= 5;
    final timerColor = isLowTime ? const Color(0xFFEF4444) : const Color(0xFF38BDF8);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Pengingat Kata & Timer 15 Detik
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isLowTime ? const Color(0xFFEF4444) : const Color(0xFF334155),
                width: isLowTime ? 1.8 : 1.0,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: _humanPlayer.isSerigala ? const Color(0xFF991B1B) : const Color(0xFF047857),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(_humanPlayer.roleEmoji, style: const TextStyle(fontSize: 22)),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kartumu: ${_humanPlayer.word} (${_humanPlayer.meaning})',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Peran: ${_humanPlayer.roleName}',
                            style: GoogleFonts.poppins(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: _humanPlayer.isSerigala ? const Color(0xFFF87171) : const Color(0xFF34D399),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Indikator Waktu 15 Detik
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: timerColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: timerColor),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.timer_rounded, size: 14, color: timerColor),
                          const SizedBox(width: 4),
                          Text(
                            '${_clueSecondsRemaining}s',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: timerColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Progress Bar Countdown
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: _clueSecondsRemaining / 15.0,
                    minHeight: 4,
                    backgroundColor: const Color(0xFF334155),
                    valueColor: AlwaysStoppedAnimation<Color>(timerColor),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ronde $_roundNumber: Berikan Ciri-Ciri',
                style: GoogleFonts.poppins(
                  fontSize: 16.5,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              Text(
                '⏱️ Batas 15 Detik',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: timerColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Tuliskan ciri-ciri kata di kartumu dalam Bahasa Inggris. Kunci jawabanmu sebelum waktu habis. Jika waktu habis, jawaban otomatis dikirim kosong.',
            style: GoogleFonts.poppins(
              fontSize: 11.5,
              color: const Color(0xFF94A3B8),
              height: 1.4,
            ),
          ),

          const SizedBox(height: 18),

          // Form Input Bebas
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF475569)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextField(
              controller: _clueInputController,
              maxLines: 4,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Tulis dalam bahasa Inggris (Contoh: Sweet, Yellow, Fruit)...',
                hintStyle: GoogleFonts.poppins(fontSize: 12.5, color: const Color(0xFF64748B)),
                border: InputBorder.none,
              ),
            ),
          ),

          const SizedBox(height: 22),

          // Tombol Tindakan: Kosongkan & Kunci Jawaban
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _clueInputController.clear();
                    },
                    icon: const Icon(Icons.clear_rounded, size: 16, color: Color(0xFF94A3B8)),
                    label: Text(
                      'Kosongkan',
                      style: GoogleFonts.poppins(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF475569)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: _showLockClueConfirmationDialog,
                    icon: const Icon(Icons.lock_rounded, size: 17, color: Colors.white),
                    label: Text(
                      'Kunci Jawaban 🔒',
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // FASE 3: Membaca Ciri-Ciri Seluruh Pemain
  // ==========================================
  Widget _buildReadingCluesView() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 14, 22, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ciri-Ciri Pemain (Ronde $_roundNumber)',
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Perhatikan ciri-ciri yang diberikan teman-temanmu. Siapa yang jawabannya kosong, mencurigakan, atau berbeda dari kata domba?',
                style: GoogleFonts.poppins(
                  fontSize: 11.5,
                  color: const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ),

        // Daftar Ciri-Ciri Tiap Pemain yang Masih Hidup
        Expanded(
          child: ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: _alivePlayers.length,
            separatorBuilder: (c, i) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final player = _alivePlayers[index];
              final isMe = player.id == _humanPlayer.id;
              final clueText = player.currentClue ?? '-';
              final isBlank = clueText.trim() == '-' || clueText.isEmpty;

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isMe ? const Color(0xFF1E1B4B) : const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isMe ? const Color(0xFF6366F1) : const Color(0xFF334155),
                    width: isMe ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: player.avatarColor.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                            border: Border.all(color: player.avatarColor, width: 1.5),
                          ),
                          child: Center(
                            child: Text(player.avatarEmoji, style: const TextStyle(fontSize: 16)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            isMe ? '${player.name} (Kamu)' : player.name,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isMe ? const Color(0xFFA5B4FC) : Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F172A),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Pemain #${index + 1}',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        isBlank ? '"- (Tidak memberikan ciri-ciri / Kosong)"' : '"$clueText"',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isBlank ? const Color(0xFFEF4444) : const Color(0xFFE2E8F0),
                          fontStyle: FontStyle.italic,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        // Tombol Lanjut ke Fase Berikutnya (Aksi Serigala atau Voting 30s)
        Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _proceedFromReadingClues,
              style: ElevatedButton.styleFrom(
                backgroundColor: (!_hasUsedWolfKillInMatch && _humanPlayer.isSerigala)
                    ? const Color(0xFFEF4444)
                    : const Color(0xFFF59E0B),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    (!_hasUsedWolfKillInMatch && _humanPlayer.isSerigala)
                        ? '🐺'
                        : ((!_hasUsedWolfKillInMatch) ? '🌙' : '🗳️'),
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      (!_hasUsedWolfKillInMatch && _humanPlayer.isSerigala)
                          ? 'Aksi Serigala: Pilih Mangsa 🐺'
                          : ((!_hasUsedWolfKillInMatch)
                              ? 'Malam Mencekam: Serigala Beraksi 🌙'
                              : 'Mulai Sesi Voting Domba vs Serigala (30s) 🗳️'),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: (!_hasUsedWolfKillInMatch && _humanPlayer.isSerigala)
                            ? Colors.white
                            : const Color(0xFF0F172A),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // FASE 4: Aksi Rahasia Serigala (Wolf Kill - 1x per match)
  // ==========================================
  Widget _buildWolfActionView() {
    final isHumanWolf = _humanPlayer.isSerigala;

    if (isHumanWolf) {
      // Tampilan untuk POV Serigala (Pemain Manusia adalah Serigala)
      final validTargets = _alivePlayers.where((p) => p.id != _humanPlayer.id).toList();

      return SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),

            // Header POV Serigala
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF450A0A), Color(0xFF1E293B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFEF4444), width: 1.5),
              ),
              child: Column(
                children: [
                  const Text('🐺🩸', style: TextStyle(fontSize: 44)),
                  const SizedBox(height: 8),
                  Text(
                    'POV SERIGALA: PILIH MANGSA!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFFFCA5A5),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Sebagai Serigala, setiap match kamu punya hak istimewa membunuh 1 pemain Domba secara rahasia! Pilih siapa yang ingin kamu mangsa sebelum sesi voting:',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: const Color(0xFFCBD5E1),
                      height: 1.4,
                    ),
                  ),
                  if (_wolfKilledVictim == null) ...[
                    const SizedBox(height: 12),
                    // Badge Timer Memilih Mangsa
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: (_wolfActionSecondsRemaining > 5
                            ? const Color(0xFFF59E0B)
                            : const Color(0xFFEF4444)).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: _wolfActionSecondsRemaining > 5
                              ? const Color(0xFFF59E0B)
                              : const Color(0xFFEF4444),
                          width: 1.2,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            size: 15,
                            color: _wolfActionSecondsRemaining > 5
                                ? const Color(0xFFFCD34D)
                                : const Color(0xFFFCA5A5),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Waktu Memilih Mangsa: ${_wolfActionSecondsRemaining}s',
                            style: GoogleFonts.poppins(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w800,
                              color: _wolfActionSecondsRemaining > 5
                                  ? const Color(0xFFFCD34D)
                                  : const Color(0xFFFCA5A5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: SizedBox(
                        width: 220,
                        child: LinearProgressIndicator(
                          value: (_wolfActionSecondsRemaining / 15.0).clamp(0.0, 1.0),
                          minHeight: 4.5,
                          backgroundColor: const Color(0xFF334155),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _wolfActionSecondsRemaining > 5
                                ? const Color(0xFFF59E0B)
                                : const Color(0xFFEF4444),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            if (_wolfKilledVictim != null) ...[
              // Pengumuman Target Berhasil Dieliminasi
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF7F1D1D).withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFEF4444), width: 1.5),
                ),
                child: Column(
                  children: [
                    const Text('💀', style: TextStyle(fontSize: 36)),
                    const SizedBox(height: 6),
                    Text(
                      '${_wolfKilledVictim!.name} Telah Dieliminasi!',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Pemain ini gugur sebelum voting. Tersisa ${_alivePlayers.length} pemain hidup! Sekarang menyamarlah di sesi voting untuk mengecoh domba lainnya!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 11.5,
                        color: const Color(0xFFFECACA),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _startVotingPhase,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🗳️', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Lanjut ke Sesi Voting (30s) ➔',
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              // Daftar Pilihan Domba untuk Dibunuh
              Text(
                'Pilih Domba Sasaran:',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFE2E8F0),
                ),
              ),
              const SizedBox(height: 10),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: validTargets.length,
                separatorBuilder: (c, i) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final target = validTargets[index];
                  final isSelected = target.id == _selectedWolfKillTargetId;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedWolfKillTargetId = target.id;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF7F1D1D) : const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isSelected ? const Color(0xFFEF4444) : const Color(0xFF475569),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: target.avatarColor.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                              border: Border.all(color: target.avatarColor, width: 1.5),
                            ),
                            child: Center(
                              child: Text(target.avatarEmoji, style: const TextStyle(fontSize: 20)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      target.name,
                                      style: GoogleFonts.poppins(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF059669).withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text('🐑 Domba', style: TextStyle(fontSize: 9.5, color: Color(0xFF6EE7B7))),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  target.currentClue?.trim() == '-'
                                      ? '-(Jawaban Kosong)'
                                      : '"${target.currentClue ?? '-'}"',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: const Color(0xFF94A3B8),
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected ? const Color(0xFFEF4444) : Colors.transparent,
                              border: Border.all(
                                color: isSelected ? const Color(0xFFEF4444) : const Color(0xFF64748B),
                                width: 2,
                              ),
                            ),
                            child: isSelected
                                ? const Icon(Icons.close_rounded, color: Colors.white, size: 18)
                                : null,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _selectedWolfKillTargetId != null ? _executeHumanWolfKill : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444),
                    disabledBackgroundColor: const Color(0xFF334155),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🩸', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _selectedWolfKillTargetId != null ? 'Terkam & Eliminasi Pemain Ini' : 'Pilih 1 Sasaran Domba',
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 16),
          ],
        ),
      );
    } else {
      // Tampilan POV Domba (Serigala adalah Bot AI)
      return SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // Ikon Malam & Serigala
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFEF4444), width: 2),
              ),
              child: const Center(
                child: Text('🌙🐺', style: TextStyle(fontSize: 32)),
              ),
            ),

            const SizedBox(height: 16),

            Text(
              'MALAM MENCEKAM...',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: const Color(0xFFF87171),
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 4),

            Text(
              'Ketika malam tiba dan para domba terlelap, terdengar lolongan misterius. Serigala yang menyamar telah melancarkan serangannya!',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: const Color(0xFF94A3B8),
                height: 1.4,
              ),
            ),

            const SizedBox(height: 24),

            // Kartu Korban yang Dimangsa
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF7F1D1D).withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFEF4444), width: 1.6),
              ),
              child: Column(
                children: [
                  const Text('💀🩸', style: TextStyle(fontSize: 38)),
                  const SizedBox(height: 8),
                  Text(
                    '${_wolfKilledVictim?.name ?? "Salah satu pemain"} Telah Dimangsa!',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Peran: Domba 🐑 (Tidak Bersalah)',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF6EE7B7),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Petunjuk terakhirnya: "${_wolfKilledVictim?.currentClue ?? '-'}"',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      color: const Color(0xFFE2E8F0),
                    ),
                  ),
                  const Divider(color: Color(0xFF991B1B), height: 20),
                  Text(
                    'Tersisa ${_alivePlayers.length} pemain yang masih bertahan.\nPara Domba harus bersatu untuk menemukan Serigala di sesi voting!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 11.5,
                      color: const Color(0xFFFCA5A5),
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Tombol Masuk ke Voting
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _startVotingPhase,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF59E0B),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('🗳️', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Mulai Sesi Voting Domba vs Serigala (30s)',
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0F172A),
                        ),
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

  // ==========================================
  // FASE 5: Layar Voting Pemain (Domba vs Serigala - 30 Detik)
  // ==========================================
  Widget _buildVotingView() {
    final isDomba = _humanPlayer.isDomba;

    // Warna timer dinamis sesuai sisa waktu (Hijau -> Kuning -> Merah)
    final Color timerColor = _votingSecondsRemaining > 15
        ? const Color(0xFF10B981)
        : (_votingSecondsRemaining > 5 ? const Color(0xFFF59E0B) : const Color(0xFFEF4444));

    return Column(
      children: [
        // Header Voting Antara Serigala dan Domba + Bar Timer 30 Detik
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text('⚔️', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Text(
                        'Voting: Domba vs Serigala',
                        style: GoogleFonts.poppins(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  // Badge Timer Countdown 30 Detik
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: timerColor.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: timerColor, width: 1.2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.timer_outlined, size: 14, color: timerColor),
                        const SizedBox(width: 5),
                        Text(
                          '${_votingSecondsRemaining}s',
                          style: GoogleFonts.poppins(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: timerColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Progress Bar Waktu 30 Detik
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (_votingSecondsRemaining / 30.0).clamp(0.0, 1.0),
                  minHeight: 5,
                  backgroundColor: const Color(0xFF334155),
                  valueColor: AlwaysStoppedAnimation<Color>(timerColor),
                ),
              ),
              const SizedBox(height: 8),

              // Banner Penjelasan Peran (Domba vs Serigala)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isDomba
                      ? const Color(0xFF064E3B).withValues(alpha: 0.5)
                      : const Color(0xFF450A0A).withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDomba ? const Color(0xFF059669) : const Color(0xFFDC2626),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Text(isDomba ? '🐑' : '🐺', style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isDomba
                            ? 'Kamu adalah DOMBA! Pilih pemain yang kamu curigai sebagai Serigala.'
                            : 'Kamu adalah SERIGALA! Menyamarlah & vote Domba untuk mengadu domba!',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDomba ? const Color(0xFFA7F3D0) : const Color(0xFFFECACA),
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Daftar Calon Pemain yang Bisa Di-vote
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            itemCount: _alivePlayers.length,
            separatorBuilder: (c, i) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final player = _alivePlayers[index];
              final isMe = player.id == _humanPlayer.id;
              final isSelected = player.id == _selectedVoteTargetId;

              return GestureDetector(
                onTap: isMe
                    ? null
                    : () {
                        setState(() {
                          _selectedVoteTargetId = player.id;
                        });
                      },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF7F1D1D).withValues(alpha: 0.8)
                        : (isMe ? const Color(0xFF1E293B).withValues(alpha: 0.6) : const Color(0xFF1E293B)),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFEF4444)
                          : (isMe ? const Color(0xFF334155) : const Color(0xFF475569)),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: player.avatarColor.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                          border: Border.all(color: player.avatarColor, width: 1.5),
                        ),
                        child: Center(
                          child: Text(player.avatarEmoji, style: const TextStyle(fontSize: 20)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isMe ? '${player.name} (Kamu - Tidak bisa vote diri sendiri)' : player.name,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: isMe ? const Color(0xFF64748B) : Colors.white,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              player.currentClue?.trim() == '-' ? '-(Jawaban Kosong)' : '"${player.currentClue ?? '-'}"',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: player.currentClue?.trim() == '-' ? const Color(0xFFEF4444) : const Color(0xFF94A3B8),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!isMe)
                        Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected ? const Color(0xFFEF4444) : Colors.transparent,
                            border: Border.all(
                              color: isSelected ? const Color(0xFFEF4444) : const Color(0xFF64748B),
                              width: 2,
                            ),
                          ),
                          child: isSelected
                              ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                              : null,
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Tombol Kirim Suara / Kunci Vote
        Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _selectedVoteTargetId != null ? _executeVoting : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                disabledBackgroundColor: const Color(0xFF334155),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.how_to_vote_rounded, size: 18, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _selectedVoteTargetId != null
                          ? 'Kunci & Hitung Suara Vote (${_votingSecondsRemaining}s)'
                          : 'Pilih 1 Pemain untuk Di-Vote (${_votingSecondsRemaining}s)',
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // FASE 5: Hasil Voting & Eliminasi Ronde
  // Menampilkan profil pemilih tepat di bawah nama kandidat!
  // ==========================================
  Widget _buildEliminationResultView() {
    final eliminated = _lastEliminatedPlayer;
    if (eliminated == null) return const SizedBox();

    final isSerigalaEliminated = eliminated.isSerigala;

    // Urutkan kandidat ronde ini berdasarkan jumlah suara terbanyak ke terkecil
    final candidates = List<WerewolfPlayer>.from(_roundCandidateList)
      ..sort((a, b) => b.votesReceived.compareTo(a.votesReceived));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 6),

          // Judul Utama
          Center(
            child: Column(
              children: [
                Text(
                  'Rekap Suara Ronde $_roundNumber',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Lihat siapa saja yang saling mencurigai dan mem-vote satu sama lain:',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 11.5,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Papan Rekap Suara Voting (Menampilkan Profil Pemilih di Bawah Nama!)
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: candidates.length,
            separatorBuilder: (c, i) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final candidate = candidates[index];
              final isEliminated = candidate.id == eliminated.id;
              final voters = _roundVoters[candidate.id] ?? [];

              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isEliminated
                      ? const Color(0xFF7F1D1D).withValues(alpha: 0.35)
                      : const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isEliminated ? const Color(0xFFEF4444) : const Color(0xFF334155),
                    width: isEliminated ? 1.8 : 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Baris Atas: Avatar, Nama Kandidat, Badge Status, & Jumlah Suara
                    Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: candidate.avatarColor.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                            border: Border.all(color: candidate.avatarColor, width: 1.5),
                          ),
                          child: Center(
                            child: Text(candidate.avatarEmoji, style: const TextStyle(fontSize: 18)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  candidate.id == _humanPlayer.id ? '${candidate.name} (Kamu)' : candidate.name,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (isEliminated) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEF4444).withValues(alpha: 0.25),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: const Color(0xFFEF4444)),
                                  ),
                                  child: Text(
                                    'TERELIMINASI',
                                    style: GoogleFonts.poppins(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFFFCA5A5),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: (candidate.votesReceived > 0)
                                ? const Color(0xFFEF4444).withValues(alpha: 0.2)
                                : const Color(0xFF334155).withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: (candidate.votesReceived > 0)
                                  ? const Color(0xFFEF4444)
                                  : const Color(0xFF475569),
                            ),
                          ),
                          child: Text(
                            '${candidate.votesReceived} Suara',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: (candidate.votesReceived > 0)
                                  ? const Color(0xFFFCA5A5)
                                  : const Color(0xFF94A3B8),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Profil yang Mem-vote di Bawah Nama Kandidat
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dipilih oleh: ',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF94A3B8),
                            ),
                          ),
                          const SizedBox(height: 6),
                          if (voters.isEmpty)
                            Text(
                              'Tidak ada yang mencurigai',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontStyle: FontStyle.italic,
                                color: const Color(0xFF64748B),
                              ),
                            )
                          else
                            Wrap(
                                spacing: 6,
                                runSpacing: 4,
                                children: voters.map((v) {
                                  final isVoterMe = v.id == _humanPlayer.id;
                                  return Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                                    decoration: BoxDecoration(
                                      color: v.avatarColor.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: v.avatarColor.withValues(alpha: 0.6)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(v.avatarEmoji, style: const TextStyle(fontSize: 11)),
                                        const SizedBox(width: 4),
                                        Text(
                                          isVoterMe ? 'Kamu' : v.name,
                                          style: GoogleFonts.poppins(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // Kartu Status Eliminasi & Penjelasan
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isSerigalaEliminated
                  ? const Color(0xFF065F46).withValues(alpha: 0.85)
                  : const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: isSerigalaEliminated ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                width: 1.8,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(eliminated.roleEmoji, style: const TextStyle(fontSize: 28)),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        isSerigalaEliminated
                            ? 'SERIGALA TERTANGKAP! 🎉'
                            : 'VOTING SALAH SASARAN! ⚠️',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: isSerigalaEliminated ? const Color(0xFF34D399) : const Color(0xFFFCD34D),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  isSerigalaEliminated
                      ? '${eliminated.name} adalah SERIGALA yang menyamar! Para Domba berhasil mengungkapnya!'
                      : '${eliminated.name} ternyata adalah DOMBA yang tidak bersalah! 🐑\n🐺 Serigala masih berkeliaran di antara kalian! Permainan berlanjut ke ronde berikutnya.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Tombol Lanjut Ronde atau Lihat Hasil Akhir
          if (_winningRole != null)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _phase = WerewolfPhase.gameOver;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Text(
                  'Lihat Ringkasan Kemenangan & Kosakata 🏆',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          else
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _nextRound,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF59E0B),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        'Lanjut ke Ronde ${_roundNumber + 1} (${_alivePlayers.length} Pemain Tersisa)',
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_rounded, color: Color(0xFF0F172A), size: 18),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ==========================================
  // FASE 7: Layar Kemenangan & Pembagian Koin/EXP Seluruh Pemain
  // ==========================================
  Widget _buildGameOverView() {
    final isDombaWin = _winningRole == WerewolfRole.domba;
    final didIWin = (_humanPlayer.isDomba && isDombaWin) || (_humanPlayer.isSerigala && !isDombaWin);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(22),
      child: Column(
        children: [
          // ============================================
          // CELEBRATION BANNER - Menang atau Kalah
          // ============================================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
            decoration: BoxDecoration(
              gradient: didIWin
                  ? const LinearGradient(
                      colors: [Color(0xFF065F46), Color(0xFF047857), Color(0xFF064E3B)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : const LinearGradient(
                      colors: [Color(0xFF450A0A), Color(0xFF7F1D1D), Color(0xFF1E293B)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: didIWin ? const Color(0xFF34D399) : const Color(0xFFF87171),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: didIWin
                      ? const Color(0xFF10B981).withValues(alpha: 0.3)
                      : const Color(0xFFEF4444).withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                // Celebration Emoji Row
                Text(
                  didIWin ? '🎉🏆🎊' : '😔💔',
                  style: const TextStyle(fontSize: 44),
                ),
                const SizedBox(height: 12),

                // Status Kamu (MENANG / KALAH)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                  decoration: BoxDecoration(
                    color: didIWin
                        ? Colors.white.withValues(alpha: 0.15)
                        : Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    didIWin ? '🎖️ KAMU MENANG!' : '❌ KAMU KALAH',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Tim Pemenang
                Text(
                  isDombaWin ? 'TIM DOMBA MENANG! 🐑' : 'SERIGALA MENANG! 🐺',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: isDombaWin ? const Color(0xFF6EE7B7) : const Color(0xFFFCA5A5),
                  ),
                ),
                const SizedBox(height: 6),

                // Pesan Motivasi
                Text(
                  didIWin
                      ? 'Luar biasa! Kamu berhasil memenangkan permainan ini bersama timmu! Pelajari kosakata barunya!'
                      : 'Jangan berkecil hati! Pelajari kosakatanya dan coba lagi di permainan berikutnya!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.85),
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 16),

                // Row Koin & EXP yang Didapatkan (Di dalam banner)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF59E0B).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.5)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🪙', style: TextStyle(fontSize: 18)),
                          const SizedBox(width: 6),
                          Text(
                            '+${_humanPlayer.earnedCoins}',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFFFCD34D),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.5)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('⚡', style: TextStyle(fontSize: 18)),
                          const SizedBox(width: 6),
                          Text(
                            '+${_humanPlayer.earnedExp} EXP',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFFA5B4FC),
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

          const SizedBox(height: 18),

          // Tabel Perolehan di bawah

          // TABEL PEROLEHAN KOIN & EXP SELURUH PEMAIN (5 PEMAIN)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text('🏅', style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 8),
                        Text(
                          'Perolehan Koin & EXP Pemain',
                          style: GoogleFonts.poppins(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF334155),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '10 Pemain',
                        style: GoogleFonts.poppins(fontSize: 10, color: const Color(0xFF94A3B8)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Setiap pemain memperoleh Koin & EXP sesuai kontribusi dan status menang/kalah:',
                  style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF94A3B8)),
                ),
                const SizedBox(height: 14),

                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _players.length,
                  separatorBuilder: (c, i) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final p = _players[index];
                    final isMe = p.id == _humanPlayer.id;
                    final isWinner = (p.isDomba && isDombaWin) || (p.isSerigala && !isDombaWin);

                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: isMe
                            ? const Color(0xFF6366F1).withValues(alpha: 0.15)
                            : const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isMe ? const Color(0xFF6366F1) : const Color(0xFF334155),
                          width: isMe ? 1.4 : 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: p.avatarColor.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(p.avatarEmoji, style: const TextStyle(fontSize: 16)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      isMe ? '${p.name} (Kamu)' : p.name,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: isMe ? const Color(0xFFA5B4FC) : Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(p.roleEmoji, style: const TextStyle(fontSize: 12)),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                  decoration: BoxDecoration(
                                    color: isWinner
                                        ? const Color(0xFF059669).withValues(alpha: 0.2)
                                        : const Color(0xFF64748B).withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    isWinner ? 'MENANG 🏆' : 'KALAH',
                                    style: GoogleFonts.poppins(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      color: isWinner ? const Color(0xFF34D399) : const Color(0xFF94A3B8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Chips Hadiah Koin & EXP
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('🪙', style: TextStyle(fontSize: 12)),
                                  const SizedBox(width: 4),
                                  Text(
                                    '+${p.earnedCoins}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFFFCD34D),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('⚡', style: TextStyle(fontSize: 12)),
                                  const SizedBox(width: 4),
                                  Text(
                                    '+${p.earnedExp} EXP',
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF818CF8),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Kartu Edukasi: Pengungkapan 2 Kata Berdampingan
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('📚', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    Text(
                      'Pelajaran Kosakata Hari Ini',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Perbandingan Kata
                Row(
                  children: [
                    // Kata Domba
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF064E3B),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            const Text('🐑 Kata Domba', style: TextStyle(fontSize: 10, color: Color(0xFF6EE7B7))),
                            const SizedBox(height: 4),
                            Text(
                              _currentWordPair.dombaWord,
                              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white),
                            ),
                            Text(
                              _currentWordPair.dombaMeaning,
                              style: GoogleFonts.poppins(fontSize: 11, color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Kata Serigala
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF450A0A),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            const Text('🐺 Kata Serigala', style: TextStyle(fontSize: 10, color: Color(0xFFFCA5A5))),
                            const SizedBox(height: 4),
                            Text(
                              _currentWordPair.serigalaWord,
                              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white),
                            ),
                            Text(
                              _currentWordPair.serigalaMeaning,
                              style: GoogleFonts.poppins(fontSize: 11, color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Penjelasan Edukasi Bahasa Inggris
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'English Difference:',
                        style: GoogleFonts.poppins(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFA5B4FC),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _currentWordPair.explanation,
                        style: GoogleFonts.poppins(
                          fontSize: 11.5,
                          color: const Color(0xFFCBD5E1),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // Tombol Aksi: Main Lagi / Keluar
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF475569)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(
                      'Kembali ke Menu',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _startNewGameSession,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: Text(
                      'Main Lagi 🔄',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

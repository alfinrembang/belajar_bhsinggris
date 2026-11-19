import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../models/siswa_model.dart';
import 'werewolf_ai_play_page.dart';

/// Halaman Room Multiplayer (Mabar) untuk Game Tebak Serigala (Wolf vs Sheep).
/// Memfasilitasi pembuatan room baru dengan kode 6 digit atau bergabung ke room teman.
class WerewolfRoomPage extends StatefulWidget {
  final SiswaModel? siswa;

  const WerewolfRoomPage({super.key, this.siswa});

  @override
  State<WerewolfRoomPage> createState() => _WerewolfRoomPageState();
}

class _WerewolfRoomPageState extends State<WerewolfRoomPage> {
  bool _isInLobby = false;
  bool _isHost = false;
  String _roomCode = '';

  final TextEditingController _joinCodeController = TextEditingController();
  List<Map<String, dynamic>> _lobbyPlayers = [];

  @override
  void dispose() {
    _joinCodeController.dispose();
    super.dispose();
  }

  /// Membuat room baru dengan kode 6 digit acak
  void _createRoom() {
    final random = Random();
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final code = 'WOLF${String.fromCharCodes(Iterable.generate(2, (_) => chars.codeUnitAt(random.nextInt(chars.length))))}';

    final myName = widget.siswa?.namaLengkap.split(' ').first ?? 'Host';

    setState(() {
      _isHost = true;
      _roomCode = code;
      _isInLobby = true;
      _lobbyPlayers = [
        {
          'name': myName,
          'emoji': '👑',
          'isHost': true,
          'isBot': false,
          'color': const Color(0xFF6366F1),
        },
      ];
    });
  }

  /// Bergabung ke room yang sudah ada
  void _joinRoom() {
    final code = _joinCodeController.text.trim().toUpperCase();
    if (code.isEmpty || code.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan kode room yang valid (contoh: WOLF77)!'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    final myName = widget.siswa?.namaLengkap.split(' ').first ?? 'Player';

    setState(() {
      _isHost = false;
      _roomCode = code;
      _isInLobby = true;
      // Simulasi room terisi pemain lain
      _lobbyPlayers = [
        {'name': 'Rian (Host)', 'emoji': '👑', 'isHost': true, 'isBot': false, 'color': const Color(0xFF3B82F6)},
        {'name': 'Nabila', 'emoji': '🌸', 'isHost': false, 'isBot': false, 'color': const Color(0xFFEC4899)},
        {'name': myName, 'emoji': '⭐', 'isHost': false, 'isBot': false, 'color': const Color(0xFF6366F1)},
      ];
    });
  }

  /// Tambahkan 1 Bot AI untuk mengisi slot kosong (maksimal 10 pemain)
  void _addBotToSlot() {
    if (_lobbyPlayers.length >= 10) return;

    final botNames = ['Budi', 'Siti', 'Rizki', 'Citra', 'Doni', 'Maya', 'Rian', 'Nabila', 'Farhan'];
    final botEmojis = ['🧑‍💻', '👩‍🎓', '😎', '🎨', '⚽', '🌸', '🎸', '📚', '🚀'];
    final botColors = [
      const Color(0xFF3B82F6),
      const Color(0xFFEC4899),
      const Color(0xFFF59E0B),
      const Color(0xFF10B981),
      const Color(0xFF06B6D4),
      const Color(0xFF8B5CF6),
      const Color(0xFFEF4444),
      const Color(0xFF14B8A6),
      const Color(0xFFF97316),
    ];

    // Cari nama bot yang belum ada di lobby
    final existingNames = _lobbyPlayers.map((p) => p['name'] as String).toSet();
    String chosenName = 'Bot Teman';
    String chosenEmoji = '🤖';
    Color chosenColor = const Color(0xFF10B981);

    for (int i = 0; i < botNames.length; i++) {
      final candidate = '${botNames[i]} (Bot)';
      if (!existingNames.contains(candidate)) {
        chosenName = candidate;
        chosenEmoji = botEmojis[i % botEmojis.length];
        chosenColor = botColors[i % botColors.length];
        break;
      }
    }

    setState(() {
      _lobbyPlayers.add({
        'name': chosenName,
        'emoji': chosenEmoji,
        'isHost': false,
        'isBot': true,
        'color': chosenColor,
      });
    });
  }

  /// Otomatis isi semua slot yang tersisa hingga penuh 10 pemain dengan Bot
  void _fillRemainingSlotsWithBots() {
    while (_lobbyPlayers.length < 10) {
      _addBotToSlot();
    }
  }

  /// Hapus bot dari slot
  void _removeBot(int index) {
    if (index >= 0 && index < _lobbyPlayers.length) {
      if (_lobbyPlayers[index]['isBot'] == true) {
        setState(() {
          _lobbyPlayers.removeAt(index);
        });
      }
    }
  }

  /// Mulai permainan setelah minimal 5 slot terkumpul (hingga 10 pemain)
  void _startGame() {
    if (_lobbyPlayers.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Minimal 5 pemain untuk memulai (Maksimal 10)! Tambahkan Bot atau ajak temanmu.'),
          backgroundColor: Color(0xFFF59E0B),
        ),
      );
      return;
    }

    // Masuk ke gameplay dengan susunan pemain dari Room Mabar
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => WerewolfAiPlayPage(
          siswa: widget.siswa,
          customLobbyPlayers: _lobbyPlayers,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () {
            if (_isInLobby) {
              setState(() {
                _isInLobby = false;
                _lobbyPlayers.clear();
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          _isInLobby ? 'Ruang Tunggu Room' : 'Room Mabar Serigala',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isInLobby ? _buildLobbyView() : _buildCreateJoinView(),
      ),
    );
  }

  // ==========================================
  // VIEW 1: Form Buat Room & Masuk Room
  // ==========================================
  Widget _buildCreateJoinView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(22),
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Text('🐺 vs 🐑', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text(
            'Main Bareng Teman Sekelas',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Buat room baru sebagai Host atau masukkan kode room dari temanmu untuk bermain bersama!',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12.5,
              color: const Color(0xFF94A3B8),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 32),

          // Card 1: Buat Room Baru
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Center(
                        child: Text('👑', style: TextStyle(fontSize: 22)),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Buat Room Baru',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Dapatkan kode 6 digit untuk dibagikan ke teman',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: const Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: _createRoom,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: Text(
                      'Buat Room Sekarang',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Card 2: Gabung Room
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Center(
                        child: Text('🔑', style: TextStyle(fontSize: 22)),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gabung Room Teman',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Masukkan 6 digit kode room yang diberikan host',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: const Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // TextField Kode
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFF475569)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: TextField(
                    controller: _joinCodeController,
                    textCapitalization: TextCapitalization.characters,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                    decoration: InputDecoration(
                      hintText: 'KODE ROOM (Contoh: WOLF77)',
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF64748B),
                        letterSpacing: 0,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: _joinRoom,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: Text(
                      'Gabung Room',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // VIEW 2: Lobi Tunggu Pemain (5 Slot)
  // ==========================================
  Widget _buildLobbyView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(22),
      child: Column(
        children: [
          // Banner Kode Room
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF312E81), Color(0xFF1E1B4B)],
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFF6366F1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'KODE ROOM:',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFA5B4FC),
                      ),
                    ),
                    Text(
                      _roomCode,
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 3,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: _roomCode));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Kode room disalin ke clipboard!'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  icon: const Icon(Icons.copy_rounded, size: 16),
                  label: const Text('Salin'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Header Slot Pemain (X / 10)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pemain (${_lobbyPlayers.length}/10)',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              if (_isHost && _lobbyPlayers.length < 10)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton.icon(
                      onPressed: _addBotToSlot,
                      icon: const Icon(Icons.add_rounded, size: 15, color: Color(0xFF38BDF8)),
                      label: Text(
                        '+ Bot',
                        style: GoogleFonts.poppins(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF38BDF8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    ElevatedButton.icon(
                      onPressed: _fillRemainingSlotsWithBots,
                      icon: const Icon(Icons.flash_on_rounded, size: 14),
                      label: Text(
                        'Penuhi Slot',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        minimumSize: Size.zero,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
            ],
          ),

          const SizedBox(height: 12),

          // 5 Slot List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 10,
            separatorBuilder: (c, i) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              if (index < _lobbyPlayers.length) {
                final player = _lobbyPlayers[index];
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: (player['color'] as Color).withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(player['emoji'] as String, style: const TextStyle(fontSize: 18)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              player['name'] as String,
                              style: GoogleFonts.poppins(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              player['isHost'] == true ? 'Host Room' : 'Pemain Siap',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: player['isHost'] == true ? const Color(0xFFFCD34D) : const Color(0xFF34D399),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (player['isBot'] == true && _isHost)
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline_rounded, color: Color(0xFFEF4444), size: 20),
                          onPressed: () => _removeBot(index),
                          tooltip: 'Hapus Bot',
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        )
                      else
                        const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 20),
                    ],
                  ),
                );
              } else {
                // Slot Kosong
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B).withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFF334155), style: BorderStyle.solid),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF334155).withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(Icons.person_add_rounded, color: Color(0xFF64748B), size: 18),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Menunggu Pemain #${index + 1}...',
                        style: GoogleFonts.poppins(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),

          const SizedBox(height: 28),

          // Tombol Mulai Permainan
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _lobbyPlayers.length >= 5 ? _startGame : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                disabledBackgroundColor: const Color(0xFF334155),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: Text(
                _lobbyPlayers.length >= 5
                    ? 'Mulai Permainan 🎮 (${_lobbyPlayers.length}/10 Pemain)'
                    : 'Menunggu ${5 - _lobbyPlayers.length} Pemain Lagi (Min. 5, Maks. 10)',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

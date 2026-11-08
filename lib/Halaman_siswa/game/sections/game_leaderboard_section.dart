import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../models/siswa_model.dart';
import '../../../../services/api_service.dart';

/// Model Data Pemain Top Skor Leaderboard
class LeaderboardPlayer {
  final int rank;
  final String id;
  final String name;
  final String kelas;
  final String noAbsen;
  final int totalScore;
  final int fishingScore;
  final int puzzleScore;
  final int koin;
  final String status;
  final Color avatarColor;

  const LeaderboardPlayer({
    required this.rank,
    required this.id,
    required this.name,
    required this.kelas,
    required this.noAbsen,
    required this.totalScore,
    required this.fishingScore,
    required this.puzzleScore,
    required this.koin,
    required this.status,
    required this.avatarColor,
  });

  factory LeaderboardPlayer.fromJson(Map<String, dynamic> json, int defaultRank) {
    final r = (json['rank'] is num) ? (json['rank'] as num).toInt() : defaultRank;
    Color pickColor(int rank) {
      if (rank == 1) return const Color(0xFF0284C7); // Biru Samudra
      if (rank == 2) return const Color(0xFF7C3AED); // Ungu / Violet
      if (rank == 3) return const Color(0xFF059669); // Emerald Mint
      return const Color(0xFF64748B);
    }

    return LeaderboardPlayer(
      rank: r,
      id: json['id']?.toString() ?? '',
      name: json['nama']?.toString() ?? json['name']?.toString() ?? 'Siswa',
      kelas: json['kelas']?.toString() ?? 'XII RPL 1',
      noAbsen: json['no_absen']?.toString() ?? '-',
      totalScore: (json['total_skor'] ?? json['total_score'] ?? 0) is num
          ? (json['total_skor'] ?? json['total_score'] as num).toInt()
          : (int.tryParse((json['total_skor'] ?? json['total_score'])?.toString() ?? '') ?? 0),
      fishingScore: (json['skor_memancing'] ?? 0) is num
          ? (json['skor_memancing'] as num).toInt()
          : (int.tryParse(json['skor_memancing']?.toString() ?? '') ?? 0),
      puzzleScore: (json['puzzle_selesai'] ?? 0) is num
          ? (json['puzzle_selesai'] as num).toInt()
          : (int.tryParse(json['puzzle_selesai']?.toString() ?? '') ?? 0),
      koin: (json['koin'] ?? 120) is num
          ? (json['koin'] as num).toInt()
          : (int.tryParse(json['koin']?.toString() ?? '') ?? 120),
      status: json['status']?.toString() ?? 'Pemain Berbakat ⭐',
      avatarColor: pickColor(r),
    );
  }

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return 'S';
    if (parts.length == 1) return parts[0].substring(0, min(2, parts[0].length)).toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  String get shortName {
    final parts = name.trim().split(RegExp(r'\s+'));
    return parts.first;
  }
}

/// Section Podium Leaderboard Top 3 Skor Siswa.
/// Data bersumber dinamis dari API Laravel (/api/game/leaderboard),
/// dan saat kartu top skor diklik, akan muncul menu kecil berisi informasi detail pemain.
class GameLeaderboardSection extends StatefulWidget {
  final SiswaModel? siswa;
  final VoidCallback? onPodiumTap;

  const GameLeaderboardSection({
    super.key,
    this.siswa,
    this.onPodiumTap,
  });

  @override
  State<GameLeaderboardSection> createState() => _GameLeaderboardSectionState();
}

class _GameLeaderboardSectionState extends State<GameLeaderboardSection> {
  // Pemain Default Realistis (Fallback instan saat offline)
  static const List<LeaderboardPlayer> _defaultPlayers = [
    LeaderboardPlayer(
      rank: 1,
      id: '101',
      name: 'Budi Pratama',
      kelas: 'XII RPL 1',
      noAbsen: '14',
      totalScore: 2450,
      fishingScore: 1250,
      puzzleScore: 8,
      koin: 240,
      status: 'Ocean Master & Puzzle Solver 👑',
      avatarColor: Color(0xFF0284C7),
    ),
    LeaderboardPlayer(
      rank: 2,
      id: '102',
      name: 'Siti Rahma',
      kelas: 'XII RPL 1',
      noAbsen: '28',
      totalScore: 2100,
      fishingScore: 1050,
      puzzleScore: 7,
      koin: 210,
      status: 'Vocab Hunter Tangguh 🐠',
      avatarColor: Color(0xFF7C3AED),
    ),
    LeaderboardPlayer(
      rank: 3,
      id: '103',
      name: 'Ahmad Rizki',
      kelas: 'XII RPL 2',
      noAbsen: '05',
      totalScore: 1890,
      fishingScore: 950,
      puzzleScore: 6,
      koin: 180,
      status: 'Penjelajah Samudra 🌊',
      avatarColor: Color(0xFF059669),
    ),
  ];

  List<LeaderboardPlayer> _players = List.from(_defaultPlayers);
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchLeaderboard();
  }

  /// Memuat data top skor leaderboard secara dinamis dari API backend
  Future<void> _fetchLeaderboard() async {
    try {
      final res = await ApiService.getGameLeaderboard();
      if (!mounted) return;

      if (res['success'] == true && res['data'] is List && (res['data'] as List).isNotEmpty) {
        final list = (res['data'] as List).asMap().entries.map((entry) {
          return LeaderboardPlayer.fromJson(
            Map<String, dynamic>.from(entry.value),
            entry.key + 1,
          );
        }).toList();

        setState(() {
          _players = list;
          _isLoading = false;
        });
      }
    } catch (_) {
      // Tetap gunakan default players jika offline
    }
  }

  @override
  Widget build(BuildContext context) {
    final rank1 = _getPlayerByRank(1);
    final rank2 = _getPlayerByRank(2);
    final rank3 = _getPlayerByRank(3);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Juara 2 (Kiri - Kartu Putih Avatar Ungu)
              _buildSidePodium(
                player: rank2,
                rank: 2,
                avatarGradient: const [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
                height: 114,
                width: 82,
              ),

              const SizedBox(width: 10),

              // Juara 1 (Tengah - Kartu Biru Menjulang Tinggi dengan Mahkota Emas)
              _buildCenterPodium(
                player: rank1,
                rank: 1,
                avatarGradient: const [Color(0xFF38BDF8), Color(0xFF0284C7)],
                height: 140,
                width: 94,
              ),

              const SizedBox(width: 10),

              // Juara 3 (Kanan - Kartu Putih Avatar Hijau)
              _buildSidePodium(
                player: rank3,
                rank: 3,
                avatarGradient: const [Color(0xFF10B981), Color(0xFF047857)],
                height: 106,
                width: 82,
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // Tombol / Petunjuk Interaktif: "Lihat Papan Peringkat Lengkap"
        GestureDetector(
          onTap: () => _showAllLeaderboardModal(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF0284C7).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  size: 13,
                  color: Color(0xFF0284C7),
                ),
                const SizedBox(width: 5),
                Text(
                  'Ketuk skor untuk info pemain • Peringkat Lengkap',
                  style: GoogleFonts.poppins(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0284C7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  LeaderboardPlayer _getPlayerByRank(int rank) {
    return _players.firstWhere(
      (p) => p.rank == rank,
      orElse: () => _defaultPlayers[rank - 1],
    );
  }

  // Builder Kartu Juara 1 (Paling Tinggi + Mahkota Emas + Data Dinamis)
  Widget _buildCenterPodium({
    required LeaderboardPlayer player,
    required int rank,
    required List<Color> avatarGradient,
    required double height,
    required double width,
  }) {
    return GestureDetector(
      onTap: () => _showPlayerDetailModal(context, player),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // Kartu Utama Biru Royal
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF3366CC),
                  Color(0xFF2856BA),
                  Color(0xFF1E48A8),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2554C7).withValues(alpha: 0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),

                // Lingkaran Avatar Biru Chibi dengan Inisial Siswa
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: avatarGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFFFD700),
                      width: 2.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.18),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      player.initials,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                // Nama Panggilan Pemain
                Text(
                  player.shortName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 2),

                // Skor Dinamis Poin (Anti Dummy)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${player.totalScore} pts',
                    maxLines: 1,
                    style: GoogleFonts.poppins(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFFFE033),
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Mahkota Emas Berada di Puncak Kartu
          Positioned(
            top: -24,
            child: CustomPaint(
              size: const Size(48, 28),
              painter: _GoldenCrownPainter(),
            ),
          ),
        ],
      ),
    );
  }

  // Builder Kartu Juara 2 & 3 (Samping + Data Dinamis + Interaktif Klik)
  Widget _buildSidePodium({
    required LeaderboardPlayer player,
    required int rank,
    required List<Color> avatarGradient,
    required double height,
    required double width,
  }) {
    final badgeColor = rank == 2 ? const Color(0xFF7C3AED) : const Color(0xFF059669);

    return GestureDetector(
      onTap: () => _showPlayerDetailModal(context, player),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFF1F5F9),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withValues(alpha: 0.06),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lingkaran Avatar dengan Inisial Siswa
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: avatarGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 1.8,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  player.initials,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 5),

            // Nama Panggilan Pemain
            Text(
              player.shortName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1E293B),
              ),
            ),

            const SizedBox(height: 2),

            // Skor Dinamis Poin (Bukan Sekadar Kata "Skor")
            Text(
              '${player.totalScore} pts',
              maxLines: 1,
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: badgeColor,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Menu Kecil (Pop-up Modal): Menampilkan Informasi Lengkap dari Pemain Top Skor
  void _showPlayerDetailModal(BuildContext context, LeaderboardPlayer player) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final rankIcon = player.rank == 1
            ? '👑'
            : (player.rank == 2 ? '🥈' : (player.rank == 3 ? '🥉' : '🎖️'));
        final rankTitle = player.rank == 1
            ? 'Juara 1 • Top Global'
            : (player.rank == 2
                ? 'Juara 2 • Runner Up'
                : (player.rank == 3 ? 'Juara 3 • Podium' : 'Peringkat #${player.rank}'));
        final accentColor = player.rank == 1
            ? const Color(0xFF0284C7)
            : (player.rank == 2 ? const Color(0xFF7C3AED) : const Color(0xFF059669));

        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(22, 14, 22, 26),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Garis Handle Modal
              Center(
                child: Container(
                  width: 44,
                  height: 4.5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Baris Header: Badge Peringkat & Tombol X
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: accentColor.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(rankIcon, style: const TextStyle(fontSize: 14)),
                        const SizedBox(width: 6),
                        Text(
                          rankTitle,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: accentColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Avatar Besar dengan Efek Glow & Mahkota
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 74,
                    height: 74,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          accentColor,
                          accentColor.withValues(alpha: 0.75),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: accentColor.withValues(alpha: 0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        player.initials,
                        style: GoogleFonts.poppins(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                  if (player.rank == 1)
                    const Positioned(
                      top: -14,
                      child: Text('👑', style: TextStyle(fontSize: 24)),
                    ),
                ],
              ),

              const SizedBox(height: 12),

              // Nama Lengkap Siswa
              Text(
                player.name,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
              ),

              const SizedBox(height: 4),

              // Kelas & Nomor Absen
              Text(
                '${player.kelas} • No. Absen ${player.noAbsen}',
                style: GoogleFonts.poppins(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
              ),

              const SizedBox(height: 8),

              // Status / Gelar Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4.5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  player.status,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFB45309),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Rincian Statistik Skor Game
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    // Total Skor Game
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text('🏆', style: TextStyle(fontSize: 16)),
                            const SizedBox(width: 8),
                            Text(
                              'Total Poin Game',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1E293B),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${player.totalScore} Pts',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF0284C7),
                          ),
                        ),
                      ],
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(height: 1),
                    ),

                    // Skor Tangkap Ikan
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text('🐠', style: TextStyle(fontSize: 15)),
                            const SizedBox(width: 8),
                            Text(
                              'Tangkap Ikan',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${player.fishingScore} Poin',
                          style: GoogleFonts.poppins(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Puzzle Master
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text('🧩', style: TextStyle(fontSize: 15)),
                            const SizedBox(width: 8),
                            Text(
                              'Puzzle Master',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${player.puzzleScore} Level Selesai',
                          style: GoogleFonts.poppins(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Koin Terkumpul
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text('🪙', style: TextStyle(fontSize: 15)),
                            const SizedBox(width: 8),
                            Text(
                              'Koin Reward',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${player.koin} Koin',
                          style: GoogleFonts.poppins(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFD97706),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Tombol Tutup Informasi
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0284C7),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    'Tutup Informasi',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Menampilkan Daftar Seluruh Papan Peringkat (Top 10)
  void _showAllLeaderboardModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(22),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(26),
            topRight: Radius.circular(26),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.emoji_events_rounded, color: Color(0xFFFFB800), size: 26),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Papan Peringkat Game',
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(ctx),
                  child: const Icon(Icons.close_rounded, size: 20, color: Color(0xFF64748B)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Ketuk salah satu siswa untuk melihat rincian informasi prestasinya.',
              style: GoogleFonts.poppins(
                fontSize: 11.5,
                color: const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 14),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.45,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: _players.length,
                separatorBuilder: (c, i) => const Divider(height: 12),
                itemBuilder: (c, index) {
                  final p = _players[index];
                  final badgeColor = p.rank == 1
                      ? const Color(0xFFFFB800)
                      : (p.rank == 2
                          ? const Color(0xFF94A3B8)
                          : (p.rank == 3 ? const Color(0xFFB45309) : const Color(0xFF64748B)));

                  return InkWell(
                    onTap: () {
                      Navigator.pop(ctx);
                      _showPlayerDetailModal(context, p);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                      child: Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: badgeColor.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${p.rank}',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: badgeColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.name,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1E293B),
                                  ),
                                ),
                                Text(
                                  p.kelas,
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: const Color(0xFF94A3B8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${p.totalScore} Pts',
                            style: GoogleFonts.poppins(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF0066D6),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFFCBD5E1)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

/// CustomPainter untuk menggambar mahkota emas yang identik dengan desain
class _GoldenCrownPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFFFDF00), Color(0xFFFFB300), Color(0xFFFFA000)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();
    // Bentuk dasar mahkota 3 puncak berlekuk
    path.moveTo(size.width * 0.15, size.height * 0.95);
    path.lineTo(size.width * 0.05, size.height * 0.35);
    path.lineTo(size.width * 0.32, size.height * 0.55);
    path.lineTo(size.width * 0.50, size.height * 0.08); // Puncak tengah paling tinggi
    path.lineTo(size.width * 0.68, size.height * 0.55);
    path.lineTo(size.width * 0.95, size.height * 0.35);
    path.lineTo(size.width * 0.85, size.height * 0.95);
    path.close();

    canvas.drawPath(path, paint);

    // Titik mutiara emas di setiap ujung mahkota
    final pearlPaint = Paint()..color = const Color(0xFFFFE033);
    canvas.drawCircle(Offset(size.width * 0.05, size.height * 0.32), 3, pearlPaint);
    canvas.drawCircle(Offset(size.width * 0.50, size.height * 0.08), 3.5, pearlPaint);
    canvas.drawCircle(Offset(size.width * 0.95, size.height * 0.32), 3, pearlPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

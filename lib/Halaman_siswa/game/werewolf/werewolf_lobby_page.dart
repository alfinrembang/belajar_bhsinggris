import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../models/siswa_model.dart';
import '../game_coin_manager.dart';
import 'werewolf_ai_play_page.dart';
import 'werewolf_room_page.dart';

/// Halaman Lobi Utama Game Tebak Serigala (Wolf vs Sheep).
/// Menyediakan pemilihan mode (Lawan Bot AI & Room Multiplayer) serta panduan cara bermain.
class WerewolfLobbyPage extends StatelessWidget {
  final SiswaModel? siswa;

  const WerewolfLobbyPage({super.key, this.siswa});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Tebak Serigala',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          // Saldo Koin Siswa
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
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Banner: Karakter Serigala & Domba
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF312E81), Color(0xFF1E1B4B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.6)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.25),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('🐑', style: TextStyle(fontSize: 48)),
                        SizedBox(width: 14),
                        Text('VS', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFFFCD34D))),
                        SizedBox(width: 14),
                        Text('🐺', style: TextStyle(fontSize: 48)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Wolf vs Sheep (Tebak Serigala)',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '5 Pemain, 1 Serigala menyamar! Berikan ciri-ciri dalam Bahasa Inggris dan temukan siapa serigalanya.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: const Color(0xFFCBD5E1),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              Text(
                'Pilih Mode Permainan',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),

              // Mode 1: Lawan Bot AI (Single Player)
              _buildModeCard(
                context: context,
                badge: '⚡ MAIN INSTAN',
                badgeColor: const Color(0xFF10B981),
                iconEmoji: '🤖',
                title: 'Lawan Bot AI (4 Teman Kelas)',
                description: 'Bermain langsung bersama Budi, Siti, Rizki, dan Citra. Cocok untuk mengasah kosakata kapan saja!',
                buttonText: 'Main Sekarang',
                buttonColor: const Color(0xFF6366F1),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WerewolfAiPlayPage(siswa: siswa),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // Mode 2: Room Multiplayer (Mabar)
              _buildModeCard(
                context: context,
                badge: '👥 MABAR 5 ORANG',
                badgeColor: const Color(0xFF38BDF8),
                iconEmoji: '🔑',
                title: 'Room Multiplayer (Mabar)',
                description: 'Buat room atau gabung dengan kode 6 digit untuk bermain seru bersama teman sekelasmu!',
                buttonText: 'Buka Menu Room',
                buttonColor: const Color(0xFF0284C7),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WerewolfRoomPage(siswa: siswa),
                    ),
                  );
                },
              ),

              const SizedBox(height: 26),

              // Panduan Singkat Aturan Permainan
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
                        const Text('📜', style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 8),
                        Text(
                          'Aturan & Cara Bermain',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildRuleRow('1', '4 Domba mendapat Kata A, 1 Serigala mendapat Kata B (Peran diacak!).'),
                    _buildRuleRow('2', 'Tulis 1 ciri-ciri kata di kartumu dalam Bahasa Inggris.'),
                    _buildRuleRow('3', 'Semua pemain membaca petunjuk dan melakukan voting Serigala.'),
                    _buildRuleRow('4', 'Domba Menang jika Serigala tertangkap dan di-vote keluar!'),
                    _buildRuleRow('5', 'Serigala Menang jika berhasil bertahan sampai tersisa 1 vs 1.'),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeCard({
    required BuildContext context,
    required String badge,
    required Color badgeColor,
    required String iconEmoji,
    required String title,
    required String description,
    required String buttonText,
    required Color buttonColor,
    required VoidCallback onTap,
  }) {
    return Container(
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
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: buttonColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(iconEmoji, style: const TextStyle(fontSize: 22)),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badge,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: badgeColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: GoogleFonts.poppins(
              fontSize: 11.5,
              color: const Color(0xFF94A3B8),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: Text(
                buttonText,
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
    );
  }

  Widget _buildRuleRow(String number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: const BoxDecoration(
              color: Color(0xFF334155),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(fontSize: 11.5, color: const Color(0xFFCBD5E1), height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}

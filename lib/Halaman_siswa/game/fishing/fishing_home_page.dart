import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../models/siswa_model.dart';
import '../../../../services/api_service.dart';
import '../../../../widgets/custom_button.dart';
import '../puzzle/game_coin_manager.dart';
import 'fishing_play_page.dart';
import 'fishing_how_to_play_dialog.dart';
import 'fishing_visuals.dart';

/// Halaman Utama / Lobby Game Memancing "Word Fishing"
/// Desain cerah, lucu, ramah anak, dan penuh warna (Sky Blue, Mint Green, Sun Gold).
class FishingHomePage extends StatefulWidget {
  final SiswaModel? siswa;

  const FishingHomePage({super.key, this.siswa});

  @override
  State<FishingHomePage> createState() => _FishingHomePageState();
}

class _FishingHomePageState extends State<FishingHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _bounceAnimation;
  List<Map<String, dynamic>> _fishLevels = [];
  int _caughtCount = 0;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: -4.0, end: 4.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    _loadProgress();
  }

  Future<void> _loadProgress() async {
    try {
      final res = await ApiService.getFishingProgres(
        siswaId: widget.siswa?.id,
        difficulty: 'mudah',
      );
      if (res['success'] == true && res['data'] is List) {
        final list = (res['data'] as List).map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e)).toList();
        final count = list.where((item) => item['is_completed'] == true).length;
        if (res['koin'] != null) {
          GameCoinManager.setCoins((res['koin'] as num).toInt());
        }
        if (mounted) {
          setState(() {
            _fishLevels = list;
            _caughtCount = count;
          });
        }
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _startPlayGame() async {
    await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (c, a, s) => FishingPlayPage(
          siswa: widget.siswa,
          level: 1,
        ),
        transitionDuration: const Duration(milliseconds: 350),
        transitionsBuilder: (c, a, s, child) => FadeTransition(opacity: a, child: child),
      ),
    );
    _loadProgress();
  }

  void _showAquariumModal() {
    final displayList = _fishLevels.isNotEmpty
        ? _fishLevels
        : [
            {'fish_name': 'Golden Carp', 'fish_indo': 'Ikan Mas Koki', 'fish_emoji': '🐟', 'is_completed': false},
            {'fish_name': 'Clownfish', 'fish_indo': 'Ikan Badut', 'fish_emoji': '🐠', 'is_completed': false},
            {'fish_name': 'Blue Marlin', 'fish_indo': 'Ikan Todak Biru', 'fish_emoji': '🐟', 'is_completed': false},
            {'fish_name': 'Electric Eel', 'fish_indo': 'Belut Listrik', 'fish_emoji': '⚡', 'is_completed': false},
            {'fish_name': 'Giant Salmon', 'fish_indo': 'Salmon Raksasa', 'fish_emoji': '👑', 'is_completed': false},
            {'fish_name': 'Rainbow Trout', 'fish_indo': 'Ikan Pelangi', 'fish_emoji': '🌈', 'is_completed': false},
          ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(ctx).size.height * 0.72,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            children: [
              Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F2FE),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.set_meal_rounded,
                            color: Color(0xFF0284C7), size: 22),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Akuarium Koleksi 🐠',
                            style: GoogleFonts.poppins(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            'Ikan dari database yang berhasil ditangkap',
                            style: GoogleFonts.poppins(
                              fontSize: 11.5,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$_caughtCount/${displayList.length} Tertangkap',
                      style: GoogleFonts.poppins(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFD97706),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(color: Color(0xFFF1F5F9)),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: displayList.length,
                  itemBuilder: (context, index) {
                    final item = displayList[index];
                    final isUnlocked = item['is_completed'] == true;
                    return _buildFishCard(
                      item['fish_name']?.toString() ?? 'Ikan',
                      item['fish_indo']?.toString() ?? '',
                      'Common',
                      item['fish_emoji']?.toString() ?? '🐟',
                      isUnlocked,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFishCard(String name, String indo, String rarity, String emoji, bool unlocked) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: unlocked ? const Color(0xFFF0F9FF) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: unlocked ? const Color(0xFFBAE6FD) : const Color(0xFFE2E8F0),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: unlocked ? Colors.white : const Color(0xFFE2E8F0),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                unlocked ? emoji : '🔒',
                style: const TextStyle(fontSize: 28),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            unlocked ? name : '???',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: unlocked ? const Color(0xFF0369A1) : const Color(0xFF94A3B8),
            ),
          ),
          Text(
            unlocked ? indo : 'Belum Ditangkap',
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: unlocked ? const Color(0xFF64748B) : const Color(0xFFCBD5E1),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FDF4), // Nuansa alam air & danau hijau mint muda
      body: Stack(
        children: [
          // Background Gradasi Air & Langit Cerah
          Container(
            height: 380,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF38BDF8), // Langit biru cerah
                  Color(0xFF7DD3FC),
                  Color(0xFFBAE6FD),
                  Color(0xFFF0FDF4), // Transisi lembut ke bawah
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // 1. Header (Kembali, Judul Game, Saldo Koin)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Tombol Kembali
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.06),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.arrow_back_rounded,
                              color: Color(0xFF0284C7), size: 20),
                        ),
                      ),

                      // Badge Judul Bersahabat
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white),
                        ),
                        child: Row(
                          children: [
                            const Text('🐠', style: TextStyle(fontSize: 16)),
                            const SizedBox(width: 6),
                            Text(
                              'Tangkap Ikan',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF0369A1),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Tombol Petunjuk (?) & Koin Reaktif Siswa
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => showFishingHowToPlay(context),
                            child: Container(
                              width: 38,
                              height: 38,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.06),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Icon(Icons.help_outline_rounded,
                                    color: Color(0xFF0284C7), size: 20),
                              ),
                            ),
                          ),
                          ValueListenableBuilder<int>(
                            valueListenable: GameCoinManager.coins,
                            builder: (context, currentCoins, child) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.06),
                                      blurRadius: 10,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.monetization_on_rounded,
                                        color: Color(0xFFF59E0B), size: 18),
                                    const SizedBox(width: 5),
                                    Text(
                                      '$currentCoins',
                                      style: GoogleFonts.poppins(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFF0F172A),
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

                // 2. Konten Scrollable
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),

                        // Hero Banner Danau & Maskot Pemancing Lucu
                        AnimatedBuilder(
                          animation: _bounceAnimation,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, _bounceAnimation.value),
                              child: child,
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF0284C7), Color(0xFF0EA5E9), Color(0xFF38BDF8)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(26),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF0284C7).withValues(alpha: 0.35),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFEF08A),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          '✨ Petualangan Samudra Kata',
                                          style: GoogleFonts.poppins(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w800,
                                            color: const Color(0xFF854D0E),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Tangkap Ikan Impianmu!',
                                        style: GoogleFonts.poppins(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                          height: 1.25,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'Tangkap ikan laut cerdik dengan menjawab kuis bahasa Inggris!',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.white.withValues(alpha: 0.9),
                                          height: 1.35,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 6),
                                // Ilustrasi Ikan Dinamis & Hidup yang Menyatu dengan Banner
                                const DynamicFishIllustration(size: 96),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Section Judul Pilihan Mode
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Pilih Mode Bermain',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                            GestureDetector(
                              onTap: _showAquariumModal,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE0F2FE),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.set_meal_rounded,
                                        color: Color(0xFF0284C7), size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Akuarium',
                                      style: GoogleFonts.poppins(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF0284C7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // KARTU UTAMA TANGKAP IKAN SAMUDRA
                        _buildModeCard(
                          title: 'Petualangan Bawah Laut',
                          badge: '🌊 Samudra Bebas',
                          desc: 'Tangkap berbagai ikan laut eksotis yang berenang bebas menembus samudra luas. Gunakan umpan makanan dan taklukkan semua level!',
                          iconEmoji: '🐠',
                          gradientColors: const [Color(0xFF0284C7), Color(0xFF0369A1)],
                          buttonText: 'Mulai Bermain Sekarang 🐠',
                          onTap: _startPlayGame,
                        ),

                        const SizedBox(height: 26),
                      ],
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

  Widget _buildModeCard({
    required String title,
    required String badge,
    required String desc,
    required String iconEmoji,
    required List<Color> gradientColors,
    required String buttonText,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: gradientColors[0].withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(iconEmoji, style: const TextStyle(fontSize: 24)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: gradientColors[0].withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        badge,
                        style: GoogleFonts.poppins(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: gradientColors[1],
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            desc,
            style: GoogleFonts.poppins(
              fontSize: 12.5,
              color: const Color(0xFF64748B),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),
          CustomButton(
            text: buttonText,
            icon: Icons.play_arrow_rounded,
            gradientColors: gradientColors,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}

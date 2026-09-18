import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Section Podium Leaderboard Top 3 Skor Siswa.
/// Terdiri dari 3 kartu podium berundak: Juara 1 di tengah dengan mahkota emas,
/// Juara 2 di kiri (avatar ungu), dan Juara 3 di kanan (avatar hijau).
class GameLeaderboardSection extends StatelessWidget {
  final VoidCallback? onPodiumTap;

  const GameLeaderboardSection({super.key, this.onPodiumTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPodiumTap ?? () => _showLeaderboardDetail(context),
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Juara 2 (Kiri - Kartu Putih Avatar Ungu)
            _buildSidePodium(
              rank: 2,
              avatarColor: const Color(0xFF7E4A6E),
              height: 108,
              width: 78,
            ),

            const SizedBox(width: 12),

            // Juara 1 (Tengah - Kartu Biru Menjulang Tinggi dengan Mahkota Emas)
            _buildCenterPodium(
              rank: 1,
              avatarColor: const Color(0xFF9DE0F6),
              height: 132,
              width: 88,
            ),

            const SizedBox(width: 12),

            // Juara 3 (Kanan - Kartu Putih Avatar Hijau)
            _buildSidePodium(
              rank: 3,
              avatarColor: const Color(0xFF45A66B),
              height: 100,
              width: 78,
            ),
          ],
        ),
      ),
    );
  }

  // Builder Kartu Juara 1 (Paling Tinggi + Mahkota Emas)
  Widget _buildCenterPodium({
    required int rank,
    required Color avatarColor,
    required double height,
    required double width,
  }) {
    return Stack(
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 6),
              // Lingkaran Avatar Biru Muda Lembut
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: avatarColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.8),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Teks Skor
              Text(
                'Skor',
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.2,
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
    );
  }

  // Builder Kartu Juara 2 & 3 (Samping)
  Widget _buildSidePodium({
    required int rank,
    required Color avatarColor,
    required double height,
    required double width,
  }) {
    return Container(
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Lingkaran Avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: avatarColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Teks Skor
          Text(
            'Skor',
            style: GoogleFonts.poppins(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1E293B),
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }

  void _showLeaderboardDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
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
                Text(
                  'Papan Peringkat Game',
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _buildRankRow('1', 'Budi Pratama', '2,450 Poin', const Color(0xFFFFB800)),
            const Divider(height: 14),
            _buildRankRow('2', 'Siti Rahma', '2,100 Poin', const Color(0xFF94A3B8)),
            const Divider(height: 14),
            _buildRankRow('3', 'Ahmad Rizki', '1,890 Poin', const Color(0xFFB45309)),
            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildRankRow(String rank, String name, String score, Color badgeColor) {
    return Row(
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: badgeColor.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              rank,
              style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: badgeColor),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            name,
            style: GoogleFonts.poppins(fontSize: 13.5, fontWeight: FontWeight.w600, color: const Color(0xFF1E293B)),
          ),
        ),
        Text(
          score,
          style: GoogleFonts.poppins(fontSize: 13.5, fontWeight: FontWeight.w800, color: const Color(0xFF0066D6)),
        ),
      ],
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

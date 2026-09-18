import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LencanaItemData {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color circleColor;
  final Color iconColor;
  final bool isLocked;

  const LencanaItemData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.circleColor,
    required this.iconColor,
    this.isLocked = false,
  });
}

/// Section Lencana Prestasi: Menampilkan Grid 6 Lencana Pencapaian Siswa
/// dengan squircle pastel, ikon bertema, dan status terkunci/terbuka.
class ProfilLencanaSection extends StatelessWidget {
  const ProfilLencanaSection({super.key});

  static const List<LencanaItemData> lencanaList = [
    LencanaItemData(
      title: 'Top 10 RPL 1',
      subtitle: 'Okt 2024',
      icon: Icons.emoji_events_rounded,
      circleColor: Color(0xFF6EE7B7), // Mint
      iconColor: Color(0xFF047857),
    ),
    LencanaItemData(
      title: 'Early Bird',
      subtitle: '06:00 WIB',
      icon: Icons.wb_sunny_rounded,
      circleColor: Color(0xFFFDE68A), // Warm Gold
      iconColor: Color(0xFFB45309),
    ),
    LencanaItemData(
      title: 'Streak King',
      subtitle: 'Minggu lalu',
      icon: Icons.trending_up_rounded,
      circleColor: Color(0xFFFECDD3), // Coral Rose
      iconColor: Color(0xFFBE123C),
    ),
    LencanaItemData(
      title: 'Bug Hunter',
      subtitle: '50 Glosarium',
      icon: Icons.bug_report_rounded,
      circleColor: Color(0xFFDDD6FE), // Lavender
      iconColor: Color(0xFF6D28D9),
    ),
    LencanaItemData(
      title: 'Score 100',
      subtitle: 'Quiz Modul 3',
      icon: Icons.check_circle_rounded,
      circleColor: Color(0xFFA7F3D0), // Emerald
      iconColor: Color(0xFF047857),
    ),
    LencanaItemData(
      title: 'TOEIC 550+',
      subtitle: 'Terkunci',
      icon: Icons.lock_rounded,
      circleColor: Color(0xFFE2E8F0), // Gray Locked
      iconColor: Color(0xFF64748B),
      isLocked: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFF1F5F9),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Baris: Ikon Medali Bintang + "Lencana Prestasi" + "5 Terbuka"
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: Color(0xFFFEF3C7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.stars_rounded,
                  color: Color(0xFFD97706),
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Lencana Prestasi',
                style: GoogleFonts.poppins(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                  letterSpacing: -0.2,
                ),
              ),
              const Spacer(),
              Text(
                '5 Terbuka',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0066D6),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Grid 3 Kolom Lencana
          LayoutBuilder(
            builder: (context, constraints) {
              const spacing = 8.0;
              final itemWidth = (constraints.maxWidth - (spacing * 2)) / 3;

              return Wrap(
                spacing: spacing,
                runSpacing: 10,
                children: lencanaList.map((item) {
                  return SizedBox(
                    width: itemWidth,
                    child: _buildBadgeCard(context, item),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeCard(BuildContext context, LencanaItemData item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: item.circleColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(item.icon, color: item.iconColor, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item.title,
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              content: Text(
                item.isLocked
                    ? 'Lencana ini masih terkunci. Selesaikan tantangan dan kuis untuk membukanya!'
                    : 'Selamat! Kamu telah meraih lencana "${item.title}" (${item.subtitle}).',
                style: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF475569)),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text('Tutup', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: const Color(0xFF0066D6))),
                ),
              ],
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFF1F5F9),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Lingkaran Ikon Lencana
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: item.circleColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: item.circleColor.withValues(alpha: 0.35),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    item.icon,
                    color: item.iconColor,
                    size: 22,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Judul Lencana
              Text(
                item.title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: item.isLocked ? const Color(0xFF94A3B8) : const Color(0xFF0F172A),
                ),
              ),

              const SizedBox(height: 2),

              // Subtitle
              Text(
                item.subtitle,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

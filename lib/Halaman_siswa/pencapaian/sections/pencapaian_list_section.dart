import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Data statis satu item pencapaian/lencana.
class PencapaianItem {
  final String title;
  final String description;
  final String info;
  final String status; // 'Terbuka', 'Terkunci', 'Selesai', 'Langka'
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;

  const PencapaianItem({
    required this.title,
    required this.description,
    required this.info,
    required this.status,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
  });
}

/// Section Daftar Pencapaian / Lencana.
/// Menampilkan list item pencapaian statis sesuai desain Figma.
class PencapaianListSection extends StatelessWidget {
  final String activeFilter;
  final ValueChanged<PencapaianItem>? onItemTap;

  const PencapaianListSection({
    super.key,
    this.activeFilter = 'Semua',
    this.onItemTap,
  });

  // Data statis pencapaian (sesuai Figma)
  static const List<PencapaianItem> _allPencapaian = [
    PencapaianItem(
      title: 'Top 10 RPL 1',
      description: 'Masuk peringkat 10 besar RPL 1 di kelas',
      info: 'Okt 2024',
      status: 'Terbuka',
      icon: Icons.emoji_events_rounded,
      iconColor: Color(0xFFCA8A04),
      iconBgColor: Color(0xFFFEF9C3),
    ),
    PencapaianItem(
      title: 'Early Bird',
      description: 'Belajar sebelum jam 06:00 selama 7 hari',
      info: '06:00 WIB',
      status: 'Terbuka',
      icon: Icons.wb_sunny_rounded,
      iconColor: Color(0xFFEA580C),
      iconBgColor: Color(0xFFFFF7ED),
    ),
    PencapaianItem(
      title: 'Streak King',
      description: 'Belajar 7 hari berturut-turut tanpa absen',
      info: 'Minggu lalu',
      status: 'Terbuka',
      icon: Icons.local_fire_department_rounded,
      iconColor: Color(0xFFDC2626),
      iconBgColor: Color(0xFFFEE2E2),
    ),
    PencapaianItem(
      title: 'Bug Hunter',
      description: 'Melaporkan 10 bug atau masalah di aplikasi',
      info: '50 Glosarium',
      status: 'Terbuka',
      icon: Icons.bug_report_rounded,
      iconColor: Color(0xFF059669),
      iconBgColor: Color(0xFFD1FAE5),
    ),
    PencapaianItem(
      title: 'Score 100',
      description: 'Mendapatkan nilai 100 pada Quiz Modul 3',
      info: 'Quiz Modul 3',
      status: 'Selesai',
      icon: Icons.check_circle_rounded,
      iconColor: Color(0xFF059669),
      iconBgColor: Color(0xFFD1FAE5),
    ),
    PencapaianItem(
      title: 'TOEIC 550+',
      description: 'Mencapai skor TOEIC minimal 550',
      info: 'Terkunci',
      status: 'Terkunci',
      icon: Icons.star_rounded,
      iconColor: Color(0xFF7C3AED),
      iconBgColor: Color(0xFFEDE9FE),
    ),
  ];

  List<PencapaianItem> get _filteredItems {
    if (activeFilter == 'Semua') return _allPencapaian;
    return _allPencapaian.where((item) {
      if (activeFilter == 'Terbuka') {
        return item.status == 'Terbuka' || item.status == 'Selesai';
      }
      return item.status == activeFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _filteredItems;

    return Column(
      children: [
        // Daftar Item Pencapaian
        ...items.map((item) => _buildPencapaianTile(context, item)),

        const SizedBox(height: 14),

        // Pesan Motivasi di Bawah
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F9FF),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFFBAE6FD),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.rocket_launch_rounded,
                color: Color(0xFF0284C7),
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Selesaikan lebih banyak aktivitas untuk membuka lencana-lencana spesial lainnya!',
                  style: GoogleFonts.poppins(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF0369A1),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPencapaianTile(BuildContext context, PencapaianItem item) {
    // Warna badge berdasarkan status
    Color badgeBgColor;
    Color badgeTextColor;
    String badgeText;

    switch (item.status) {
      case 'Terbuka':
        badgeBgColor = const Color(0xFFDBEAFE);
        badgeTextColor = const Color(0xFF2563EB);
        badgeText = 'Terbuka';
        break;
      case 'Selesai':
        badgeBgColor = const Color(0xFFD1FAE5);
        badgeTextColor = const Color(0xFF059669);
        badgeText = 'Selesai';
        break;
      case 'Terkunci':
        badgeBgColor = const Color(0xFFF1F5F9);
        badgeTextColor = const Color(0xFF94A3B8);
        badgeText = 'Terkunci';
        break;
      case 'Langka':
        badgeBgColor = const Color(0xFFFEF3C7);
        badgeTextColor = const Color(0xFFD97706);
        badgeText = 'Langka';
        break;
      default:
        badgeBgColor = const Color(0xFFF1F5F9);
        badgeTextColor = const Color(0xFF94A3B8);
        badgeText = item.status;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => onItemTap?.call(item),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0E4E93).withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Icon Pencapaian
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: item.status == 'Terkunci'
                        ? const Color(0xFFF1F5F9)
                        : item.iconBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(
                      item.status == 'Terkunci'
                          ? Icons.lock_outline_rounded
                          : item.icon,
                      color: item.status == 'Terkunci'
                          ? const Color(0xFFCBD5E1)
                          : item.iconColor,
                      size: 22,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Konten Teks
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: GoogleFonts.poppins(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: item.status == 'Terkunci'
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.description,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF94A3B8),
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.info,
                        style: GoogleFonts.poppins(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFFCBD5E1),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Badge Status
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: badgeBgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    badgeText,
                    style: GoogleFonts.poppins(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: badgeTextColor,
                    ),
                  ),
                ),

                const SizedBox(width: 4),

                // Chevron
                Icon(
                  Icons.chevron_right_rounded,
                  color: const Color(0xFFCBD5E1),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

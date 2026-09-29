import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/pencapaian_badge_icon.dart';

/// Data Model Sederhana untuk Item Lencana Pencapaian
class LencanaItem {
  final String id;
  final String title;
  final String description;
  final String info;
  final BadgeType badgeType;
  final bool isUnlocked;
  final bool isRare;

  const LencanaItem({
    required this.id,
    required this.title,
    required this.description,
    required this.info,
    required this.badgeType,
    this.isUnlocked = true,
    this.isRare = false,
  });
}

/// Section Daftar Kartu Lencana Pencapaian.
class PencapaianListSection extends StatelessWidget {
  final List<LencanaItem> items;
  final ValueChanged<LencanaItem>? onTapItem;

  const PencapaianListSection({
    super.key,
    required this.items,
    this.onTapItem,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Text(
            'Tidak ada lencana pada kategori ini.',
            style: GoogleFonts.poppins(
              fontSize: 12.5,
              color: const Color(0xFF64748B),
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final item = items[index];

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onTapItem?.call(item),
            borderRadius: BorderRadius.circular(18),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFFF1F5F9),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00386B).withValues(alpha: 0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // 1. Ikon Badge Lencana Reusable
                  PencapaianBadgeIcon(
                    type: item.badgeType,
                    size: 46,
                    iconSize: 22,
                  ),

                  const SizedBox(width: 12),

                  // 2. Info Teks (Judul, Syarat, Waktu)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: GoogleFonts.poppins(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: item.isUnlocked
                                ? const Color(0xFF0F172A)
                                : const Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF64748B),
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.info,
                          style: GoogleFonts.poppins(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // 3. Status Pill & Trailing Arrow
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Status Badge (Terbuka / Terkunci)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: item.isUnlocked
                              ? const Color(0xFFDCFCE7) // Light Mint Green
                              : const Color(0xFFF1F5F9), // Light Gray
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          item.isUnlocked ? 'Terbuka' : 'Terkunci',
                          style: GoogleFonts.poppins(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: item.isUnlocked
                                ? const Color(0xFF10B981) // Green
                                : const Color(0xFF64748B), // Slate Gray
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xFF94A3B8),
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

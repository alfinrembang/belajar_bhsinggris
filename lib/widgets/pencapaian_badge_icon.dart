import 'package:flutter/material.dart';

/// Jenis / Tipe Preset Lencana Pencapaian
enum BadgeType {
  trophy,
  earlyBird,
  streakKing,
  bugHunter,
  score100,
  locked,
  goldMedal,
  custom,
}

/// Komponen Reusable Ikon Badge Lencana Pencapaian.
/// Digunakan pada kartu prestasi siswa dengan berbagai varian warna pastel yang estetik.
class PencapaianBadgeIcon extends StatelessWidget {
  final BadgeType type;
  final IconData? customIcon;
  final Color? customIconColor;
  final Color? customBgColor;
  final double size;
  final double iconSize;

  const PencapaianBadgeIcon({
    super.key,
    this.type = BadgeType.trophy,
    this.customIcon,
    this.customIconColor,
    this.customBgColor,
    this.size = 46,
    this.iconSize = 22,
  });

  @override
  Widget build(BuildContext context) {
    if (type == BadgeType.goldMedal) {
      // Desain Medali Emas Khusus untuk Card Ringkasan Atas
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFF59E0B).withValues(alpha: 0.35),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Container(
            width: size * 0.72,
            height: size * 0.72,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFFEF3C7),
            ),
            child: Icon(
              Icons.star_rounded,
              size: iconSize * 1.1,
              color: const Color(0xFFD97706),
            ),
          ),
        ),
      );
    }

    // Resolusi Warna & Ikon berdasarkan BadgeType
    IconData icon;
    Color iconColor;
    Color bgColor;

    switch (type) {
      case BadgeType.trophy:
        icon = Icons.emoji_events_rounded;
        iconColor = const Color(0xFF10B981); // Emerald Green
        bgColor = const Color(0xFFDCFCE7); // Light Mint
        break;
      case BadgeType.earlyBird:
        icon = Icons.wb_sunny_rounded;
        iconColor = const Color(0xFFD97706); // Warm Amber
        bgColor = const Color(0xFFFEF3C7); // Soft Amber
        break;
      case BadgeType.streakKing:
        icon = Icons.trending_up_rounded;
        iconColor = const Color(0xFFDC2626); // Bright Red
        bgColor = const Color(0xFFFEE2E2); // Soft Red
        break;
      case BadgeType.bugHunter:
        icon = Icons.pest_control_rounded;
        iconColor = const Color(0xFF2563EB); // Royal Blue
        bgColor = const Color(0xFFDBEAFE); // Soft Blue
        break;
      case BadgeType.score100:
        icon = Icons.check_circle_rounded;
        iconColor = const Color(0xFF059669); // Forest Green
        bgColor = const Color(0xFFD1FAE5); // Mint Emerald
        break;
      case BadgeType.locked:
        icon = Icons.lock_outline_rounded;
        iconColor = const Color(0xFF94A3B8); // Slate Gray
        bgColor = const Color(0xFFF1F5F9); // Light Slate
        break;
      case BadgeType.custom:
      default:
        icon = customIcon ?? Icons.emoji_events_rounded;
        iconColor = customIconColor ?? const Color(0xFF2563EB);
        bgColor = customBgColor ?? const Color(0xFFDBEAFE);
        break;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          icon,
          size: iconSize,
          color: iconColor,
        ),
      ),
    );
  }
}

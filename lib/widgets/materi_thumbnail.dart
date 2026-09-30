import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tema visual kategori materi pembelajaran (warna latar, warna icon, badge).
class MateriCategoryTheme {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final Color badgeBgColor;
  final Color badgeTextColor;

  const MateriCategoryTheme({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.badgeBgColor,
    required this.badgeTextColor,
  });

  /// Mengambil konfigurasi tema visual resmi berdasarkan nama kategori.
  /// Bersifat case-insensitive dan memiliki fallback yang aman.
  static MateriCategoryTheme fromCategory(String? category) {
    final cat = (category ?? '').trim().toLowerCase();

    switch (cat) {
      case 'text':
      case 'reading':
        return const MateriCategoryTheme(
          icon: Icons.auto_stories_rounded,
          iconColor: Color(0xFF0066D6), // Royal Blue
          bgColor: Color(0xFFE8F1FB),
          badgeBgColor: Color(0xFFE3EDFA),
          badgeTextColor: Color(0xFF0066D6),
        );

      case 'grammar':
      case 'tenses':
        return const MateriCategoryTheme(
          icon: Icons.spellcheck_rounded,
          iconColor: Color(0xFF059669), // Emerald Green
          bgColor: Color(0xFFD1FAE5),
          badgeBgColor: Color(0xFFECFDF5),
          badgeTextColor: Color(0xFF059669),
        );

      case 'vocabulary':
      case 'vocab':
      case 'kosakata':
        return const MateriCategoryTheme(
          icon: Icons.translate_rounded,
          iconColor: Color(0xFFD97706), // Warm Amber / Orange
          bgColor: Color(0xFFFEF3C7),
          badgeBgColor: Color(0xFFFFFBEB),
          badgeTextColor: Color(0xFFD97706),
        );

      case 'speaking':
      case 'conversation':
        return const MateriCategoryTheme(
          icon: Icons.forum_rounded, // Chat / Percakapan Interaktif
          iconColor: Color(0xFF7C3AED), // Ungu Modern (Vibrant Violet)
          bgColor: Color(0xFFEDE9FE), // Soft Purple Background
          badgeBgColor: Color(0xFFF5F3FF),
          badgeTextColor: Color(0xFF7C3AED),
        );

      case 'listening':
      case 'audio':
        return const MateriCategoryTheme(
          icon: Icons.headphones_rounded,
          iconColor: Color(0xFF4F46E5), // Indigo Modern
          bgColor: Color(0xFFEEF2FF),
          badgeBgColor: Color(0xFFF5F7FF),
          badgeTextColor: Color(0xFF4F46E5),
        );

      default:
        return const MateriCategoryTheme(
          icon: Icons.menu_book_rounded,
          iconColor: Color(0xFF0066D6),
          bgColor: Color(0xFFE8F1FB),
          badgeBgColor: Color(0xFFE3EDFA),
          badgeTextColor: Color(0xFF0066D6),
        );
    }
  }
}

/// Komponen Reusable: Thumbnail Icon Materi Pembelajaran.
/// Menampilkan kotak bersudut tumpul yang konsisten di seluruh aplikasi
/// (baik di Beranda, Halaman Materi, maupun modul lainnya).
class MateriThumbnail extends StatelessWidget {
  final String category;
  final double size;
  final double? iconSize;
  final BorderRadius? borderRadius;
  final IconData? customIcon;
  final Color? customIconColor;
  final Color? customBgColor;
  final Widget? child;

  const MateriThumbnail({
    super.key,
    required this.category,
    this.size = 52,
    this.iconSize,
    this.borderRadius,
    this.customIcon,
    this.customIconColor,
    this.customBgColor,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = MateriCategoryTheme.fromCategory(category);
    final effectiveRadius = borderRadius ?? BorderRadius.circular(16);
    final effectiveIconSize = iconSize ?? (size * 0.5);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: customBgColor ?? theme.bgColor,
        borderRadius: effectiveRadius,
      ),
      child: Center(
        child: child ??
            Icon(
              customIcon ?? theme.icon,
              color: customIconColor ?? theme.iconColor,
              size: effectiveIconSize,
            ),
      ),
    );
  }
}

/// Komponen Reusable: Pill Badge Kategori Materi Pembelajaran.
/// Menampilkan badge kategori dengan warna dan tipografi seragam.
class MateriBadge extends StatelessWidget {
  final String category;
  final String? customText;
  final Color? customBgColor;
  final Color? customTextColor;
  final double fontSize;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const MateriBadge({
    super.key,
    required this.category,
    this.customText,
    this.customBgColor,
    this.customTextColor,
    this.fontSize = 11,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = MateriCategoryTheme.fromCategory(category);

    return Container(
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 2.5,
          ),
      decoration: BoxDecoration(
        color: customBgColor ?? theme.badgeBgColor,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
      child: Text(
        customText ?? category,
        style: GoogleFonts.poppins(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          color: customTextColor ?? theme.badgeTextColor,
        ),
      ),
    );
  }
}

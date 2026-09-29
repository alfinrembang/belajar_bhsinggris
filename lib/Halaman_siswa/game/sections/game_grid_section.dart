import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/materi_thumbnail.dart';

/// Data Model Game Siswa
class GameItemData {
  final String id;
  final String title;
  final String description;
  final String category;
  final Color themeColor;
  final Color badgeColor;
  final String badgeText;
  final IconData? customIcon;

  const GameItemData({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.themeColor,
    required this.badgeColor,
    this.badgeText = 'Tt Kata',
    this.customIcon,
  });
}

/// Section Grid Game: Menampilkan daftar kartu game dalam layout 2 kolom responsif.
/// Menggunakan MateriThumbnail untuk squircle icon huruf "T", MateriBadge untuk pill badge "Tt Kata",
/// dan CustomButton dengan styling navy khas game untuk tombol "▷ Main".
class GameGridSection extends StatelessWidget {
  final List<GameItemData> items;
  final ValueChanged<GameItemData>? onPlayGame;

  const GameGridSection({
    super.key,
    required this.items,
    this.onPlayGame,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 28),
          child: Text(
            'Tidak ada game untuk kategori ini.',
            style: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF64748B)),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 12.0;
        final cardWidth = (constraints.maxWidth - spacing) / 2;

        return Wrap(
          spacing: spacing,
          runSpacing: 14,
          children: items.map((item) {
            return SizedBox(
              width: cardWidth,
              child: _buildGameCard(context, item),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildGameCard(BuildContext context, GameItemData item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _handleCardTap(context, item),
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.all(13),
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
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Baris Atas: Squircle Icon "T" (MateriThumbnail) & Badge Pill (MateriBadge)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Squircle Icon "T" Menggunakan Komponen Reusable MateriThumbnail
                  MateriThumbnail(
                    category: item.category,
                    size: 44,
                    borderRadius: BorderRadius.circular(14),
                    customBgColor: item.themeColor,
                    child: item.customIcon != null
                        ? Icon(item.customIcon, color: Colors.white, size: 24)
                        : Text(
                            'T',
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              height: 1.1,
                            ),
                          ),
                  ),

                  // Pill Badge Menggunakan MateriBadge Reusable
                  MateriBadge(
                    category: item.category,
                    customText: item.badgeText,
                    customBgColor: item.badgeColor,
                    customTextColor: Colors.white,
                    fontSize: 10,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Judul Game
              Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                  letterSpacing: -0.2,
                ),
              ),

              const SizedBox(height: 4),

              // Deskripsi Game
              SizedBox(
                height: 38,
                child: Text(
                  item.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF64748B),
                    height: 1.3,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Tombol "Main" Konsisten Menggunakan CustomButton Reusable
              CustomButton(
                text: 'Main',
                icon: Icons.play_arrow_rounded,
                iconSize: 17,
                height: 36,
                fontSize: 13,
                fontWeight: FontWeight.w800,
                borderRadius: BorderRadius.circular(12),
                onTap: () => _handleCardTap(context, item),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleCardTap(BuildContext context, GameItemData item) {
    if (onPlayGame != null) {
      onPlayGame!(item);
    } else {
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
              const SizedBox(height: 18),
              Row(
                children: [
                  MateriThumbnail(
                    category: item.category,
                    size: 52,
                    borderRadius: BorderRadius.circular(16),
                    customBgColor: item.themeColor,
                    child: item.customIcon != null
                        ? Icon(item.customIcon, color: Colors.white, size: 28)
                        : Text(
                            'T',
                            style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white),
                          ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: GoogleFonts.poppins(fontSize: 16.5, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A)),
                        ),
                        Text(
                          item.description,
                          style: GoogleFonts.poppins(fontSize: 11.5, color: const Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Mulai Bermain Sekarang',
                icon: Icons.play_arrow_rounded,
                iconSize: 18,
                height: 44,
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Memulai permainan ${item.title}...'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    }
  }
}

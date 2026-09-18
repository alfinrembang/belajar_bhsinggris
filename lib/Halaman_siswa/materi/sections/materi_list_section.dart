import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/materi_thumbnail.dart';

/// Model item materi pembelajaran
class MateriItemData {
  final String id;
  final String category;
  final String title;
  final String description;
  final int currentUnit;
  final int totalUnit;
  final int xp;

  const MateriItemData({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.currentUnit,
    required this.totalUnit,
    required this.xp,
  });
}

/// Section List Materi: Menampilkan Header "Daftar Materi Belajar",
/// Jumlah Materi, dan Kartu-Kartu Materi Pembelajaran dengan komponen MateriThumbnail & MateriBadge.
class MateriListSection extends StatelessWidget {
  final List<MateriItemData> items;
  final ValueChanged<MateriItemData>? onMulaiBelajar;

  const MateriListSection({
    super.key,
    required this.items,
    this.onMulaiBelajar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Baris Header: "Daftar Materi Belajar" & "X Materi"
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Daftar Materi Belajar',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF64748B),
              ),
            ),
            Text(
              '${items.length} Materi',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Daftar Kartu Materi
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (context, index) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            final item = items[index];
            final double progressValue = item.totalUnit > 0
                ? (item.currentUnit / item.totalUnit).clamp(0.0, 1.0)
                : 0.0;
            final theme = MateriCategoryTheme.fromCategory(item.category);

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFE5EDF7),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F3156).withValues(alpha: 0.04),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bagian Atas: Thumbnail Reusable & Teks
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Thumbnail Reusable Konsisten
                      MateriThumbnail(
                        category: item.category,
                        size: 52,
                        borderRadius: BorderRadius.circular(16),
                      ),

                      const SizedBox(width: 12),

                      // Kategori, Judul, & Deskripsi
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 2. Badge Kategori Reusable Konsisten
                            MateriBadge(
                              category: item.category,
                            ),

                            const SizedBox(height: 5),

                            // Judul Materi
                            Text(
                              item.title,
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0F172A),
                                letterSpacing: -0.2,
                              ),
                            ),

                            const SizedBox(height: 3),

                            // Deskripsi Singkat
                            Text(
                              item.description,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: const Color(0xFF64748B),
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Indikator Progres Materi
                  Text(
                    'Materi ${item.currentUnit} dari ${item.totalUnit}',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF334155),
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Linear Progress Bar Otomatis Mengikuti Warna Kategori
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progressValue,
                      minHeight: 5.5,
                      backgroundColor: const Color(0xFFE8EEF8),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.iconColor,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Baris Bawah: +XP dan Tombol CustomButton "Mulai Belajar"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // XP Point
                      Text(
                        '+${item.xp} XP',
                        style: GoogleFonts.poppins(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0F172A),
                        ),
                      ),

                      // Tombol Mulai Belajar (CustomButton Biru Konsisten Beranda)
                      CustomButton(
                        text: 'Mulai Belajar',
                        width: 124,
                        height: 38,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => onMulaiBelajar?.call(item),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

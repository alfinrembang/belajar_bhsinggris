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
  final String? tingkatKelas;
  final String? gambarUrl;
  final String? audioUrl;
  final bool isCompleted;

  const MateriItemData({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.currentUnit,
    required this.totalUnit,
    required this.xp,
    this.tingkatKelas,
    this.gambarUrl,
    this.audioUrl,
    this.isCompleted = false,
  });

  factory MateriItemData.fromJson(Map<String, dynamic> json) {
    final rawId = json['id']?.toString() ?? '';
    final totalSoal = (json['jumlah_soal'] is int && (json['jumlah_soal'] as int) > 0)
        ? (json['jumlah_soal'] as int)
        : 5;
    final completed = json['is_completed'] == true;

    return MateriItemData(
      id: rawId,
      category: json['kategori']?.toString() ?? 'Reading',
      title: json['judul']?.toString() ?? '',
      description: json['deskripsi_singkat']?.toString() ?? '',
      currentUnit: completed ? totalSoal : 1,
      totalUnit: totalSoal,
      xp: json['xp_reward'] is int
          ? (json['xp_reward'] as int)
          : (int.tryParse(json['xp_reward']?.toString() ?? '') ?? 50),
      tingkatKelas: json['tingkat_kelas']?.toString(),
      gambarUrl: json['gambar_url']?.toString(),
      audioUrl: json['audio_url']?.toString(),
      isCompleted: completed,
    );
  }
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

        if (items.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
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
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF1F5F9),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.auto_stories_outlined,
                      color: Color(0xFF94A3B8),
                      size: 26,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Belum Ada Materi Tersedia',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Materi untuk kategori ini belum dipublikasikan oleh guru.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          )
        else
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
                        // 1. Thumbnail Reusable Konsisten (Dukungan Gambar Cover Guru)
                        MateriThumbnail(
                          category: item.category,
                          size: 52,
                          borderRadius: BorderRadius.circular(16),
                          child: (item.gambarUrl != null &&
                                  item.gambarUrl!.trim().isNotEmpty)
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.network(
                                    item.gambarUrl!,
                                    width: 52,
                                    height: 52,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Icon(
                                      theme.icon,
                                      color: theme.iconColor,
                                      size: 26,
                                    ),
                                  ),
                                )
                              : null,
                        ),

                        const SizedBox(width: 12),

                        // Kategori, Judul, & Deskripsi
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 2. Badge Kategori Reusable Konsisten
                              Row(
                                children: [
                                  MateriBadge(
                                    category: item.category,
                                  ),
                                  if (item.tingkatKelas != null &&
                                      item.tingkatKelas!.isNotEmpty) ...[
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF1F5F9),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        item.tingkatKelas == 'Semua Kelas'
                                            ? 'Umum'
                                            : 'Kelas ${item.tingkatKelas}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF64748B),
                                        ),
                                      ),
                                    ),
                                  ],
                                  if (item.isCompleted) ...[
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2.5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFDCFCE7),
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: const Color(0xFF86EFAC),
                                          width: 0.8,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.check_circle_rounded,
                                            size: 11,
                                            color: Color(0xFF16A34A),
                                          ),
                                          const SizedBox(width: 3.5),
                                          Text(
                                            'Selesai',
                                            style: GoogleFonts.poppins(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF16A34A),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.isCompleted
                              ? 'Selesai (${item.totalUnit}/${item.totalUnit})'
                              : 'Materi ${item.currentUnit} dari ${item.totalUnit}',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: item.isCompleted
                                ? const Color(0xFF16A34A)
                                : const Color(0xFF334155),
                          ),
                        ),
                        if (item.isCompleted)
                          const Icon(
                            Icons.check_circle_rounded,
                            size: 15,
                            color: Color(0xFF16A34A),
                          ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // Linear Progress Bar Otomatis Mengikuti Warna Kategori / Hijau jika Selesai
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: item.isCompleted ? 1.0 : progressValue,
                        minHeight: 5.5,
                        backgroundColor: const Color(0xFFE8EEF8),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          item.isCompleted
                              ? const Color(0xFF16A34A)
                              : theme.iconColor,
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

                        // Tombol Mulai Belajar / Pelajari Lagi
                        CustomButton(
                          text: item.isCompleted ? 'Pelajari Lagi' : 'Mulai Belajar',
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

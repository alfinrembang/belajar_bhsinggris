import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Model data Aktivitas Siswa Dinamis (Materi, Listening, Kuis, Game)
class AktivitasItem {
  final String id;
  final String judul;
  final String tanggal;
  final String status;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String? subjudul;
  final String? tipe;
  final String? waktuLalu;
  final int? skor;
  final int? sourceId;

  const AktivitasItem({
    this.id = '',
    required this.judul,
    required this.tanggal,
    required this.status,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    this.subjudul,
    this.tipe,
    this.waktuLalu,
    this.skor,
    this.sourceId,
  });

  /// Factory untuk parsing data dinamis dari API backend Laravel
  factory AktivitasItem.fromJson(Map<String, dynamic> json) {
    final tipe = (json['tipe'] ?? 'materi').toString().toLowerCase();

    IconData icon;
    Color iconColor;
    Color iconBgColor;

    switch (tipe) {
      case 'listening':
        icon = Icons.headphones_rounded;
        iconColor = const Color(0xFF0075DE);
        iconBgColor = const Color(0xFFE8F3FF);
        break;
      case 'quiz':
        icon = Icons.edit_note_rounded;
        iconColor = const Color(0xFF7C3AED);
        iconBgColor = const Color(0xFFF5F3FF);
        break;
      case 'game':
        icon = Icons.sports_esports_rounded;
        iconColor = const Color(0xFF0D9488);
        iconBgColor = const Color(0xFFCCFBF1);
        break;
      case 'materi':
      default:
        icon = Icons.menu_book_rounded;
        iconColor = const Color(0xFFEA580C);
        iconBgColor = const Color(0xFFFFF7ED);
        break;
    }

    final rawSkor = json['skor'];
    final int? skorVal = rawSkor is int
        ? rawSkor
        : (rawSkor != null ? int.tryParse(rawSkor.toString()) : null);

    final rawSourceId = json['source_id'];
    final int? sourceIdVal = rawSourceId is int
        ? rawSourceId
        : (rawSourceId != null ? int.tryParse(rawSourceId.toString()) : null);

    return AktivitasItem(
      id: json['id']?.toString() ?? '',
      judul: json['judul']?.toString() ?? 'Aktivitas Belajar',
      tanggal: json['tanggal']?.toString() ?? '-',
      status: json['badge_text']?.toString() ?? json['status']?.toString() ?? 'selesai',
      icon: icon,
      iconColor: iconColor,
      iconBgColor: iconBgColor,
      subjudul: json['subjudul']?.toString(),
      tipe: tipe,
      waktuLalu: json['waktu_lalu']?.toString(),
      skor: skorVal,
      sourceId: sourceIdVal,
    );
  }
}

/// Section Aktivitas Terbaru: Menampilkan Daftar Riwayat Aktivitas & Status Belajar.
class AktivitasTerbaruSection extends StatelessWidget {
  final VoidCallback? onLihatSemuaTap;
  final ValueChanged<AktivitasItem>? onItemTap;
  final List<AktivitasItem>? listAktivitas;
  final bool isLoading;

  const AktivitasTerbaruSection({
    super.key,
    this.onLihatSemuaTap,
    this.onItemTap,
    this.listAktivitas,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final List<AktivitasItem> items = listAktivitas ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Baris Header Section: "Aktivitas Terbaru" & "Lihat Semua >"
        Row(
          children: [
            Text(
              'Aktivitas Terbaru',
              style: GoogleFonts.poppins(
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
              ),
            ),
            const Spacer(),
            if (items.isNotEmpty)
              InkWell(
                onTap: onLihatSemuaTap,
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Row(
                    children: [
                      Text(
                        'Lihat Semua',
                        style: GoogleFonts.poppins(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0066D6),
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(
                        Icons.chevron_right_rounded,
                        size: 15,
                        color: Color(0xFF0066D6),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: 10),

        // Kartu Putih Pembungkus List Aktivitas
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFF1F5F9),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00386B).withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: _buildContent(context, items),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, List<AktivitasItem> items) {
    // 1. Kondisi Sedang Memuat (Loading Skeleton)
    if (isLoading) {
      return Column(
        children: List.generate(2, (index) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 140,
                            height: 12,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: 80,
                            height: 10,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 50,
                      height: 22,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
              ),
              if (index < 1)
                const Divider(
                  height: 16,
                  thickness: 0.8,
                  color: Color(0xFFF1F5F9),
                ),
            ],
          );
        }),
      );
    }

    // 2. Kondisi Kosong (Empty State untuk akun baru yang belum ada riwayat)
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_stories_outlined,
                color: Color(0xFF94A3B8),
                size: 22,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Belum Ada Aktivitas Belajar',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF334155),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Aktivitas modul listening, materi, kuis, dan game edukasimu akan otomatis tampil di sini.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 10.5,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF94A3B8),
                height: 1.4,
              ),
            ),
          ],
        ),
      );
    }

    // 3. Tampilkan Daftar Riwayat Aktivitas Nyata
    return Column(
      children: List.generate(items.length, (index) {
        final item = items[index];
        final isLast = index == items.length - 1;

        // Penentuan styling warna badge status
        final (Color badgeBg, Color badgeTextColor) = _getBadgeColors(item.status);

        return Column(
          children: [
            InkWell(
              onTap: onItemTap != null ? () => onItemTap!(item) : null,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                child: Row(
                  children: [
                    // Ikon Aktivitas Berwarna Sesuai Tipe
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: item.iconBgColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        item.icon,
                        color: item.iconColor,
                        size: 20,
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Judul, Subjudul, dan Waktu
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.judul,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                item.tanggal,
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF94A3B8),
                                ),
                              ),
                              if (item.waktuLalu != null && item.waktuLalu != '-') ...[
                                Text(
                                  ' · ${item.waktuLalu}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Badge Status Dinamis (Selesai, Skor, atau Bintang)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3.5,
                      ),
                      decoration: BoxDecoration(
                        color: badgeBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        item.status,
                        style: GoogleFonts.poppins(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: badgeTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (!isLast)
              const Divider(
                height: 14,
                thickness: 0.8,
                color: Color(0xFFF1F5F9),
              ),
          ],
        );
      }),
    );
  }

  /// Helper untuk warna badge berdasarkan teks status
  (Color, Color) _getBadgeColors(String status) {
    final lower = status.toLowerCase();
    if (lower.contains('★') || lower.contains('bintang')) {
      return (const Color(0xFFFEF3C7), const Color(0xFFB45309));
    }
    if (lower.contains('skor')) {
      return (const Color(0xFFEDE9FE), const Color(0xFF6D28D9));
    }
    // Default "selesai" (hijau)
    return (
      const Color(0xFF86EFAC).withValues(alpha: 0.60),
      const Color(0xFF15803D),
    );
  }
}

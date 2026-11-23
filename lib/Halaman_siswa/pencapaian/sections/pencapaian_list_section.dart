import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/pencapaian_model.dart';

/// Section Daftar Pencapaian / Lencana Siswa.
/// Menampilkan list item pencapaian dinamis dari backend API.
class PencapaianListSection extends StatelessWidget {
  final String activeFilter;
  final List<PencapaianItemModel> items;
  final bool isLoading;
  final ValueChanged<PencapaianItemModel>? onItemTap;
  final VoidCallback? onRetry;

  const PencapaianListSection({
    super.key,
    this.activeFilter = 'Semua',
    required this.items,
    this.isLoading = false,
    this.onItemTap,
    this.onRetry,
  });

  List<PencapaianItemModel> get _filteredItems {
    if (activeFilter == 'Semua') return items;
    return items.where((item) {
      if (activeFilter == 'Terbuka') {
        return item.isUnlocked || item.status == 'Terbuka' || item.status == 'Selesai';
      }
      if (activeFilter == 'Terkunci') {
        return !item.isUnlocked || item.status == 'Terkunci';
      }
      if (activeFilter == 'Langka') {
        return item.kategori.toLowerCase() == 'langka' || item.status.toLowerCase() == 'langka';
      }
      return item.status.toLowerCase() == activeFilter.toLowerCase();
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingSkeleton();
    }

    final filtered = _filteredItems;

    if (filtered.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        // Daftar Item Pencapaian Dinamis
        ...filtered.map((item) => _buildPencapaianTile(context, item)),

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
                  'Selesaikan lebih banyak aktivitas belajar dan raih poin game untuk membuka seluruh lencana spesial!',
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

  Widget _buildPencapaianTile(BuildContext context, PencapaianItemModel item) {
    // Penentuan warna badge berdasarkan status & kategori
    Color badgeBgColor;
    Color badgeTextColor;
    String badgeText;

    if (item.kategori.toLowerCase() == 'langka' || item.status.toLowerCase() == 'langka') {
      badgeBgColor = const Color(0xFFFEF3C7);
      badgeTextColor = const Color(0xFFD97706);
      badgeText = item.isUnlocked ? 'Langka ⭐' : 'Langka (Terkunci)';
    } else if (item.isUnlocked) {
      if (item.status.toLowerCase() == 'selesai') {
        badgeBgColor = const Color(0xFFD1FAE5);
        badgeTextColor = const Color(0xFF059669);
        badgeText = 'Selesai';
      } else {
        badgeBgColor = const Color(0xFFDBEAFE);
        badgeTextColor = const Color(0xFF2563EB);
        badgeText = 'Terbuka';
      }
    } else {
      badgeBgColor = const Color(0xFFF1F5F9);
      badgeTextColor = const Color(0xFF94A3B8);
      badgeText = 'Terkunci';
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
              border: Border.all(
                color: item.isUnlocked
                    ? item.iconColor.withValues(alpha: 0.15)
                    : const Color(0xFFF1F5F9),
                width: 1.2,
              ),
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
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: item.isUnlocked
                        ? item.iconBgColor
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Center(
                    child: Icon(
                      item.isUnlocked ? item.icon : Icons.lock_outline_rounded,
                      color: item.isUnlocked
                          ? item.iconColor
                          : const Color(0xFF94A3B8),
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
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: GoogleFonts.poppins(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: item.isUnlocked
                                    ? const Color(0xFF1E293B)
                                    : const Color(0xFF64748B),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.description,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF64748B),
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      // Tampilan Progress (Bar Progress jika terkunci dan ada progress)
                      if (!item.isUnlocked && item.progressText.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: item.progressPercent.clamp(0.0, 1.0),
                                minHeight: 4.5,
                                backgroundColor: const Color(0xFFE2E8F0),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  item.iconColor.withValues(alpha: 0.8),
                                ),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Progres: ${item.progressText}',
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        )
                      else
                        Text(
                          item.info,
                          style: GoogleFonts.poppins(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w500,
                            color: item.isUnlocked
                                ? const Color(0xFF0066D6)
                                : const Color(0xFF94A3B8),
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
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: badgeTextColor,
                    ),
                  ),
                ),

                const SizedBox(width: 4),

                // Chevron
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFFCBD5E1),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.military_tech_outlined,
              color: Color(0xFF94A3B8),
              size: 28,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Tidak Ada Lencana di Kategori "$activeFilter"',
            style: GoogleFonts.poppins(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1E293B),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            'Silakan pilih kategori lain atau terus tingkatkan progres belajarmu!',
            style: GoogleFonts.poppins(
              fontSize: 11.5,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF64748B),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return Column(
      children: List.generate(4, (index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF1F5F9)),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 120,
                      height: 14,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      height: 10,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 80,
                      height: 10,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

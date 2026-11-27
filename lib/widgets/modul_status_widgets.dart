import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Filter status pengerjaan modul pada menu Materi, Listening, dan Quiz.
enum ModulStatusFilter {
  semua,
  belumSelesai,
  selesai;

  String get label => switch (this) {
        ModulStatusFilter.semua => 'Semua',
        ModulStatusFilter.belumSelesai => 'Belum Selesai',
        ModulStatusFilter.selesai => 'Selesai',
      };

  bool matches(bool isCompleted) => switch (this) {
        ModulStatusFilter.semua => true,
        ModulStatusFilter.belumSelesai => !isCompleted,
        ModulStatusFilter.selesai => isCompleted,
      };
}

/// Tombol tab filter status: Semua | Belum Selesai | Selesai dengan jumlah item.
class StatusFilterTabs extends StatelessWidget {
  final ModulStatusFilter selected;
  final int totalCount;
  final int pendingCount;
  final int completedCount;
  final ValueChanged<ModulStatusFilter> onChanged;

  const StatusFilterTabs({
    super.key,
    required this.selected,
    required this.totalCount,
    required this.pendingCount,
    required this.completedCount,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      (ModulStatusFilter.semua, totalCount),
      (ModulStatusFilter.belumSelesai, pendingCount),
      (ModulStatusFilter.selesai, completedCount),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: items.map((entry) {
          final filter = entry.$1;
          final count = entry.$2;
          final isSelected = selected == filter;

          final Color activeBg = switch (filter) {
            ModulStatusFilter.semua => const Color(0xFF0066D6),
            ModulStatusFilter.belumSelesai => const Color(0xFFF59E0B),
            ModulStatusFilter.selesai => const Color(0xFF10B981),
          };

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onChanged(filter),
                borderRadius: BorderRadius.circular(12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7.5,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? activeBg : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? activeBg : const Color(0xFFE2E8F0),
                      width: 1.2,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: activeBg.withValues(alpha: 0.24),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        filter.label,
                        style: GoogleFonts.poppins(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: isSelected ? Colors.white : const Color(0xFF475569),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.24)
                              : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$count',
                          style: GoogleFonts.poppins(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? Colors.white : const Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Badge "BARU" untuk modul yang diunggah dalam <= 3 hari dan belum dikerjakan siswa.
class BaruBadge extends StatelessWidget {
  const BaruBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7.5, vertical: 2.5),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF0EA5E9)],
        ),
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withValues(alpha: 0.22),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.auto_awesome_rounded,
            size: 10.5,
            color: Colors.white,
          ),
          const SizedBox(width: 3),
          Text(
            'BARU',
            style: GoogleFonts.poppins(
              fontSize: 9.5,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}

/// Tampilan tanggal & jam upload dalam format WIB pada kartu modul.
class UploadTimeTag extends StatelessWidget {
  final String? createdAt;

  const UploadTimeTag({super.key, this.createdAt});

  @override
  Widget build(BuildContext context) {
    if (createdAt == null || createdAt!.trim().isEmpty) {
      return const SizedBox.shrink();
    }
    final text = createdAt!.trim();
    final formatted = text.contains('WIB') ? text : '$text WIB';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.schedule_rounded,
          size: 12.5,
          color: Color(0xFF94A3B8),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            formatted,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF64748B),
            ),
          ),
        ),
      ],
    );
  }
}

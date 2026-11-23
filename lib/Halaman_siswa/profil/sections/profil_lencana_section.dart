import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/pencapaian_model.dart';
import '../../../services/api/pencapaian_service.dart';
import '../../pencapaian/detail_pencapaian_page.dart';

/// Section Lencana Prestasi pada Halaman Profil Siswa.
/// Menampilkan Grid 6 Lencana Pencapaian Dinamis yang disinkronkan secara real-time
/// dengan backend API, menampilkan total lencana terbuka dan navigasi ke detail.
class ProfilLencanaSection extends StatefulWidget {
  final int? siswaId;
  final List<PencapaianItemModel>? preloadedItems;

  const ProfilLencanaSection({
    super.key,
    this.siswaId,
    this.preloadedItems,
  });

  @override
  State<ProfilLencanaSection> createState() => _ProfilLencanaSectionState();
}

class _ProfilLencanaSectionState extends State<ProfilLencanaSection> {
  bool _isLoading = true;
  List<PencapaianItemModel> _items = [];
  int _totalTerbuka = 0;

  @override
  void initState() {
    super.initState();
    if (widget.preloadedItems != null && widget.preloadedItems!.isNotEmpty) {
      _items = widget.preloadedItems!;
      _totalTerbuka = _items.where((i) => i.isUnlocked).length;
      _isLoading = false;
    } else {
      _fetchLencana();
    }
  }

  @override
  void didUpdateWidget(covariant ProfilLencanaSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.siswaId != widget.siswaId) {
      _fetchLencana();
    }
  }

  Future<void> _fetchLencana() async {
    setState(() {
      _isLoading = true;
    });

    final res = await PencapaianService.getPencapaian(siswaId: widget.siswaId);

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (res['success'] == true) {
          final summary = res['summary'] as PencapaianSummaryModel?;
          _totalTerbuka = summary?.totalTerbuka ?? 0;
          _items = (res['items'] as List<PencapaianItemModel>?) ?? [];
        }
      });
    }
  }

  /// Ambil 6 lencana untuk ditampilkan di profil (utamakan yang sudah terbuka)
  List<PencapaianItemModel> get _displayBadges {
    if (_items.isEmpty) return [];

    final unlocked = _items.where((i) => i.isUnlocked).toList();
    final locked = _items.where((i) => !i.isUnlocked).toList();

    final combined = [...unlocked, ...locked];
    return combined.take(6).toList();
  }

  @override
  Widget build(BuildContext context) {
    final badges = _displayBadges;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Baris: Ikon Medali Bintang + "Lencana Prestasi" + "X Terbuka"
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: Color(0xFFFEF3C7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.stars_rounded,
                  color: Color(0xFFD97706),
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Lencana Prestasi',
                  style: GoogleFonts.poppins(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                    letterSpacing: -0.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              if (_isLoading)
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                Text(
                  '$_totalTerbuka Terbuka',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0066D6),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 14),

          // Grid 3 Kolom Lencana
          if (_isLoading && badges.isEmpty)
            _buildLoadingGrid()
          else if (badges.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Center(
                child: Text(
                  'Belum ada lencana yang tersedia.',
                  style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF94A3B8)),
                ),
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                const spacing = 8.0;
                final itemWidth = (constraints.maxWidth - (spacing * 2)) / 3;

                return Wrap(
                  spacing: spacing,
                  runSpacing: 10,
                  children: badges.map((item) {
                    return SizedBox(
                      width: itemWidth,
                      child: _buildBadgeCard(context, item),
                    );
                  }).toList(),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildBadgeCard(BuildContext context, PencapaianItemModel item) {
    final isLocked = !item.isUnlocked;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showBadgeDialog(context, item),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isLocked ? const Color(0xFFF1F5F9) : item.iconColor.withValues(alpha: 0.15),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Lingkaran Ikon Lencana
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isLocked ? const Color(0xFFE2E8F0) : item.iconBgColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: isLocked
                          ? Colors.transparent
                          : item.iconColor.withValues(alpha: 0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    isLocked ? Icons.lock_outline_rounded : item.icon,
                    color: isLocked ? const Color(0xFF94A3B8) : item.iconColor,
                    size: 22,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Judul Lencana
              Text(
                item.title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isLocked ? const Color(0xFF94A3B8) : const Color(0xFF0F172A),
                ),
              ),

              const SizedBox(height: 2),

              // Subtitle / Status
              Text(
                isLocked ? (item.progressText.isNotEmpty ? item.progressText : 'Terkunci') : item.info,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w500,
                  color: isLocked ? const Color(0xFF94A3B8) : const Color(0xFF0066D6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBadgeDialog(BuildContext context, PencapaianItemModel item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: item.isUnlocked ? item.iconBgColor : const Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                item.isUnlocked ? item.icon : Icons.lock_outline_rounded,
                color: item.isUnlocked ? item.iconColor : const Color(0xFF94A3B8),
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                item.title,
                style: GoogleFonts.poppins(fontSize: 15.5, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.description,
              style: GoogleFonts.poppins(
                fontSize: 12.5,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF475569),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    item.isUnlocked ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                    size: 14,
                    color: item.isUnlocked ? const Color(0xFF059669) : const Color(0xFF64748B),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      item.isUnlocked
                          ? 'Telah Terbuka: ${item.info}'
                          : (item.progressText.isNotEmpty ? 'Progres: ${item.progressText}' : 'Status: Masih Terkunci'),
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF334155),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Tutup',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF64748B),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0066D6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => DetailPencapaianPage(item: item),
                ),
              );
            },
            child: Text(
              'Lihat Detail',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 8.0;
        final itemWidth = (constraints.maxWidth - (spacing * 2)) / 3;

        return Wrap(
          spacing: spacing,
          runSpacing: 10,
          children: List.generate(6, (index) {
            return SizedBox(
              width: itemWidth,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE2E8F0),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 50,
                      height: 10,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

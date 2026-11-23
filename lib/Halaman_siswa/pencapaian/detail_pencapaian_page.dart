import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/pencapaian_model.dart';
import '../../widgets/student_background.dart';

/// Halaman Detail Pencapaian / Achievement Siswa.
/// Menampilkan informasi lengkap satu lencana: ikon besar, status, tanggal perolehan,
/// deskripsi mendalam tentang lencana, kriteria pencapaian, dan lencana terkait dinamis.
class DetailPencapaianPage extends StatelessWidget {
  final PencapaianItemModel? item;
  final String? title;
  final String? description;
  final String? info;
  final String? status;
  final IconData? icon;
  final Color? iconColor;
  final Color? iconBgColor;
  final String? tentang;
  final List<String>? kriteria;

  const DetailPencapaianPage({
    super.key,
    this.item,
    this.title,
    this.description,
    this.info,
    this.status,
    this.icon,
    this.iconColor,
    this.iconBgColor,
    this.tentang,
    this.kriteria,
  });

  String get _title => item?.title ?? title ?? 'Lencana Prestasi';
  String get _description => item?.description ?? description ?? 'Selesaikan tantangan untuk membuka.';
  String get _info => item?.unlockedAt ?? item?.info ?? info ?? '-';
  String get _status => item?.status ?? status ?? 'Terkunci';
  bool get _isUnlocked => item?.isUnlocked ?? (_status.toLowerCase() != 'terkunci');
  IconData get _icon => item?.icon ?? icon ?? Icons.military_tech_rounded;
  Color get _iconColor => item?.iconColor ?? iconColor ?? const Color(0xFF0066D6);
  Color get _iconBgColor => item?.iconBgColor ?? iconBgColor ?? const Color(0xFFDBEAFE);

  String get _tentang {
    if (item != null && item!.tentang.isNotEmpty) {
      return item!.tentang;
    }
    if (tentang != null && tentang!.isNotEmpty) {
      return tentang!;
    }
    return 'Lencana ini diberikan kepada siswa yang berhasil menuntaskan modul aktivitas dan mencapai target pembelajaran yang ditetapkan.';
  }

  List<String> get _kriteriaList {
    if (item != null && item!.kriteria.isNotEmpty) {
      return item!.kriteria;
    }
    if (kriteria != null && kriteria!.isNotEmpty) {
      return kriteria!;
    }
    return [
      'Menyelesaikan materi dan latihan terkait',
      'Mendapatkan skor evaluasi di atas standar kelulusan KKM',
      'Konsisten dalam aktivitas belajar di kelas',
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Warna badge berdasarkan status
    Color badgeBgColor;
    Color badgeTextColor;
    String badgeText;

    if (_status.toLowerCase() == 'langka') {
      badgeBgColor = const Color(0xFFFEF3C7);
      badgeTextColor = const Color(0xFFD97706);
      badgeText = _isUnlocked ? 'Lencana Langka ⭐' : 'Langka (Terkunci)';
    } else if (_isUnlocked) {
      if (_status.toLowerCase() == 'selesai') {
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

    return StudentBackground(
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            children: [
              const SizedBox(height: 8),

              // 1. Header: Tombol Kembali + Judul + Share
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0E4E93).withValues(alpha: 0.10),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_back_rounded,
                          color: Color(0xFF0E4E93),
                          size: 20,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  Text(
                    'Detail Pencapaian',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),

                  const Spacer(),

                  // Tombol Berbagi
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Pencapaian "$_title" berhasil disalin!',
                            style: GoogleFonts.poppins(fontSize: 12.5),
                          ),
                          backgroundColor: const Color(0xFF0066D6),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0E4E93).withValues(alpha: 0.10),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.share_rounded,
                          color: Color(0xFF0E4E93),
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // 2. Kartu Detail Utama Lencana
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0E4E93).withValues(alpha: 0.08),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Icon Besar Pencapaian dengan Dekorasi Glowing
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Lingkaran dekorasi luar
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _iconBgColor.withValues(alpha: 0.4),
                          ),
                        ),
                        // Lingkaran utama
                        Container(
                          width: 76,
                          height: 76,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isUnlocked ? _iconBgColor : const Color(0xFFF1F5F9),
                            boxShadow: [
                              BoxShadow(
                                color: _isUnlocked
                                    ? _iconColor.withValues(alpha: 0.25)
                                    : Colors.black.withValues(alpha: 0.05),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              _isUnlocked ? _icon : Icons.lock_outline_rounded,
                              color: _isUnlocked ? _iconColor : const Color(0xFF94A3B8),
                              size: 36,
                            ),
                          ),
                        ),
                        // Dekorasi bintang kecil
                        if (_isUnlocked) ...[
                          Positioned(
                            top: 4,
                            right: 8,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF38BDF8),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 12,
                            left: 6,
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFFBBF24),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            right: 4,
                            child: Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF34D399),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Badge Status
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: badgeBgColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        badgeText,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: badgeTextColor,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Judul Pencapaian
                    Text(
                      _title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F172A),
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Deskripsi Singkat
                    Text(
                      _description,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF64748B),
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Tanggal Diperoleh / Progress Text
                    if (_isUnlocked)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.calendar_today_rounded,
                            color: Color(0xFF94A3B8),
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Status: $_info',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF0066D6),
                            ),
                          ),
                        ],
                      )
                    else if (item != null && item!.progressText.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Progres saat ini:',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                                Text(
                                  item!.progressText,
                                  style: GoogleFonts.poppins(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF1E293B),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: item!.progressPercent.clamp(0.0, 1.0),
                                minHeight: 6,
                                backgroundColor: const Color(0xFFE2E8F0),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  _iconColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 3. Tentang Lencana (Dinamis dari Backend)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0E4E93).withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.info_outline_rounded,
                              color: Color(0xFFD97706),
                              size: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Tentang Lencana',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _tentang,
                      style: GoogleFonts.poppins(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF64748B),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // 4. Kriteria Memperoleh Lencana (Dinamis dari Backend)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0E4E93).withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kriteria Memperoleh',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._kriteriaList.map((kriteriaText) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _buildKriteriaItem(kriteriaText),
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // 5. Pencapaian Terkait Lainnya
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0E4E93).withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pencapaian Terkait',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildRelatedBadge(
                          Icons.local_fire_department_rounded,
                          const Color(0xFFDC2626),
                          const Color(0xFFFEE2E2),
                        ),
                        const SizedBox(width: 12),
                        _buildRelatedBadge(
                          Icons.sports_esports_rounded,
                          const Color(0xFF7C3AED),
                          const Color(0xFFEDE9FE),
                        ),
                        const SizedBox(width: 12),
                        _buildRelatedBadge(
                          Icons.check_circle_rounded,
                          const Color(0xFF059669),
                          const Color(0xFFD1FAE5),
                        ),
                        const SizedBox(width: 12),
                        _buildRelatedBadge(
                          Icons.emoji_events_rounded,
                          const Color(0xFFCA8A04),
                          const Color(0xFFFEF9C3),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // 6. Pesan Motivasi
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F9FF),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFBAE6FD),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDBEAFE),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.rocket_launch_rounded,
                          color: Color(0xFF2563EB),
                          size: 22,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Terus Tingkatkan Prestasimu!',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Kumpulkan poin, selesaikan modul, dan raih seluruh lencana bahasa Inggris!',
                            style: GoogleFonts.poppins(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF64748B),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  /// Builder item kriteria dengan ikon centang hijau
  Widget _buildKriteriaItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.check_circle_rounded,
          color: Color(0xFF059669),
          size: 18,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF475569),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  /// Builder badge pencapaian terkait
  Widget _buildRelatedBadge(IconData icon, Color iconColor, Color bgColor) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: iconColor.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          icon,
          color: iconColor,
          size: 22,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/student_background.dart';

/// Halaman Detail Pencapaian / Achievement.
/// Menampilkan informasi lengkap satu lencana: deskripsi, kriteria,
/// pencapaian terkait, dan pesan motivasi.
class DetailPencapaianPage extends StatelessWidget {
  final String title;
  final String description;
  final String info;
  final String status;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;

  const DetailPencapaianPage({
    super.key,
    required this.title,
    required this.description,
    required this.info,
    required this.status,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
  });

  @override
  Widget build(BuildContext context) {
    // Warna badge berdasarkan status
    Color badgeBgColor;
    Color badgeTextColor;
    String badgeText;

    switch (status) {
      case 'Terbuka':
        badgeBgColor = const Color(0xFFD1FAE5);
        badgeTextColor = const Color(0xFF059669);
        badgeText = 'Terbuka';
        break;
      case 'Selesai':
        badgeBgColor = const Color(0xFFD1FAE5);
        badgeTextColor = const Color(0xFF059669);
        badgeText = 'Selesai';
        break;
      case 'Terkunci':
        badgeBgColor = const Color(0xFFF1F5F9);
        badgeTextColor = const Color(0xFF94A3B8);
        badgeText = 'Terkunci';
        break;
      default:
        badgeBgColor = const Color(0xFFFEF3C7);
        badgeTextColor = const Color(0xFFD97706);
        badgeText = status;
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
                  // Tombol Kembali
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

                  // Judul
                  Text(
                    'Detail Pencapaian',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),

                  const Spacer(),

                  // Tombol Share
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Fitur berbagi segera hadir!',
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

              const SizedBox(height: 36),

              // 2. Kartu Detail Utama
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
                    // Icon Besar Pencapaian dengan Dekorasi
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Lingkaran dekorasi luar
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: iconBgColor.withValues(alpha: 0.4),
                          ),
                        ),
                        // Lingkaran utama
                        Container(
                          width: 76,
                          height: 76,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: iconBgColor,
                            boxShadow: [
                              BoxShadow(
                                color: iconColor.withValues(alpha: 0.25),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              icon,
                              color: iconColor,
                              size: 36,
                            ),
                          ),
                        ),
                        // Dekorasi confetti kecil
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
                        Positioned(
                          bottom: 4,
                          left: 12,
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFF472B6),
                            ),
                          ),
                        ),
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
                      title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F172A),
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Deskripsi Singkat
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF64748B),
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Tanggal Diperoleh
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
                          'Diperoleh: $info',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 3. Tentang Lencana
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
                    // Header Tentang Lencana
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
                      'Lencana ini diberikan kepada siswa yang berhasil masuk ke dalam 10 besar peringkat RPL 1 di kelas berdasarkan hasil kombinasi aktivitas belajar, quiz, dan latihan.',
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

              // 4. Kriteria
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
                      'Kriteria',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildKriteriaItem('Menyelesaikan minimal 5 materi RPL 1'),
                    const SizedBox(height: 8),
                    _buildKriteriaItem('Mendapatkan nilai quiz rata-rata ≥ 85'),
                    const SizedBox(height: 8),
                    _buildKriteriaItem('Aktif berkontribusi dalam aktivitas kelas'),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // 5. Pencapaian Terkait
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
                          Icons.wb_sunny_rounded,
                          const Color(0xFFEA580C),
                          const Color(0xFFFFF7ED),
                        ),
                        const SizedBox(width: 12),
                        _buildRelatedBadge(
                          Icons.check_circle_rounded,
                          const Color(0xFF059669),
                          const Color(0xFFD1FAE5),
                        ),
                        const SizedBox(width: 12),
                        _buildRelatedBadge(
                          Icons.star_rounded,
                          const Color(0xFF0066D6),
                          const Color(0xFFDBEAFE),
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
                            'Pertahankan semangatmu!',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Masih banyak lencana keren lainnya yang bisa kamu raih!',
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

  /// Builder item kriteria dengan ikon centang hijau.
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

  /// Builder badge pencapaian terkait (lingkaran icon).
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

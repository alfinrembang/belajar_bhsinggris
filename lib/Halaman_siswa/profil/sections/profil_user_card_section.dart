import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../models/siswa_model.dart';

/// Section Kartu Profil Siswa: Menampilkan Data Dinamis Siswa (Nama Lengkap, NISN,
/// No Absen, Kelas, Sekolah), Status Aktif, Tombol Edit, serta Level & Progress Bar.
class ProfilUserCardSection extends StatelessWidget {
  final SiswaModel? siswa;
  final VoidCallback? onEditTap;

  const ProfilUserCardSection({
    super.key,
    this.siswa,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Data Dinamis Siswa dari Hasil Registrasi / Login
    final namaTampil = (siswa != null && siswa!.namaLengkap.isNotEmpty)
        ? siswa!.namaLengkap
        : 'Budi Pratama';

    final nisnTampil = (siswa != null && siswa!.nisn != null && siswa!.nisn!.isNotEmpty)
        ? siswa!.nisn!
        : ((siswa != null && siswa!.nis != null && siswa!.nis!.isNotEmpty)
            ? siswa!.nis!
            : '02948474784');

    final noAbsenTampil = (siswa != null && siswa!.noAbsen != null && siswa!.noAbsen!.isNotEmpty)
        ? siswa!.noAbsen!
        : ((siswa != null && siswa!.noKelas != null && siswa!.noKelas!.isNotEmpty)
            ? siswa!.noKelas!
            : '44');

    final kelasTampil = (siswa != null && siswa!.kelasLengkap != null && siswa!.kelasLengkap!.isNotEmpty)
        ? siswa!.kelasLengkap!
        : ((siswa != null && siswa!.kelas != null && siswa!.kelas!.isNotEmpty)
            ? siswa!.kelas!
            : 'VII RPL');

    const sekolahTampil = 'SMK PGRI 5 JEMBER';

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
          // 1. Baris Atas: Avatar Karakter, Nama, Sekolah, Badge AKTIF, & Tombol Edit
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar Lingkaran Profil (Mendukung Foto Kustom & Inisial Huruf)
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFF6565),
                      Color(0xFFFF416C),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF416C).withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: (siswa?.foto != null &&
                          siswa!.foto!.isNotEmpty &&
                          File(siswa!.foto!).existsSync())
                      ? Image.file(
                          File(siswa!.foto!),
                          fit: BoxFit.cover,
                          width: 52,
                          height: 52,
                        )
                      : Center(
                          child: Text(
                            namaTampil.trim().isNotEmpty
                                ? namaTampil.trim()[0].toUpperCase()
                                : 'B',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                ),
              ),

              const SizedBox(width: 12),

              // Nama Lengkap & Asal Sekolah
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      namaTampil,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F172A),
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 1.5),
                    Text(
                      sekolahTampil,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Badge Status "● AKTIF"
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                decoration: BoxDecoration(
                  color: const Color(0xFFD1FAE5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '● AKTIF',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF059669),
                  ),
                ),
              ),

              const SizedBox(width: 6),

              // Tombol Edit Pensil
              InkWell(
                onTap: onEditTap ??
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fitur edit profil segera hadir!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.edit_outlined,
                    size: 14,
                    color: Color(0xFF4F46E5),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // 2. Baris Tengah: Kotak Data Siswa (NISN, No Absen, Kelas)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F4FD),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                // Kolom 1: NISN
                Expanded(
                  child: _buildDataColumn(
                    icon: Icons.menu_book_rounded,
                    label: 'Nisn',
                    value: nisnTampil,
                  ),
                ),

                Container(
                  width: 1,
                  height: 28,
                  color: const Color(0xFFCBD5E1),
                ),

                // Kolom 2: No Absen
                Expanded(
                  child: _buildDataColumn(
                    icon: Icons.assignment_outlined,
                    label: 'No Absen',
                    value: noAbsenTampil,
                  ),
                ),

                Container(
                  width: 1,
                  height: 28,
                  color: const Color(0xFFCBD5E1),
                ),

                // Kolom 3: Kelas
                Expanded(
                  child: _buildDataColumn(
                    icon: Icons.school_rounded,
                    label: 'Kelas',
                    value: kelasTampil,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // 3. Baris Bawah: Kotak Level & Progress Bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F4FD),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Level
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Lvl',
                      style: GoogleFonts.poppins(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      '1',
                      style: GoogleFonts.poppins(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    height: 8,
                    width: double.infinity,
                    color: Colors.white,
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: 0.65,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF0A1B6B),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataColumn({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 11.5, color: const Color(0xFF64748B)),
            const SizedBox(width: 3.5),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
            fontSize: 11.5,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }
}

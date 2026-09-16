import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/custom_button.dart';

/// Section Random Test: Menampilkan Kartu Uji Kemampuan Soal Acak
/// & Tombol Mulai Test menggunakan CustomButton konsisten.
class RandomTestSection extends StatelessWidget {
  final VoidCallback? onMulaiTestTap;

  const RandomTestSection({
    super.key,
    this.onMulaiTestTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF3FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFDBEAFE),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00386B).withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris 1: Ikon Dadu & Teks Informasi
          Row(
            children: [
              // Ikon Dadu 3D dengan warna cerah Indigo/Ungu (bukan hitam)
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E7FF),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFFC7D2FE),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.casino_rounded,
                  color: Color(0xFF4F46E5), // Indigo Cerah Modern
                  size: 24,
                ),
              ),

              const SizedBox(width: 12),

              // Deskripsi Singkat
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Random Test',
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Uji kemampuan dengan\nsoal acak sekarang!',
                      style: GoogleFonts.poppins(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF64748B),
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Baris 2: Tombol "Mulai Test >" menggunakan CustomButton
          CustomButton(
            text: 'Mulai Test',
            height: 38,
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            borderRadius: BorderRadius.circular(14),
            icon: Icons.chevron_right_rounded,
            iconSize: 16,
            onTap: onMulaiTestTap,
          ),
        ],
      ),
    );
  }
}

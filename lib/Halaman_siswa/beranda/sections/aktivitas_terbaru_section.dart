import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Model sederhana data Aktivitas Siswa
class AktivitasItem {
  final String judul;
  final String tanggal;
  final String status;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;

  const AktivitasItem({
    required this.judul,
    required this.tanggal,
    required this.status,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
  });
}

/// Section Aktivitas Terbaru: Menampilkan Daftar Riwayat Aktivitas & Status Belajar.
class AktivitasTerbaruSection extends StatelessWidget {
  final VoidCallback? onLihatSemuaTap;
  final List<AktivitasItem>? listAktivitas;

  const AktivitasTerbaruSection({
    super.key,
    this.onLihatSemuaTap,
    this.listAktivitas,
  });

  @override
  Widget build(BuildContext context) {
    final List<AktivitasItem> items = listAktivitas ?? const [
      AktivitasItem(
        judul: 'Listening – Daily Practice',
        tanggal: '19 Mei 2029',
        status: 'selesai',
        icon: Icons.headphones_rounded,
        iconColor: Color(0xFF0075DE),
        iconBgColor: Color(0xFFE8F3FF),
      ),
      AktivitasItem(
        judul: 'Listening – Daily Practice',
        tanggal: '19 Mei 2029',
        status: 'selesai',
        icon: Icons.headphones_rounded,
        iconColor: Color(0xFF0075DE),
        iconBgColor: Color(0xFFE8F3FF),
      ),
    ];

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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
          child: Column(
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isLast = index == items.length - 1;

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        // Ikon Aktivitas Berwarna Cerah
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

                        // Judul & Tanggal
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
                              Text(
                                item.tanggal,
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Badge Status Hijau "selesai"
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 3.5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF86EFAC).withValues(alpha: 0.60),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            item.status,
                            style: GoogleFonts.poppins(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF15803D),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (!isLast)
                    const Divider(
                      height: 16,
                      thickness: 0.8,
                      color: Color(0xFFF1F5F9),
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

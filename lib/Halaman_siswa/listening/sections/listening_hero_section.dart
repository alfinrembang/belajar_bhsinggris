import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Section Hero Banner Listening: Judul Besar "Listening", Deskripsi,
/// dan Maskot Rakun Headphone (assets/images/rakun_listening.png).
class ListeningHeroSection extends StatelessWidget {
  final String? title;
  final String? subtitle;

  const ListeningHeroSection({
    super.key,
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTitle = (title != null && title!.trim().isNotEmpty) ? title! : 'Listening';
    final effectiveSubtitle = (subtitle != null && subtitle!.trim().isNotEmpty)
        ? subtitle!
        : 'Dengarkan percakapan atau pengumuman, lalu jawab pertanyaan yang sesuai.';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF), // Soft Sky/Pastel Blue Sesuai Mockup
        borderRadius: BorderRadius.circular(22),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 0, 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Sisi Kiri: Teks Judul Besar "Listening" & Deskripsi
              Expanded(
                flex: 48,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      effectiveTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: effectiveTitle.length > 18 ? 20 : 26,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0056D2), // Electric Royal Blue
                        height: 1.15,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      effectiveSubtitle,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF334155), // Dark Slate
                        height: 1.38,
                      ),
                    ),
                  ],
                ),
              ),

              // Sisi Kanan: Ilustrasi Maskot Rakun (Besar & Penuh Mengisi Sisi Kanan)
              Expanded(
                flex: 52,
                child: Transform.scale(
                  scale: 1.25,
                  alignment: Alignment.centerRight,
                  child: Image.asset(
                    'assets/images/rakun_listening.png',
                    height: 195,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/rakun_materi.png',
                        height: 195,
                        fit: BoxFit.contain,
                        errorBuilder: (ctx, err, st) {
                          return const Center(
                            child: Icon(
                              Icons.headphones_rounded,
                              size: 80,
                              color: Color(0xFF0056D2),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

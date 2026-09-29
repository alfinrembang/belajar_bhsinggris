import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Section Header Halaman Isi Materi: Tombol Kembali, Judul Materi, & Tombol Bookmark.
class IsiMateriHeaderSection extends StatelessWidget {
  final String judulMateri;
  final bool isBookmarked;
  final VoidCallback? onBackTap;
  final VoidCallback? onBookmarkTap;

  const IsiMateriHeaderSection({
    super.key,
    this.judulMateri = 'Descriptive Text',
    this.isBookmarked = false,
    this.onBackTap,
    this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            // 1. Tombol Panah Kembali
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onBackTap ?? () => Navigator.of(context).pop(),
                borderRadius: BorderRadius.circular(12),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: Color(0xFF0F172A),
                    size: 24,
                  ),
                ),
              ),
            ),

            // 2. Judul Materi (Tengah)
            Expanded(
              child: Text(
                judulMateri,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ),

            // 3. Tombol Bookmark
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onBookmarkTap,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    isBookmarked
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_outline_rounded,
                    color: isBookmarked
                        ? const Color(0xFF0066D6)
                        : const Color(0xFF0F172A),
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Divider(
          height: 1,
          thickness: 1,
          color: Color(0xFFF1F5F9),
        ),
      ],
    );
  }
}

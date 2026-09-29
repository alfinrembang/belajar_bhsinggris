import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Section Header Listening: Tombol Kembali, Judul "Listening", dan Tombol Bookmark.
class ListeningHeaderSection extends StatelessWidget {
  final bool isBookmarked;
  final VoidCallback onBackTap;
  final VoidCallback onBookmarkTap;

  const ListeningHeaderSection({
    super.key,
    required this.isBookmarked,
    required this.onBackTap,
    required this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 1. Tombol Kembali
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onBackTap,
            borderRadius: BorderRadius.circular(12),
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(
                Icons.arrow_back_rounded,
                color: Color(0xFF0F172A),
                size: 24,
              ),
            ),
          ),
        ),

        // 2. Judul "Listening" (Bold Italic Sesuai Mockup)
        Expanded(
          child: Text(
            'Listening',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
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
              padding: const EdgeInsets.all(6),
              child: Icon(
                isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                color: isBookmarked ? const Color(0xFF0056D2) : const Color(0xFF0F172A),
                size: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

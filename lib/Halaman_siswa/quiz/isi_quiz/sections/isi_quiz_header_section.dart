import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Section Header Isi Quiz: Tombol Tutup (X), Judul Kuis, dan Timer Countdown.
class IsiQuizHeaderSection extends StatelessWidget {
  final String title;
  final VoidCallback onCloseTap;
  final String? timerText;
  final bool isTimerWarning;

  const IsiQuizHeaderSection({
    super.key,
    required this.title,
    required this.onCloseTap,
    this.timerText,
    this.isTimerWarning = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 1. Tombol (X) Bulat Elegan
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onCloseTap,
            borderRadius: BorderRadius.circular(22),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFFEFF6FF), // Soft Pastel Blue
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.close_rounded,
                  color: Color(0xFF0F172A),
                  size: 20,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        // 2. Judul Kuis
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
              letterSpacing: -0.2,
            ),
          ),
        ),

        // 3. Badge Timer Countdown
        if (timerText != null) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: isTimerWarning ? const Color(0xFFFEE2E2) : const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isTimerWarning ? const Color(0xFFEF4444) : const Color(0xFF3B82F6).withValues(alpha: 0.5),
                width: 1.2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.timer_outlined,
                  size: 14,
                  color: isTimerWarning ? const Color(0xFFEF4444) : const Color(0xFF1D4ED8),
                ),
                const SizedBox(width: 4),
                Text(
                  timerText!,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isTimerWarning ? const Color(0xFFEF4444) : const Color(0xFF1D4ED8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

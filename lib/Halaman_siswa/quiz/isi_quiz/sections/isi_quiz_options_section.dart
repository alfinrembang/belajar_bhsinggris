import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Section Opsi Pilihan Jawaban A, B, C, D (Sesuai Desain Mockup).
class IsiQuizOptionsSection extends StatelessWidget {
  final List<String> options;
  final int? selectedIndex;
  final ValueChanged<int> onSelectOption;

  const IsiQuizOptionsSection({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onSelectOption,
  });

  static const List<String> letters = ['A', 'B', 'C', 'D', 'E'];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: options.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final isSelected = selectedIndex == index;
        final letter = index < letters.length ? letters[index] : '${index + 1}';
        final optionText = options[index];

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onSelectOption(index),
            borderRadius: BorderRadius.circular(18),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected ? const Color(0xFF0056D2) : const Color(0xFFE2E8F0),
                  width: isSelected ? 1.5 : 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? const Color(0xFF0056D2).withValues(alpha: 0.08)
                        : const Color(0xFF00386B).withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Badge Huruf Opsi (A, B, C, D)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF0056D2) : const Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        letter,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: isSelected ? Colors.white : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  // Teks Pilihan Jawaban
                  Expanded(
                    child: Text(
                      optionText,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                        color: isSelected ? const Color(0xFF0F172A) : const Color(0xFF475569),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

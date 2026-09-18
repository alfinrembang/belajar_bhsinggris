import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Section Judul "Game" & Filter Chips Kategori Game (Semua, Text, Grammar, Vocabulary, Listening).
class GameFilterSection extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;

  const GameFilterSection({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  static const List<String> categories = [
    'Semua',
    'Text',
    'Grammar',
    'Vocabulary',
    'Listening',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Judul & Subjudul
        Text(
          'Game',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0F172A),
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Asah Kemampuan & Bersenang Senang',
          style: GoogleFonts.poppins(
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF64748B),
          ),
        ),

        const SizedBox(height: 12),

        // Horizontal Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: categories.map((cat) {
              final isSelected = selectedCategory.toLowerCase() == cat.toLowerCase();
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => onCategoryChanged(cat),
                    borderRadius: BorderRadius.circular(14),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7.5),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF0A1B6B) // Navy pekat aktif
                            : const Color(0xFFD4DCFF), // Pastel lavender/blue
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: const Color(0xFF0A1B6B).withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : null,
                      ),
                      child: Text(
                        cat,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                          color: isSelected ? Colors.white : const Color(0xFF1E293B),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

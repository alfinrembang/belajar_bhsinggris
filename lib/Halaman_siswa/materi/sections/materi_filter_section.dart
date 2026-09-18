import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Section Filter Materi: Menampilkan Pilihan Kategori (Text, Grammar, Vocabulary, All)
/// dengan palet warna biru cerah konsisten dengan Beranda.
class MateriFilterSection extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String>? onCategoryChanged;
  final List<String> categories;

  const MateriFilterSection({
    super.key,
    this.selectedCategory = 'Text',
    this.onCategoryChanged,
    this.categories = const ['Text', 'Grammar', 'Vocabulary', 'All'],
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: categories.map((cat) {
          final isSelected = cat.toLowerCase() == selectedCategory.toLowerCase();
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InkWell(
              onTap: () => onCategoryChanged?.call(cat),
              borderRadius: BorderRadius.circular(14),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 26,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF0066D6)
                      : const Color(0xFFE8EEF8),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFF0066D6).withValues(alpha: 0.28),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  cat,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: isSelected ? Colors.white : const Color(0xFF0066D6),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

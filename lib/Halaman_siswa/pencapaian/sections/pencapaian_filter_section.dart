import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Section Filter Pencapaian.
/// Menampilkan tab filter: Semua, Terbuka, Terkunci, Langka.
class PencapaianFilterSection extends StatelessWidget {
  final String activeFilter;
  final ValueChanged<String> onFilterChanged;

  const PencapaianFilterSection({
    super.key,
    required this.activeFilter,
    required this.onFilterChanged,
  });

  static const List<String> _filters = ['Semua', 'Terbuka', 'Terkunci', 'Langka'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _filters.length,
        separatorBuilder: (_, _2) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isActive = activeFilter == filter;

          return GestureDetector(
            onTap: () => onFilterChanged(filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFF0066D6) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isActive
                      ? const Color(0xFF0066D6)
                      : const Color(0xFFE2E8F0),
                  width: 1.2,
                ),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: const Color(0xFF0066D6).withValues(alpha: 0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: Text(
                  filter,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isActive ? Colors.white : const Color(0xFF64748B),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

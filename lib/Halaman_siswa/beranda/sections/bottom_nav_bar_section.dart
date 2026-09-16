import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Section Bottom Navigation Bar: Menampilkan 5 Menu Navigasi Siswa
/// (Beranda, Materi, Quiz, Game, Profil).
class BottomNavBarSection extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const BottomNavBarSection({
    super.key,
    this.currentIndex = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00386B).withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 62,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                label: 'Beranda',
                icon: Icons.home_rounded,
                selectedIcon: Icons.home_rounded,
              ),
              _buildNavItem(
                index: 1,
                label: 'Materi',
                icon: Icons.menu_book_rounded,
                selectedIcon: Icons.menu_book_rounded,
              ),
              _buildNavItem(
                index: 2,
                label: 'Quiz',
                icon: Icons.edit_note_rounded,
                selectedIcon: Icons.edit_note_rounded,
              ),
              _buildNavItem(
                index: 3,
                label: 'Game',
                icon: Icons.sports_esports_outlined,
                selectedIcon: Icons.sports_esports_rounded,
              ),
              _buildNavItem(
                index: 4,
                label: 'Profil',
                icon: Icons.account_circle_outlined,
                selectedIcon: Icons.account_circle_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required IconData icon,
    required IconData selectedIcon,
  }) {
    final bool isSelected = currentIndex == index;
    final Color activeColor = const Color(0xFF0066D6);
    final Color inactiveColor = const Color(0xFF64748B);

    return Expanded(
      child: InkWell(
        onTap: () => onTap?.call(index),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              color: isSelected ? activeColor : inactiveColor,
              size: 23,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 10.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? activeColor : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

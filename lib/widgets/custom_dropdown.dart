import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDropdownField extends StatelessWidget {
  final String label;
  final String? value;
  final String hintText;
  final IconData prefixIcon;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.hintText,
    required this.prefixIcon,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 2, left: 2),
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF334155),
            ),
          ),
        ),
        Container(
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFFEDF2F7),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: const Color(0xFFDCE4EF),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F3156).withValues(alpha: 0.05),
                blurRadius: 8,
                spreadRadius: 0,
                offset: const Offset(0, 3),
              ),
              const BoxShadow(
                color: Colors.white,
                blurRadius: 2,
                offset: Offset(0, -1),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 9),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                prefixIcon,
                color: const Color(0xFF8193AA),
                size: 18,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: value,
                    isExpanded: true,
                    alignment: AlignmentDirectional.centerStart,
                    hint: Text(
                      hintText,
                      style: GoogleFonts.poppins(
                        color: const Color(0xFFA2B1C6),
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        height: 1.2,
                      ),
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Color(0xFF8193AA),
                      size: 18,
                    ),
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    style: GoogleFonts.poppins(
                      fontSize: 13.5,
                      color: const Color(0xFF1E293B),
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                    ),
                    items: items.map((item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: GoogleFonts.poppins(
                            fontSize: 13.5,
                            color: const Color(0xFF1E293B),
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: onChanged,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

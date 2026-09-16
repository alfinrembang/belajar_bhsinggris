import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 3, left: 2),
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
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFEDF2F7),
            borderRadius: BorderRadius.circular(14),
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                prefixIcon,
                color: const Color(0xFF8193AA),
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Transform.translate(
                  offset: const Offset(0, 1),
                  child: TextField(
                    controller: controller,
                    obscureText: obscureText,
                    keyboardType: keyboardType,
                    inputFormatters: inputFormatters,
                    textAlignVertical: TextAlignVertical.center,
                    style: GoogleFonts.poppins(
                      fontSize: 13.5,
                      color: const Color(0xFF1E293B),
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                    ),
                    decoration: InputDecoration(
                      isCollapsed: true,
                      border: InputBorder.none,
                      hintText: hintText,
                      hintStyle: GoogleFonts.poppins(
                        color: const Color(0xFFA2B1C6),
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
              ?suffixIcon,
            ],
          ),
        ),
      ],
    );
  }
}

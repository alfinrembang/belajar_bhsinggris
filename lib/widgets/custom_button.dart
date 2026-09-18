import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Komponen Tombol Reusable (CustomButton) untuk seluruh aplikasi.
/// Memiliki desain gradien konsisten (Kanan: Biru Tua -> Kiri: Biru Muda),
/// efek bayangan elegan, ripple animation, serta mendukung icon trailing & ukuran fleksibel.
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final double height;
  final double? width;
  final double fontSize;
  final FontWeight fontWeight;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final IconData? icon;
  final double iconSize;
  final List<Color>? gradientColors;
  final Alignment begin;
  final Alignment end;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    this.onTap,
    this.height = 42,
    this.width = double.infinity,
    this.fontSize = 16,
    this.fontWeight = FontWeight.bold,
    this.borderRadius,
    this.padding,
    this.icon,
    this.iconSize = 16,
    this.gradientColors,
    this.begin = Alignment.centerLeft,
    this.end = Alignment.centerRight,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? BorderRadius.circular(16);

    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors ??
              const [
                Color(0xFF2CB8FE), // Kiri: Biru muda cerah
                Color(0xFF137EE2), // Menengah: Biru transisi
                Color(0xFF094E96), // Kanan: Biru tua pekat
              ],
          begin: begin,
          end: end,
        ),
        borderRadius: effectiveRadius,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0B63C4).withValues(alpha: 0.32),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: effectiveRadius,
          onTap: isLoading ? null : onTap,
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Row(
                    mainAxisSize: width == null ? MainAxisSize.min : MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        text,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: fontSize,
                          fontWeight: fontWeight,
                          letterSpacing: 0.4,
                        ),
                      ),
                      if (icon != null) ...[
                        const SizedBox(width: 4),
                        Icon(
                          icon,
                          color: Colors.white,
                          size: iconSize,
                        ),
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}


/// Komponen Reusable Toggle Switch (CustomToggleSwitch) yang estetik dan interaktif.
/// Digunakan pada pengaturan notifikasi/pengingat dan opsi toggle lainnya di seluruh aplikasi.
class CustomToggleSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final double width;
  final double height;
  final Color activeColor;
  final Color inactiveColor;
  final Color thumbColor;

  const CustomToggleSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.width = 48,
    this.height = 26,
    this.activeColor = const Color(0xFF2563EB), // Vibrant Electric Blue
    this.inactiveColor = const Color(0xFFCBD5E1), // Soft Gray
    this.thumbColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    final thumbSize = height - 4.5;

    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: width,
        height: height,
        padding: const EdgeInsets.all(2.2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height / 2),
          color: value ? activeColor : inactiveColor,
          boxShadow: [
            BoxShadow(
              color: (value ? activeColor : Colors.black).withValues(alpha: value ? 0.28 : 0.06),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: thumbSize,
            height: thumbSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: thumbColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 4,
                  offset: const Offset(0, 1.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

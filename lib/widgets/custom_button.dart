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

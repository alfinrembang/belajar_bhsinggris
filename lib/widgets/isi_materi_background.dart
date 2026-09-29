import 'package:flutter/material.dart';

/// Komponen Reusable Latar Belakang untuk Seluruh Halaman Isi Materi.
/// Menyediakan kanvas bersih berbingkai estetik, SafeArea, dan tata letak responsif
/// yang konsisten untuk setiap bab materi pembelajaran.
class IsiMateriBackground extends StatelessWidget {
  final Widget child;
  final Widget? bottomNavigationBar;
  final Color backgroundColor;
  final Color canvasColor;
  final EdgeInsetsGeometry? contentPadding;

  const IsiMateriBackground({
    super.key,
    required this.child,
    this.bottomNavigationBar,
    this.backgroundColor = const Color(0xFFF7FAFE),
    this.canvasColor = Colors.white,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Container(
            decoration: BoxDecoration(
              color: canvasColor,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: const Color(0xFFE2E8F0),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.03),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: contentPadding ?? const EdgeInsets.all(16),
                      child: child,
                    ),
                  ),
                  if (bottomNavigationBar != null) ...[
                    bottomNavigationBar!,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

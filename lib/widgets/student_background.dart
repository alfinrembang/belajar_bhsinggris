import 'package:flutter/material.dart';

/// Komponen Latar Belakang Bersama (Reusable) untuk Halaman Siswa.
/// Menampilkan garis lengkungan ombak gradien biru yang ramping (kurus) dan anggun di bagian atas:
/// Sebelah kiri biru tua -> semakin ke kanan semakin menjadi biru muda cerah,
/// serta latar belakang bersih dan sejuk di bagian bawah.
class StudentBackground extends StatelessWidget {
  final Widget child;
  final double? headerHeight;

  const StudentBackground({
    super.key,
    required this.child,
    this.headerHeight,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    // Tinggi header proporsional dan ramping (kurus) agar garis lengkung terlihat jelas di atas kartu
    final effectiveHeight = headerHeight ?? (topPadding + 94);

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFE),
      body: Stack(
        children: [
          // 1a. Bayangan Halus di Bawah Lengkungan Ombak Biru
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: effectiveHeight + 3.5,
            child: ClipPath(
              clipper: const CurvedWaveClipper(),
              child: Container(
                color: const Color(0xFF0E4E93).withValues(alpha: 0.12),
              ),
            ),
          ),

          // 1b. Lengkungan Ombak Gradien Biru Ramping di Bagian Atas
          // Kiri: Biru Tua Pekat -> Kanan: Biru Muda Cerah Segar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: effectiveHeight,
            child: ClipPath(
              clipper: const CurvedWaveClipper(),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFF0E4E93), // Biru Tua Elegan di sebelah kiri
                      Color(0xFF1161B0), // Biru Menengah
                      Color(0xFF1D87DC), // Biru Terang
                      Color(0xFF38BDF8), // Biru Muda Cerah di sebelah kanan
                    ],
                    stops: [0.0, 0.32, 0.68, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // 2. Konten Utama Halaman
          Positioned.fill(
            child: child,
          ),
        ],
      ),
    );
  }
}

/// Custom Clipper untuk menghasilkan lekukan ombak ramping dan halus
/// sesuai dengan referensi desain (tidak terlalu tebal sehingga garis lengkung terlihat jelas).
class CurvedWaveClipper extends CustomClipper<Path> {
  const CurvedWaveClipper();

  @override
  Path getClip(Size size) {
    final path = Path();
    // Garis vertikal di sisi kiri
    path.lineTo(0, size.height - 10);

    // Lengkungan ombak ramping, halus, dan elegan:
    // Melengkung naik lembut di tengah-kiri lalu melandai anggun ke kanan
    path.cubicTo(
      size.width * 0.30,
      size.height - 24,
      size.width * 0.68,
      size.height - 16,
      size.width,
      size.height - 2,
    );

    // Garis ke sudut kanan atas lalu tutup path
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

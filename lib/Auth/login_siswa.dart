import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Halaman_siswa/beranda/beranda_siswa_page.dart';
import '../models/siswa_model.dart';
import '../services/api_service.dart';
import '../widgets/auth_background.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'lupasandi_siswa.dart';
import 'regis_siswa.dart';

class LoginSiswaPage extends StatefulWidget {
  final String? initialEmail;
  final String? initialNisn;

  const LoginSiswaPage({
    super.key,
    this.initialEmail,
    this.initialNisn,
  });

  @override
  State<LoginSiswaPage> createState() => _LoginSiswaPageState();
}

class _LoginSiswaPageState extends State<LoginSiswaPage> {
  // Controller form input
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nisnController = TextEditingController();
  final TextEditingController _sandiController = TextEditingController();

  // State untuk toggle visibilitas kata sandi dan status loading
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Otomatis isi jika dialihkan setelah registrasi berhasil
    if (widget.initialEmail != null && widget.initialEmail!.isNotEmpty) {
      _emailController.text = widget.initialEmail!;
    }
    if (widget.initialNisn != null && widget.initialNisn!.isNotEmpty) {
      _nisnController.text = widget.initialNisn!;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nisnController.dispose();
    _sandiController.dispose();
    super.dispose();
  }

  void _showNotification(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.poppins(fontSize: 12.5),
              ),
            ),
          ],
        ),
        backgroundColor: isError ? const Color(0xFFEF4444) : const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Future<void> _handleMasuk() async {
    final email = _emailController.text.trim();
    final nisn = _nisnController.text.trim();
    final sandi = _sandiController.text.trim();

    if (email.isEmpty && nisn.isEmpty) {
      _showNotification('Masukkan Email atau NISN kamu!', isError: true);
      return;
    }

    if (sandi.isEmpty) {
      _showNotification('Kata sandi wajib diisi!', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await ApiService.loginSiswa(
      email: email.isNotEmpty ? email : null,
      nisn: nisn.isNotEmpty ? nisn : null,
      sandi: sandi,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (result['success'] == true) {
      final SiswaModel? siswa = result['siswa'];
      _showNotification('Selamat datang, ${siswa?.namaLengkap ?? 'Siswa'}!');

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              BerandaSiswaPage(siswa: siswa),
          transitionDuration: const Duration(milliseconds: 650),
          reverseTransitionDuration: const Duration(milliseconds: 550),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubic,
              reverseCurve: Curves.easeInOutCubic,
            );
            return FadeTransition(
              opacity: curvedAnimation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 0.035),
                  end: Offset.zero,
                ).animate(curvedAnimation),
                child: child,
              ),
            );
          },
        ),
      );
    } else {
      _showNotification(result['message'] ?? 'Login gagal!', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 4),

                  // Teks Sambutan 3 Baris Diturunkan Rapat/Dempet di Atas Rakun
                  Transform.translate(
                    offset: const Offset(0, 16),
                    child: Text(
                      "WELCOME\nTO\nSIP",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        height: 1.05,
                        letterSpacing: 2.5,
                        color: Colors.white,
                        shadows: [
                          const Shadow(
                            color: Color(0xFF0255A3),
                            offset: Offset(0, 3),
                            blurRadius: 0,
                          ),
                          const Shadow(
                            color: Color(0xFF003870),
                            offset: Offset(0, 5),
                            blurRadius: 0,
                          ),
                          Shadow(
                            color: const Color(0xFF001F42).withValues(alpha: 0.55),
                            offset: const Offset(0, 8),
                            blurRadius: 14,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Stack untuk Karakter Rakun di atas kartu form
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topCenter,
                    children: [
                      // Kartu Putih Form Login
                      Container(
                        margin: const EdgeInsets.only(top: 96), // Pas di bawah kaki rakun tanpa menutupi badge
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(18, 14, 18, 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.8),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00386B).withValues(alpha: 0.18),
                              blurRadius: 36,
                              spreadRadius: 2,
                              offset: const Offset(0, 14),
                            ),
                            BoxShadow(
                              color: const Color(0xFF00386B).withValues(alpha: 0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Badge Header "Silahkan Masuk Akun"
                            Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 5.5,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEFF4FF),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFFDBEAFE),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF2563EB).withValues(alpha: 0.08),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.login_rounded,
                                      color: Color(0xFF2563EB),
                                      size: 16,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Silahkan Masuk Akun',
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xFF2563EB),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),

                            // 1. Komponen Input: Email
                            CustomTextField(
                              label: 'Email',
                              controller: _emailController,
                              hintText: 'admin@gmail.com',
                              prefixIcon: Icons.mail_outline_rounded,
                              keyboardType: TextInputType.emailAddress,
                            ),

                            const SizedBox(height: 7),

                            // 2. Komponen Input: Nisn
                            CustomTextField(
                              label: 'Nisn',
                              controller: _nisnController,
                              hintText: '0087654321',
                              prefixIcon: Icons.school_outlined,
                              keyboardType: TextInputType.number,
                            ),

                            const SizedBox(height: 7),

                            // 3. Komponen Input: Sandi
                            CustomTextField(
                              label: 'Sandi',
                              controller: _sandiController,
                              hintText: '123456',
                              prefixIcon: Icons.lock_outline_rounded,
                              obscureText: _obscurePassword,
                              suffixIcon: IconButton(
                                splashRadius: 14,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: const Color(0xFFA0AEC0),
                                  size: 18,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),

                            const SizedBox(height: 6),

                            // Tautan Lupa Sandi (Rata Kanan & Estetik)
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) =>
                                          const LupaSandiSiswaPage(),
                                      transitionDuration: const Duration(milliseconds: 650),
                                      reverseTransitionDuration: const Duration(milliseconds: 550),
                                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                        final curvedAnimation = CurvedAnimation(
                                          parent: animation,
                                          curve: Curves.easeInOutCubic,
                                          reverseCurve: Curves.easeInOutCubic,
                                        );
                                        return FadeTransition(
                                          opacity: curvedAnimation,
                                          child: SlideTransition(
                                            position: Tween<Offset>(
                                              begin: const Offset(0.0, 0.035),
                                              end: Offset.zero,
                                            ).animate(curvedAnimation),
                                            child: child,
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                                  child: Text(
                                    'Lupa Sandi?',
                                    style: GoogleFonts.poppins(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF0066D6),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),

                            // Komponen Tombol: Masuk
                            CustomButton(
                              text: 'Masuk',
                              height: 42,
                              isLoading: _isLoading,
                              onTap: _handleMasuk,
                            ),

                            const SizedBox(height: 16),

                            // Link ke Halaman Registrasi
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Belum punya akun? ',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: const Color(0xFF6B7280),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (Navigator.canPop(context)) {
                                      Navigator.pop(context);
                                    } else {
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation, secondaryAnimation) =>
                                              const RegisSiswaPage(),
                                          transitionDuration: const Duration(milliseconds: 650),
                                          reverseTransitionDuration: const Duration(milliseconds: 550),
                                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                            final curvedAnimation = CurvedAnimation(
                                              parent: animation,
                                              curve: Curves.easeInOutCubic,
                                              reverseCurve: Curves.easeInOutCubic,
                                            );
                                            return FadeTransition(
                                              opacity: curvedAnimation,
                                              child: SlideTransition(
                                                position: Tween<Offset>(
                                                  begin: const Offset(0.0, 0.035),
                                                  end: Offset.zero,
                                                ).animate(curvedAnimation),
                                                child: child,
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    }
                                  },
                                  child: Text(
                                    'Daftar',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF0066D6),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Karakter Rakun (Bersandar pas di atas lekukan kartu putih)
                      Positioned(
                        top: 0,
                        child: Image.asset(
                          'assets/images/rakun.png',
                          width: 135,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const SizedBox(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import '../widgets/auth_background.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

/// Halaman Lupa Sandi Siswa (Terhubung ke Backend Laravel).
/// Menyediakan input email untuk verifikasi pemulihan kata sandi.
class LupaSandiSiswaPage extends StatefulWidget {
  const LupaSandiSiswaPage({super.key});

  @override
  State<LupaSandiSiswaPage> createState() => _LupaSandiSiswaPageState();
}

class _LupaSandiSiswaPageState extends State<LupaSandiSiswaPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
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

  Future<void> _handleKirimEmail() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showNotification('Harap masukkan alamat email kamu.', isError: true);
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      _showNotification('Format email tidak valid. Contoh: nama@gmail.com', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await ApiService.lupaSandiSiswa(email: email);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (result['success'] == true) {
      _showSuccessDialog(email);
    } else {
      _showNotification(result['message'] ?? 'Alamat email tidak terdaftar!', isError: true);
    }
  }

  void _showSuccessDialog(String email) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Garis handle bottom sheet
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),

              // Icon Email Terkirim
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFDBEAFE),
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.mark_email_read_rounded,
                  color: Color(0xFF0066D6),
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),

              Text(
                'Tautan Berhasil Dikirim!',
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 8),

              Text(
                'Kami telah mengirimkan instruksi reset kata sandi ke $email. Silakan periksa kotak masuk atau folder spam kamu.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF64748B),
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 22),

              CustomButton(
                text: 'Kembali ke Masuk',
                height: 42,
                onTap: () {
                  Navigator.pop(context); // Tutup bottom sheet
                  Navigator.pop(context); // Kembali ke halaman login
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SafeArea(
          child: Stack(
            children: [
              // Tombol Kembali di Pojok Kiri Atas
              Positioned(
                top: 10,
                left: 14,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Color(0xFF1E293B),
                      size: 16,
                    ),
                  ),
                ),
              ),

              // Konten Form Tengah
              Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 4),

                      // Teks Sambutan 3 Baris Diturunkan Rapat di Atas Rakun
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

                      // Stack Karakter Rakun & Kartu Putih Form
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.topCenter,
                        children: [
                          // Kartu Putih Form Lupa Sandi
                          Container(
                            margin: const EdgeInsets.only(top: 96),
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
                                // Badge Header "Lupa Kata Sandi"
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
                                          Icons.lock_reset_rounded,
                                          color: Color(0xFF2563EB),
                                          size: 17,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Lupa Kata Sandi',
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

                                // Keterangan Informasi
                                Center(
                                  child: Text(
                                    'Masukkan email kamu untuk menerima tautan pemulihan kata sandi akun.',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF64748B),
                                      height: 1.4,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 14),

                                // Komponen Input Tunggal: Email
                                CustomTextField(
                                  label: 'Email Terdaftar',
                                  controller: _emailController,
                                  hintText: 'admin@gmail.com',
                                  prefixIcon: Icons.mail_outline_rounded,
                                  keyboardType: TextInputType.emailAddress,
                                ),

                                const SizedBox(height: 16),

                                // Komponen Tombol: Kirim Tautan Reset
                                CustomButton(
                                  text: 'Kirim Link Reset',
                                  height: 42,
                                  isLoading: _isLoading,
                                  onTap: _handleKirimEmail,
                                ),

                                const SizedBox(height: 16),

                                // Link Kembali ke Halaman Login
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Sudah ingat kata sandi? ',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: const Color(0xFF6B7280),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Masuk',
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

                          // Karakter Rakun Tertidur di Atas Kartu
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
            ],
          ),
        ),
      ),
    );
  }
}

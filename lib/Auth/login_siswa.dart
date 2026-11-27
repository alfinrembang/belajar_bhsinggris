import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Halaman_siswa/beranda/beranda_siswa_page.dart';
import '../models/siswa_model.dart';
import '../services/api_service.dart';
import '../widgets/auth_background.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'lupasandi_siswa.dart';

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
  final TextEditingController _nisnController = TextEditingController();
  final TextEditingController _sandiController = TextEditingController();

  // State untuk toggle visibilitas kata sandi dan status loading
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialNisn != null && widget.initialNisn!.isNotEmpty) {
      _nisnController.text = widget.initialNisn!;
    }
  }

  @override
  void dispose() {
    _nisnController.dispose();
    _sandiController.dispose();
    super.dispose();
  }

  void _showNotification(
    String message, {
    bool isError = false,
    bool showServerAction = false,
  }) {
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
        action: showServerAction
            ? SnackBarAction(
                label: 'Atur IP',
                textColor: Colors.white,
                onPressed: _showServerDialog,
              )
            : null,
        backgroundColor: isError ? const Color(0xFFEF4444) : const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Future<void> _showServerDialog() async {
    final ipController = TextEditingController(
      text: Uri.tryParse(ApiClient.activeBaseUrl)?.host ?? '',
    );
    bool isChecking = false;
    String? statusText;
    bool isSuccessStatus = false;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            Future<void> runAutoDiscovery() async {
              setDialogState(() {
                isChecking = true;
                statusText = 'Mencari server Laravel di jaringan Wi-Fi...';
                isSuccessStatus = false;
              });
              final found = await ApiClient.discoverWorkingBaseUrl();
              if (!dialogContext.mounted) return;
              setDialogState(() {
                isChecking = false;
                if (found != null) {
                  ipController.text = Uri.tryParse(found)?.host ?? found;
                  statusText = 'Terhubung ke:\n$found';
                  isSuccessStatus = true;
                } else {
                  statusText = 'Server tidak ditemukan otomatis. Pastikan laptop & HP di Wi-Fi yang sama dan Laragon/Laravel aktif.';
                  isSuccessStatus = false;
                }
              });
            }

            Future<void> runManualSave() async {
              setDialogState(() {
                isChecking = true;
                statusText = 'Menguji koneksi...';
                isSuccessStatus = false;
              });
              final found = await ApiClient.connectWithManualInput(ipController.text);
              if (!dialogContext.mounted) return;
              setDialogState(() {
                isChecking = false;
                if (found != null) {
                  statusText = 'Berhasil terhubung ke:\n$found';
                  isSuccessStatus = true;
                } else {
                  statusText = 'Gagal terhubung ke IP tersebut. Periksa IP laptop dan pastikan Laragon Apache/Laravel aktif.';
                  isSuccessStatus = false;
                }
              });
            }

            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text(
                'Koneksi Server Laravel',
                style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Server aktif saat ini:\n${ApiClient.activeBaseUrl}',
                    style: GoogleFonts.poppins(fontSize: 11.5, color: const Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: ipController,
                    enabled: !isChecking,
                    decoration: InputDecoration(
                      labelText: 'IP Laptop (contoh: 192.168.9.210)',
                      labelStyle: GoogleFonts.poppins(fontSize: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      isDense: true,
                    ),
                    style: GoogleFonts.poppins(fontSize: 13),
                  ),
                  if (statusText != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      statusText!,
                      style: GoogleFonts.poppins(
                        fontSize: 11.5,
                        color: isSuccessStatus
                            ? const Color(0xFF059669)
                            : const Color(0xFFDC2626),
                      ),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isChecking ? null : () => Navigator.pop(dialogContext),
                  child: Text('Tutup', style: GoogleFonts.poppins(fontSize: 12.5)),
                ),
                TextButton(
                  onPressed: isChecking ? null : runAutoDiscovery,
                  child: Text('Cari Otomatis', style: GoogleFonts.poppins(fontSize: 12.5)),
                ),
                ElevatedButton(
                  onPressed: isChecking ? null : runManualSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0066D6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    isChecking ? 'Menguji...' : 'Simpan & Tes',
                    style: GoogleFonts.poppins(fontSize: 12.5),
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    ipController.dispose();
  }

  Future<void> _handleMasuk() async {
    final nisn = _nisnController.text.trim();
    final sandi = _sandiController.text.trim();

    if (nisn.isEmpty) {
      _showNotification('Masukkan NISN kamu!', isError: true);
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
      nisn: nisn,
      sandi: sandi,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (result['success'] == true) {
      final SiswaModel? siswa = result['siswa'];

      // Simpan sesi login lokal secara persisten (Auto-Login)
      if (siswa != null) {
        await ApiService.saveSession(siswa);
        if (!mounted) return;
      }

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
      _showNotification(
        result['message'] ?? 'Login gagal!',
        isError: true,
        showServerAction: result['isConnectionError'] == true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SafeArea(
          child: Stack(
            children: [
              Center(
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
                      "WELCOME\nTO\nSEP",
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

                            const SizedBox(height: 14),

                            // 1. Komponen Input: NISN
                            CustomTextField(
                              label: 'NISN',
                              controller: _nisnController,
                              hintText: 'Masukkan NISN kamu',
                              prefixIcon: Icons.school_outlined,
                              keyboardType: TextInputType.number,
                            ),

                            const SizedBox(height: 10),

                            // 2. Komponen Input: Kata Sandi
                            CustomTextField(
                              label: 'Kata Sandi',
                              controller: _sandiController,
                              hintText: 'Masukkan kata sandi',
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

                            const SizedBox(height: 12),

                            // Komponen Tombol: Masuk
                            CustomButton(
                              text: 'Masuk',
                              height: 42,
                              isLoading: _isLoading,
                              onTap: _handleMasuk,
                            ),

                            const SizedBox(height: 18),

                            // Informasi Bantuan Akun Siswa
                            Center(
                              child: Text(
                                'Akun siswa didaftarkan oleh sekolah / guru.\nHubungi gurumu jika mengalami kendala masuk.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 11.5,
                                  color: const Color(0xFF64748B),
                                  height: 1.45,
                                ),
                              ),
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
              Positioned(
                top: 6,
                right: 10,
                child: IconButton(
                  tooltip: 'Pengaturan IP Server',
                  onPressed: _showServerDialog,
                  icon: Icon(
                    Icons.wifi_find_rounded,
                    color: Colors.white.withValues(alpha: 0.78),
                    size: 22,
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

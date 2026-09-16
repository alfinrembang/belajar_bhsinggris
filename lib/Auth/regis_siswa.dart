import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import '../widgets/auth_background.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/custom_text_field.dart';
import 'login_siswa.dart';

class RegisSiswaPage extends StatefulWidget {
  const RegisSiswaPage({super.key});

  @override
  State<RegisSiswaPage> createState() => _RegisSiswaPageState();
}

class _RegisSiswaPageState extends State<RegisSiswaPage> {
  // Controller form input teks
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nisnController = TextEditingController();
  final TextEditingController _noAbsenController = TextEditingController();
  final TextEditingController _kelasController = TextEditingController();
  final TextEditingController _jurusanController = TextEditingController();
  final TextEditingController _noKelasController = TextEditingController();
  final TextEditingController _sandiController = TextEditingController();

  // State nilai pilihan dropdown Kelas, Jurusan, & No. Kelas
  String? _selectedKelas;
  String? _selectedJurusan;
  String? _selectedNoKelas;

  // Opsi pilihan dropdown
  final List<String> _listKelas = ['10', '11', '12'];
  final List<String> _listJurusan = ['RPL', 'TSM', 'DKV', 'AK', 'BD', 'TKKR', 'SA', 'MPLB'];
  final List<String> _listNoKelas = ['1', '2', '3'];

  // State untuk toggle visibilitas kata sandi dan loading
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _nisnController.dispose();
    _noAbsenController.dispose();
    _kelasController.dispose();
    _jurusanController.dispose();
    _noKelasController.dispose();
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

  Future<void> _handleDaftar() async {
    final nama = _namaController.text.trim();
    final email = _emailController.text.trim();
    final nisn = _nisnController.text.trim();
    final noAbsen = _noAbsenController.text.trim();
    final sandi = _sandiController.text.trim();

    if (nama.isEmpty) {
      _showNotification('Nama lengkap wajib diisi!', isError: true);
      return;
    }
    if (email.isEmpty || !email.contains('@')) {
      _showNotification('Alamat email tidak valid!', isError: true);
      return;
    }
    if (nisn.isEmpty) {
      _showNotification('NISN wajib diisi!', isError: true);
      return;
    }
    if (noAbsen.isEmpty) {
      _showNotification('Nomor absen wajib diisi!', isError: true);
      return;
    }
    final absenNum = int.tryParse(noAbsen);
    if (absenNum == null || absenNum < 1 || absenNum > 50) {
      _showNotification('Nomor absen harus di antara 1 sampai 50!', isError: true);
      return;
    }
    if (_selectedKelas == null) {
      _showNotification('Pilih kelas terlebih dahulu!', isError: true);
      return;
    }
    if (_selectedJurusan == null) {
      _showNotification('Pilih jurusan terlebih dahulu!', isError: true);
      return;
    }
    if (_selectedNoKelas == null) {
      _showNotification('Pilih nomor kelas terlebih dahulu!', isError: true);
      return;
    }
    if (sandi.length < 6) {
      _showNotification('Kata sandi minimal 6 karakter!', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await ApiService.registerSiswa(
      nama: nama,
      email: email,
      nisn: nisn,
      kelas: _selectedKelas!,
      jurusan: _selectedJurusan!,
      noKelas: _selectedNoKelas!,
      noAbsen: noAbsen,
      sandi: sandi,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (result['success'] == true) {
      _showNotification('Registrasi berhasil! Silakan masuk dengan akun kamu.');

      // Alihkan ke form login dan bawa email serta nisn agar otomatis terisi
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              LoginSiswaPage(
                initialEmail: email,
                initialNisn: nisn,
              ),
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
      _showNotification(result['message'] ?? 'Registrasi gagal!', isError: true);
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

                  // Stack untuk Rakun & Kartu Form (Dioptimasi dengan RepaintBoundary)
                  RepaintBoundary(
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.topCenter,
                      children: [
                        // Kartu Putih Form Registrasi
                        Container(
                          margin: const EdgeInsets.only(top: 96),
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
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
                              // Badge Header "Silahkan Registrasi Akun"
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
                                        Icons.badge_outlined,
                                        color: Color(0xFF2563EB),
                                        size: 16,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Silahkan Registrasi Akun',
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

                              // 1. Komponen Input: Nama
                              CustomTextField(
                                label: 'Nama',
                                controller: _namaController,
                                hintText: 'Budi Pratama',
                                prefixIcon: Icons.perm_identity_rounded,
                              ),

                              const SizedBox(height: 6),

                              // 2. Komponen Input: Email
                              CustomTextField(
                                label: 'Email',
                                controller: _emailController,
                                hintText: 'admin@gmail.com',
                                prefixIcon: Icons.mail_outline_rounded,
                                keyboardType: TextInputType.emailAddress,
                              ),

                              const SizedBox(height: 6),

                              // 3. Komponen Baris Input: Nisn & No. Absen
                              Row(
                                children: [
                                  // NISN (Lebar lebih besar)
                                  Expanded(
                                    flex: 7,
                                    child: CustomTextField(
                                      label: 'Nisn',
                                      controller: _nisnController,
                                      hintText: '0087654321',
                                      prefixIcon: Icons.school_outlined,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  // No. Absen (Maksimal 50, hanya angka 2 digit)
                                  Expanded(
                                    flex: 4,
                                    child: CustomTextField(
                                      label: 'No. Absen',
                                      controller: _noAbsenController,
                                      hintText: '14',
                                      prefixIcon: Icons.format_list_numbered_rounded,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(2),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 6),

                              // Baris Dropdown: Kelas (3 item), Jurusan, & No. Kelas
                              Row(
                                children: [
                                  // 1. Dropdown Kelas (10, 11, 12)
                                  Expanded(
                                    flex: 4,
                                    child: CustomDropdownField(
                                      label: 'Kelas',
                                      value: _selectedKelas,
                                      hintText: '10',
                                      prefixIcon: Icons.door_front_door_outlined,
                                      items: _listKelas,
                                      onChanged: (String? val) {
                                        setState(() {
                                          _selectedKelas = val;
                                          _kelasController.text = val ?? '';
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 6),

                                  // 2. Dropdown Jurusan (RPL, TSM, DKV, ...)
                                  Expanded(
                                    flex: 5,
                                    child: CustomDropdownField(
                                      label: 'Jurusan',
                                      value: _selectedJurusan,
                                      hintText: 'TSM',
                                      prefixIcon: Icons.workspace_premium_outlined,
                                      items: _listJurusan,
                                      onChanged: (String? val) {
                                        setState(() {
                                          _selectedJurusan = val;
                                          _jurusanController.text = val ?? '';
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 6),

                                  // 3. Dropdown No. Kelas (1, 2, 3)
                                  Expanded(
                                    flex: 4,
                                    child: CustomDropdownField(
                                      label: 'No. Kelas',
                                      value: _selectedNoKelas,
                                      hintText: '1',
                                      prefixIcon: Icons.format_list_numbered_rounded,
                                      items: _listNoKelas,
                                      onChanged: (String? val) {
                                        setState(() {
                                          _selectedNoKelas = val;
                                          _noKelasController.text = val ?? '';
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 6),

                              // Komponen Input: Sandi
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

                              const SizedBox(height: 12),

                              // Komponen Tombol: Daftar
                              CustomButton(
                                text: 'Daftar',
                                height: 42,
                                isLoading: _isLoading,
                                onTap: _handleDaftar,
                              ),

                              const SizedBox(height: 16),

                              // Link ke Halaman Login
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Sudah punya akun? ',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: const Color(0xFF6B7280),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation, secondaryAnimation) =>
                                              const LoginSiswaPage(),
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

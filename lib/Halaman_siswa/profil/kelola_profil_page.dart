import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/siswa_model.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/student_background.dart';

/// Halaman Kelola Profil Siswa: Memungkinkan siswa mengedit
/// Nama Lengkap, Kelas, Foto Profil (kamera / galeri), serta Kata Sandi akun.
class KelolaProfilPage extends StatefulWidget {
  final SiswaModel? siswa;

  const KelolaProfilPage({super.key, this.siswa});

  @override
  State<KelolaProfilPage> createState() => _KelolaProfilPageState();
}

class _KelolaProfilPageState extends State<KelolaProfilPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _sandiLamaController = TextEditingController();
  final TextEditingController _sandiBaruController = TextEditingController();
  final TextEditingController _konfirmasiSandiController = TextEditingController();

  String _selectedKelas = 'XII RPL 1';
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  final List<String> _daftarKelas = const [
    'X RPL 1',
    'X RPL 2',
    'X TSM 1',
    'X TSM 2',
    'XI RPL 1',
    'XI RPL 2',
    'XI TSM 1',
    'XI TSM 2',
    'XII RPL 1',
    'XII RPL 2',
    'XII TSM 1',
    'XII TSM 2',
  ];

  @override
  void initState() {
    super.initState();
    // Isi data awal dari akun siswa yang sedang login
    _namaController.text = widget.siswa?.namaLengkap ?? 'Budi Pratama';

    final kelasAwal = widget.siswa?.kelasLengkap ?? widget.siswa?.kelas ?? 'XII RPL 1';
    if (_daftarKelas.contains(kelasAwal)) {
      _selectedKelas = kelasAwal;
    } else {
      _selectedKelas = _daftarKelas.first;
    }

    if (widget.siswa?.foto != null && widget.siswa!.foto!.isNotEmpty) {
      final file = File(widget.siswa!.foto!);
      if (file.existsSync()) {
        _imageFile = file;
      }
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _sandiLamaController.dispose();
    _sandiBaruController.dispose();
    _konfirmasiSandiController.dispose();
    super.dispose();
  }

  // Fungsi Memilih Foto Profil dari Galeri atau Kamera
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (picked != null) {
        setState(() {
          _imageFile = File(picked.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengambil gambar: $e'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    }
  }

  // Modal Bottom Sheet Pilihan Sumber Foto
  void _showImagePickerModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(22),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(26),
            topRight: Radius.circular(26),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Ganti Foto Profil',
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Pilih foto dari galeri HP kamu atau ambil langsung dengan kamera.',
              style: GoogleFonts.poppins(
                fontSize: 11.5,
                color: const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 18),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F1FB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.photo_library_outlined, color: Color(0xFF0066D6), size: 22),
              ),
              title: Text(
                'Pilih dari Galeri',
                style: GoogleFonts.poppins(fontSize: 13.5, fontWeight: FontWeight.w700, color: const Color(0xFF1E293B)),
              ),
              subtitle: Text(
                'Pilih foto yang tersimpan di perangkat',
                style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF64748B)),
              ),
              onTap: () {
                Navigator.of(ctx).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 6),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F1FB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.camera_alt_outlined, color: Color(0xFF0066D6), size: 22),
              ),
              title: Text(
                'Ambil dengan Kamera',
                style: GoogleFonts.poppins(fontSize: 13.5, fontWeight: FontWeight.w700, color: const Color(0xFF1E293B)),
              ),
              subtitle: Text(
                'Gunakan kamera untuk mengambil foto baru',
                style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF64748B)),
              ),
              onTap: () {
                Navigator.of(ctx).pop();
                _pickImage(ImageSource.camera);
              },
            ),
            if (_imageFile != null) ...[
              const SizedBox(height: 6),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444), size: 22),
                ),
                title: Text(
                  'Hapus Foto Profil',
                  style: GoogleFonts.poppins(fontSize: 13.5, fontWeight: FontWeight.w700, color: const Color(0xFFEF4444)),
                ),
                onTap: () {
                  Navigator.of(ctx).pop();
                  setState(() {
                    _imageFile = null;
                  });
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Fungsi Validasi & Simpan Perubahan Profil
  void _handleSimpan() {
    final nama = _namaController.text.trim();
    if (nama.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama lengkap tidak boleh kosong!'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    final sandiLama = _sandiLamaController.text.trim();
    final sandiBaru = _sandiBaruController.text.trim();
    final konfirmasi = _konfirmasiSandiController.text.trim();

    if (sandiBaru.isNotEmpty || sandiLama.isNotEmpty || konfirmasi.isNotEmpty) {
      if (sandiLama.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Silakan masukkan kata sandi lama untuk verifikasi!'),
            backgroundColor: Color(0xFFEF4444),
          ),
        );
        return;
      }
      if (sandiBaru.length < 6) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kata sandi baru minimal 6 karakter!'),
            backgroundColor: Color(0xFFEF4444),
          ),
        );
        return;
      }
      if (sandiBaru != konfirmasi) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Konfirmasi kata sandi baru tidak cocok!'),
            backgroundColor: Color(0xFFEF4444),
          ),
        );
        return;
      }
    }

    setState(() => _isLoading = true);

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() => _isLoading = false);

      // Buat objek SiswaModel yang terupdate dengan data baru
      final updatedSiswa = (widget.siswa ?? SiswaModel(namaLengkap: nama, email: '')).copyWith(
        namaLengkap: nama,
        kelasLengkap: _selectedKelas,
        kelas: _selectedKelas,
        foto: _imageFile?.path,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil berhasil diperbarui!'),
          backgroundColor: Color(0xFF059669),
          duration: Duration(seconds: 2),
        ),
      );

      // Kembalikan objek yang terupdate ke halaman sebelumnya
      Navigator.pop(context, updatedSiswa);
    });
  }

  @override
  Widget build(BuildContext context) {
    final namaAwal = _namaController.text.isNotEmpty ? _namaController.text : 'Budi';

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFE),
      body: StudentBackground(
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                // 1. Header Bar: Tombol Kembali + Judul "Kelola Profil"
                Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          color: Color(0xFF0F172A),
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kelola Profil',
                          style: GoogleFonts.poppins(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.3,
                          ),
                        ),
                        Text(
                          'Perbarui foto, data diri, dan keamanan akun',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withValues(alpha: 0.88),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // 2. Card Foto Profil (Avatar Besar + Tombol Kamera)
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      // Avatar Lingkaran
                      GestureDetector(
                        onTap: _showImagePickerModal,
                        child: Container(
                          width: 104,
                          height: 104,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF6565), Color(0xFFFF416C)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(color: Colors.white, width: 3.5),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF416C).withValues(alpha: 0.35),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: _imageFile != null
                                ? Image.file(
                                    _imageFile!,
                                    fit: BoxFit.cover,
                                    width: 104,
                                    height: 104,
                                  )
                                : Center(
                                    child: Text(
                                      namaAwal.trim().isNotEmpty ? namaAwal.trim()[0].toUpperCase() : 'B',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 42,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),

                      // Tombol Kamera Kecil di Sudut
                      GestureDetector(
                        onTap: _showImagePickerModal,
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0066D6),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2.5),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF0066D6).withValues(alpha: 0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),
                Center(
                  child: TextButton.icon(
                    onPressed: _showImagePickerModal,
                    icon: const Icon(Icons.edit_rounded, size: 14, color: Color(0xFF0066D6)),
                    label: Text(
                      'Ubah Foto Profil',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0066D6),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // 3. Card Data Diri Siswa (Nama & Kelas)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F172A).withValues(alpha: 0.05),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.person_outline_rounded, color: Color(0xFF0066D6), size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Informasi Siswa',
                            style: GoogleFonts.poppins(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Input Nama Lengkap
                      CustomTextField(
                        label: 'Nama Lengkap',
                        controller: _namaController,
                        hintText: 'Masukkan nama lengkap',
                        prefixIcon: Icons.badge_outlined,
                      ),

                      const SizedBox(height: 14),

                      // Pilihan Dropdown Kelas
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3, left: 2),
                            child: Text(
                              'Kelas Siswa',
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
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedKelas,
                                isExpanded: true,
                                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF8193AA)),
                                style: GoogleFonts.poppins(
                                  fontSize: 13.5,
                                  color: const Color(0xFF1E293B),
                                  fontWeight: FontWeight.w600,
                                ),
                                items: _daftarKelas.map((String k) {
                                  return DropdownMenuItem<String>(
                                    value: k,
                                    child: Row(
                                      children: [
                                        const Icon(Icons.school_rounded, size: 16, color: Color(0xFF0066D6)),
                                        const SizedBox(width: 8),
                                        Text(k),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() => _selectedKelas = val);
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // 4. Card Keamanan Akun (Ubah Sandi Opsional)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F172A).withValues(alpha: 0.05),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.lock_outline_rounded, color: Color(0xFF0066D6), size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Keamanan (Ubah Kata Sandi)',
                            style: GoogleFonts.poppins(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Kosongkan kolom di bawah jika tidak ingin mengganti kata sandi.',
                        style: GoogleFonts.poppins(
                          fontSize: 10.5,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Sandi Lama
                      CustomTextField(
                        label: 'Kata Sandi Lama',
                        controller: _sandiLamaController,
                        hintText: 'Masukkan kata sandi lama kamu',
                        prefixIcon: Icons.lock_clock_outlined,
                        obscureText: _obscureOldPassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureOldPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            size: 18,
                            color: const Color(0xFF8193AA),
                          ),
                          onPressed: () => setState(() => _obscureOldPassword = !_obscureOldPassword),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Sandi Baru
                      CustomTextField(
                        label: 'Kata Sandi Baru',
                        controller: _sandiBaruController,
                        hintText: 'Minimal 6 karakter',
                        prefixIcon: Icons.lock_reset_rounded,
                        obscureText: _obscureNewPassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureNewPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            size: 18,
                            color: const Color(0xFF8193AA),
                          ),
                          onPressed: () => setState(() => _obscureNewPassword = !_obscureNewPassword),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Konfirmasi Sandi Baru
                      CustomTextField(
                        label: 'Konfirmasi Kata Sandi Baru',
                        controller: _konfirmasiSandiController,
                        hintText: 'Ulangi kata sandi baru',
                        prefixIcon: Icons.check_circle_outline_rounded,
                        obscureText: _obscureConfirmPassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            size: 18,
                            color: const Color(0xFF8193AA),
                          ),
                          onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 5. Tombol Simpan Perubahan
                CustomButton(
                  text: 'Simpan Perubahan',
                  icon: Icons.check_rounded,
                  iconSize: 18,
                  height: 46,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                  borderRadius: BorderRadius.circular(14),
                  isLoading: _isLoading,
                  onTap: _handleSimpan,
                ),

                const SizedBox(height: 36),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

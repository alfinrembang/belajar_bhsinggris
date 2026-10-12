import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/siswa_model.dart';
import '../../../services/api_service.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/student_background.dart';

/// Halaman Kelola Profil Siswa: Memungkinkan siswa mengedit
/// Nama Lengkap, Kelas & Rombel (saat periode dibuka guru), No Absen,
/// Foto Profil (kamera / galeri), serta Kata Sandi akun.
class KelolaProfilPage extends StatefulWidget {
  final SiswaModel? siswa;

  const KelolaProfilPage({super.key, this.siswa});

  @override
  State<KelolaProfilPage> createState() => _KelolaProfilPageState();
}

class _KelolaProfilPageState extends State<KelolaProfilPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _noAbsenController = TextEditingController();
  final TextEditingController _sandiLamaController = TextEditingController();
  final TextEditingController _sandiBaruController = TextEditingController();
  final TextEditingController _konfirmasiSandiController = TextEditingController();

  String _selectedKelas = '10 TSM 1';
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  // Status Akademik & Kenaikan Kelas dari Backend
  bool _isKenaikanAktif = false;
  String _tahunAjaran = '2026/2027';
  bool _perluKenaikanKelas = false;
  bool _isLoadingAkademik = true;

  List<String> _daftarKelas = [];

  @override
  void initState() {
    super.initState();
    // 1. Data Personal Awal
    _namaController.text = widget.siswa?.namaLengkap ?? 'Siswa';
    _noAbsenController.text = widget.siswa?.noAbsen ?? '';

    // 2. Tentukan Jurusan Siswa (Jurusan tetap sama saat naik kelas)
    String jurusan = widget.siswa?.jurusan ?? '';
    if (jurusan.isEmpty && widget.siswa?.kelasLengkap != null) {
      final parts = widget.siswa!.kelasLengkap!.trim().split(' ');
      if (parts.length >= 2) {
        jurusan = parts[1];
      }
    }
    if (jurusan.isEmpty) {
      jurusan = 'TSM';
    }

    // 3. Bangun Opsi Rombel untuk Jurusan Siswa (Tingkat 10, 11, 12 x Rombel 1, 2, 3)
    final rombelList = <String>[];
    for (final tingkat in ['10', '11', '12']) {
      for (final no in ['1', '2', '3']) {
        rombelList.add('$tingkat $jurusan $no');
      }
    }
    // Tambahkan juga varian Romawi untuk kompatibilitas
    for (final tingkat in ['X', 'XI', 'XII']) {
      for (final no in ['1', '2', '3']) {
        rombelList.add('$tingkat $jurusan $no');
      }
    }

    _daftarKelas = rombelList;

    final kelasAwal = widget.siswa?.kelasLengkap ?? widget.siswa?.kelas ?? '10 $jurusan 1';
    if (_daftarKelas.contains(kelasAwal)) {
      _selectedKelas = kelasAwal;
    } else {
      _daftarKelas.insert(0, kelasAwal);
      _selectedKelas = kelasAwal;
    }

    if (widget.siswa?.foto != null && widget.siswa!.foto!.isNotEmpty) {
      final file = File(widget.siswa!.foto!);
      if (file.existsSync()) {
        _imageFile = file;
      }
    }

    // 4. Periksa Status Periode Kenaikan Kelas dari Server
    _fetchStatusAkademik();
  }

  @override
  void dispose() {
    _namaController.dispose();
    _noAbsenController.dispose();
    _sandiLamaController.dispose();
    _sandiBaruController.dispose();
    _konfirmasiSandiController.dispose();
    super.dispose();
  }

  // Mengambil Status Periode Kenaikan Kelas dari Backend
  Future<void> _fetchStatusAkademik() async {
    setState(() => _isLoadingAkademik = true);
    try {
      final res = await ApiService.getStatusAkademik(siswaId: widget.siswa?.id);
      if (res['success'] == true && res['data'] != null) {
        final data = res['data'];
        if (mounted) {
          setState(() {
            _isKenaikanAktif = data['is_periode_kenaikan_aktif'] == true;
            _tahunAjaran = data['tahun_ajaran']?.toString() ?? '2026/2027';
            _perluKenaikanKelas = data['perlu_kenaikan_kelas'] == true;
            _isLoadingAkademik = false;
          });
        }
      } else {
        if (mounted) {
          setState(() => _isLoadingAkademik = false);
        }
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoadingAkademik = false);
      }
    }
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

  // Fungsi Validasi & Simpan Perubahan Profil ke Server Laravel
  Future<void> _handleSimpan() async {
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

    final siswaId = widget.siswa?.id ?? 0;
    final res = await ApiService.updateProfilSiswa(
      siswaId: siswaId,
      namaLengkap: nama,
      kelasLengkap: _selectedKelas,
      noAbsen: _noAbsenController.text.trim(),
      sandiLama: sandiLama.isNotEmpty ? sandiLama : null,
      sandiBaru: sandiBaru.isNotEmpty ? sandiBaru : null,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (res['success'] == true) {
      SiswaModel updatedSiswa = (res['siswa'] as SiswaModel?) ??
          (widget.siswa ?? SiswaModel(namaLengkap: nama, email: '')).copyWith(
            namaLengkap: nama,
            kelasLengkap: _selectedKelas,
            noAbsen: _noAbsenController.text.trim(),
          );

      if (_imageFile != null) {
        updatedSiswa = updatedSiswa.copyWith(foto: _imageFile!.path);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res['message'] ?? 'Profil berhasil diperbarui!'),
          backgroundColor: const Color(0xFF059669),
          duration: const Duration(seconds: 2),
        ),
      );

      // Kembalikan objek yang terupdate ke halaman profil
      Navigator.pop(context, updatedSiswa);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res['message'] ?? 'Gagal memperbarui profil.'),
          backgroundColor: const Color(0xFFEF4444),
          duration: const Duration(seconds: 3),
        ),
      );
    }
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

                const SizedBox(height: 24),

                // 2. Banner Informasi Periode Kenaikan Kelas (Dinamis dari Guru)
                if (!_isLoadingAkademik) ...[
                  if (_isKenaikanAktif)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFECFDF5), Color(0xFFD1FAE5)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.4), width: 1.2),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF10B981).withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.celebration_rounded, color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Periode Kenaikan Kelas Dibuka!',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFF065F46),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF059669),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        _tahunAjaran,
                                        style: GoogleFonts.poppins(
                                          fontSize: 9.5,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'Silakan sesuaikan tingkat kelas, nomor rombel, dan no. absen barumu sesuai pembagian wali kelas.',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF047857),
                                    height: 1.35,
                                  ),
                                ),
                                if (_perluKenaikanKelas) ...[
                                  const SizedBox(height: 5),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF047857).withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      '📌 Rombel Anda belum terdaftar di tahun ajaran $_tahunAjaran.',
                                      style: GoogleFonts.poppins(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF065F46),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.lock_outline_rounded, size: 18, color: Color(0xFF64748B)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Rombel Kelas & No Absen Terkunci',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF334155),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Periode kenaikan kelas sedang ditutup oleh guru. Jika rombel tidak sesuai, silakan lapor ke bapak/ibu guru.',
                                  style: GoogleFonts.poppins(
                                    fontSize: 10.5,
                                    color: const Color(0xFF64748B),
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],

                // 3. Card Foto Profil (Avatar Besar + Tombol Kamera)
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

                // 4. Card Data Diri Siswa (Nama, Rombel Kelas, No Absen)
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

                      // Pilihan Dropdown Kelas / Rombel (Terkunci jika sakelar guru OFF)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3, left: 2),
                            child: Row(
                              children: [
                                Text(
                                  'Rombel Kelas',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF334155),
                                  ),
                                ),
                                if (!_isKenaikanAktif) ...[
                                  const SizedBox(width: 6),
                                  const Icon(Icons.lock_rounded, size: 12, color: Color(0xFF94A3B8)),
                                  const SizedBox(width: 2),
                                  Text(
                                    '(Terkunci)',
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF94A3B8),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),

                          if (_isKenaikanAktif)
                            Container(
                              height: 44,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEDF2F7),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: const Color(0xFF10B981).withValues(alpha: 0.5),
                                  width: 1.2,
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedKelas,
                                  isExpanded: true,
                                  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF059669)),
                                  style: GoogleFonts.poppins(
                                    fontSize: 13.5,
                                    color: const Color(0xFF1E293B),
                                    fontWeight: FontWeight.w700,
                                  ),
                                  items: _daftarKelas.map((String k) {
                                    return DropdownMenuItem<String>(
                                      value: k,
                                      child: Row(
                                        children: [
                                          const Icon(Icons.school_rounded, size: 16, color: Color(0xFF059669)),
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
                            )
                          else
                            Container(
                              height: 44,
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.school_rounded, size: 16, color: Color(0xFF64748B)),
                                      const SizedBox(width: 8),
                                      Text(
                                        _selectedKelas,
                                        style: GoogleFonts.poppins(
                                          fontSize: 13.5,
                                          color: const Color(0xFF475569),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Icon(Icons.lock_rounded, size: 16, color: Color(0xFF94A3B8)),
                                ],
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // Input Nomor Absen Siswa (Terkunci jika sakelar guru OFF)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3, left: 2),
                            child: Row(
                              children: [
                                Text(
                                  'Nomor Absen Presensi',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF334155),
                                  ),
                                ),
                                if (!_isKenaikanAktif) ...[
                                  const SizedBox(width: 6),
                                  const Icon(Icons.lock_rounded, size: 12, color: Color(0xFF94A3B8)),
                                  const SizedBox(width: 2),
                                  Text(
                                    '(Terkunci)',
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF94A3B8),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),

                          if (_isKenaikanAktif)
                            CustomTextField(
                              label: '',
                              controller: _noAbsenController,
                              hintText: 'Contoh: 15',
                              prefixIcon: Icons.format_list_numbered_rounded,
                              keyboardType: TextInputType.number,
                            )
                          else
                            Container(
                              height: 44,
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.format_list_numbered_rounded, size: 16, color: Color(0xFF64748B)),
                                      const SizedBox(width: 8),
                                      Text(
                                        _noAbsenController.text.isNotEmpty
                                            ? _noAbsenController.text
                                            : 'Belum diatur',
                                        style: GoogleFonts.poppins(
                                          fontSize: 13.5,
                                          color: const Color(0xFF475569),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Icon(Icons.lock_rounded, size: 16, color: Color(0xFF94A3B8)),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // 5. Card Keamanan Akun (Ubah Sandi Opsional)
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

                // 6. Tombol Simpan Perubahan
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

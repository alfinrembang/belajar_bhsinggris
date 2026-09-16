class SiswaModel {
  final int? id;
  final String namaLengkap;
  final String email;
  final String? nisn;
  final String? nis;
  final String? kelas;
  final String? jurusan;
  final String? noKelas;
  final String? noAbsen;
  final String? kelasLengkap;
  final String? token;

  SiswaModel({
    this.id,
    required this.namaLengkap,
    required this.email,
    this.nisn,
    this.nis,
    this.kelas,
    this.jurusan,
    this.noKelas,
    this.noAbsen,
    this.kelasLengkap,
    this.token,
  });

  factory SiswaModel.fromJson(Map<String, dynamic> json, {String? token}) {
    final rawKelas = json['kelas']?.toString();
    final rawJurusan = json['jurusan']?.toString();
    final rawNoKelas = json['no_kelas']?.toString();

    String? generatedKelasLengkap;
    if (json['kelas_lengkap'] != null && json['kelas_lengkap'].toString().isNotEmpty) {
      generatedKelasLengkap = json['kelas_lengkap'].toString();
    } else {
      final parts = [rawKelas, rawJurusan, rawNoKelas]
          .where((e) => e != null && e.toString().trim().isNotEmpty)
          .join(' ');
      generatedKelasLengkap = parts.isNotEmpty ? parts : rawKelas;
    }

    return SiswaModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      namaLengkap: json['nama_lengkap']?.toString() ?? json['nama']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      nisn: json['nisn']?.toString(),
      nis: json['nis']?.toString(),
      kelas: rawKelas,
      jurusan: rawJurusan,
      noKelas: rawNoKelas,
      noAbsen: json['no_absen']?.toString(),
      kelasLengkap: generatedKelasLengkap,
      token: token ?? json['api_token']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_lengkap': namaLengkap,
      'email': email,
      'nisn': nisn,
      'nis': nis,
      'kelas': kelas,
      'jurusan': jurusan,
      'no_kelas': noKelas,
      'no_absen': noAbsen,
      'kelas_lengkap': kelasLengkap,
      'api_token': token,
    };
  }
}

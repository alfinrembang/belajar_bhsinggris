import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/siswa_model.dart';
import 'api_client.dart';

/// Service untuk menangani profil siswa, status akademik, dan kenaikan kelas
class SiswaService {
  /// 17. Ambil Status Akademik & Periode Kenaikan Kelas (GET /api/siswa/status-akademik)
  static Future<Map<String, dynamic>> getStatusAkademik({int? siswaId}) async {
    try {
      final response = await ApiClient.sendRequest((baseUrl) {
        final queryParams = <String, String>{};
        if (siswaId != null) queryParams['siswa_id'] = siswaId.toString();
        final uri = Uri.parse('$baseUrl/siswa/status-akademik').replace(
          queryParameters: queryParams.isNotEmpty ? queryParams : null,
        );
        return http.get(uri, headers: {'Accept': 'application/json'});
      });

      final Map<String, dynamic> body = jsonDecode(response.body);
      if (response.statusCode == 200 && body['status'] == 'success') {
        return {
          'success': true,
          'data': body['data'],
        };
      }

      return {
        'success': false,
        'message': body['message'] ?? 'Gagal mengambil status akademik.',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Gagal memeriksa status akademik: $e',
      };
    }
  }

  /// 18. Perbarui Profil Siswa & Kenaikan Kelas (POST /api/siswa/update-profil)
  static Future<Map<String, dynamic>> updateProfilSiswa({
    required int siswaId,
    String? namaLengkap,
    String? kelasLengkap,
    String? kelas,
    String? noKelas,
    String? noAbsen,
    String? sandiLama,
    String? sandiBaru,
  }) async {
    try {
      final payload = <String, dynamic>{
        'siswa_id': siswaId,
      };
      if (namaLengkap != null && namaLengkap.isNotEmpty) {
        payload['nama_lengkap'] = namaLengkap;
      }
      if (kelasLengkap != null && kelasLengkap.isNotEmpty) {
        payload['kelas_lengkap'] = kelasLengkap;
      }
      if (kelas != null && kelas.isNotEmpty) {
        payload['kelas'] = kelas;
      }
      if (noKelas != null && noKelas.isNotEmpty) {
        payload['no_kelas'] = noKelas;
      }
      if (noAbsen != null && noAbsen.isNotEmpty) {
        payload['no_absen'] = noAbsen;
      }
      if (sandiLama != null && sandiLama.isNotEmpty) {
        payload['sandi_lama'] = sandiLama;
      }
      if (sandiBaru != null && sandiBaru.isNotEmpty) {
        payload['sandi_baru'] = sandiBaru;
      }

      final response = await ApiClient.sendRequest((baseUrl) {
        return http.post(
          Uri.parse('$baseUrl/siswa/update-profil'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode(payload),
        );
      });

      final Map<String, dynamic> body = jsonDecode(response.body);
      if (response.statusCode == 200 && body['status'] == 'success') {
        final updatedSiswa = SiswaModel.fromJson(body['data']);
        return {
          'success': true,
          'message': body['message'] ?? 'Profil berhasil diperbarui!',
          'siswa': updatedSiswa,
        };
      }

      return {
        'success': false,
        'message': body['message'] ?? 'Gagal memperbarui profil (${response.statusCode})',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Gagal memperbarui profil: $e',
      };
    }
  }
}

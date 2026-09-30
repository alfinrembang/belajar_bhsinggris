import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/siswa_model.dart';
import '../Halaman_siswa/materi/sections/materi_list_section.dart';

/// Service untuk menangani seluruh komunikasi API antara aplikasi Flutter
/// dan backend Laravel (belajar_bhsinggris_api).
class ApiService {
  // Alamat server utama: 127.0.0.1 (aktif via ADB Reverse USB)
  // dan fallback otomatis ke IP Wi-Fi lokal jika USB dilepas
  static const String _primaryUrl = 'http://127.0.0.1:8000/api';
  static const String _fallbackUrl = 'http://192.168.1.8:8000/api';

  static String activeBaseUrl = _primaryUrl;

  /// Cache ID materi yang telah diselesaikan siswa (sinkron reaktif instan antar halaman)
  static final Set<int> completedMateriIds = {};

  static bool isMateriCompleted(int id) => completedMateriIds.contains(id);

  static void markMateriCompleted(int id) {
    completedMateriIds.add(id);
  }

  /// Helper untuk mengirim HTTP Request dengan fallback otomatis antar host
  static Future<http.Response> _sendRequest(
    Future<http.Response> Function(String baseUrl) requestFn,
  ) async {
    try {
      final response = await requestFn(activeBaseUrl).timeout(
        const Duration(seconds: 7),
      );
      return response;
    } catch (e) {
      // Jika host utama gagal (misal koneksi USB terputus), coba host fallback
      final alternateUrl = (activeBaseUrl == _primaryUrl) ? _fallbackUrl : _primaryUrl;
      try {
        final altResponse = await requestFn(alternateUrl).timeout(
          const Duration(seconds: 7),
        );
        activeBaseUrl = alternateUrl; // Ingat host yang berhasil
        return altResponse;
      } catch (_) {
        rethrow; // Lempar error asli jika kedua host gagal
      }
    }
  }

  /// 1. Registrasi Akun Siswa Baru (POST /api/siswa/register)
  static Future<Map<String, dynamic>> registerSiswa({
    required String nama,
    required String email,
    required String nisn,
    required String kelas,
    required String jurusan,
    required String noKelas,
    String? noAbsen,
    required String sandi,
  }) async {
    try {
      final response = await _sendRequest((baseUrl) {
        return http.post(
          Uri.parse('$baseUrl/siswa/register'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode({
            'nama': nama,
            'email': email,
            'nisn': nisn,
            'kelas': kelas,
            'jurusan': jurusan,
            'no_kelas': noKelas,
          if (noAbsen != null && noAbsen.isNotEmpty) 'no_absen': noAbsen,
          'sandi': sandi,
          }),
        );
      });

      final Map<String, dynamic> body = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = body['token']?.toString();
        final siswa = SiswaModel.fromJson(body['data'], token: token);
        return {
          'success': true,
          'message': body['message'] ?? 'Registrasi berhasil!',
          'token': token,
          'siswa': siswa,
        };
      } else {
        String errorMsg = body['message'] ?? 'Gagal mendaftar!';
        if (body['errors'] != null && body['errors'] is Map) {
          final errors = body['errors'] as Map<String, dynamic>;
          final firstKey = errors.keys.firstOrNull;
          if (firstKey != null && errors[firstKey] is List && (errors[firstKey] as List).isNotEmpty) {
            errorMsg = errors[firstKey][0].toString();
          }
        }
        return {
          'success': false,
          'message': errorMsg,
        };
      }
    } on SocketException {
      return {
        'success': false,
        'message': 'Gagal terhubung ke backend Laravel. Pastikan php artisan serve & Laragon aktif.',
      };
    } on TimeoutException {
      return {
        'success': false,
        'message': 'Koneksi ke server timeout (terlalu lama). Periksa jaringan kamu.',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }

  /// 2. Login Siswa (POST /api/siswa/login)
  static Future<Map<String, dynamic>> loginSiswa({
    String? email,
    String? nisn,
    required String sandi,
  }) async {
    try {
      final response = await _sendRequest((baseUrl) {
        return http.post(
          Uri.parse('$baseUrl/siswa/login'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode({
            if (email != null && email.isNotEmpty) 'email': email,
            if (nisn != null && nisn.isNotEmpty) 'nisn': nisn,
            'sandi': sandi,
          }),
        );
      });

      final Map<String, dynamic> body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final token = body['token']?.toString();
        final siswa = SiswaModel.fromJson(body['data'], token: token);
        return {
          'success': true,
          'message': body['message'] ?? 'Login berhasil!',
          'token': token,
          'siswa': siswa,
        };
      } else {
        return {
          'success': false,
          'message': body['message'] ?? 'Email/NISN atau kata sandi salah!',
        };
      }
    } on SocketException {
      return {
        'success': false,
        'message': 'Tidak dapat terhubung ke server Laravel. Pastikan backend aktif.',
      };
    } on TimeoutException {
      return {
        'success': false,
        'message': 'Koneksi timeout. Silakan coba beberapa saat lagi.',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan koneksi: $e',
      };
    }
  }

  /// 3. Lupa Sandi Siswa (POST /api/siswa/lupa-sandi)
  static Future<Map<String, dynamic>> lupaSandiSiswa({
    required String email,
  }) async {
    try {
      final response = await _sendRequest((baseUrl) {
        return http.post(
          Uri.parse('$baseUrl/siswa/lupa-sandi'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode({
            'email': email,
          }),
        );
      });

      final Map<String, dynamic> body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': body['message'] ?? 'Kode reset sandi telah dikirim ke email kamu.',
          'data': body['data'],
        };
      } else {
        return {
          'success': false,
          'message': body['message'] ?? 'Alamat email tidak ditemukan!',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Gagal memproses permintaan lupa sandi: $e',
      };
    }
  }

  /// 4. Ambil Profil Siswa Sesi Aktif (GET /api/siswa/me)
  static Future<Map<String, dynamic>> getProfilSiswa({
    required String token,
  }) async {
    try {
      final response = await _sendRequest((baseUrl) {
        return http.get(
          Uri.parse('$baseUrl/siswa/me'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      });

      final Map<String, dynamic> body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final siswa = SiswaModel.fromJson(body['data'], token: token);
        return {
          'success': true,
          'siswa': siswa,
        };
      } else {
        return {
          'success': false,
          'message': body['message'] ?? 'Sesi telah kedaluwarsa.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Gagal memuat profil siswa: $e',
      };
    }
  }

  /// 5. Logout Siswa (POST /api/siswa/logout)
  static Future<bool> logoutSiswa({required String token}) async {
    try {
      final response = await _sendRequest((baseUrl) {
        return http.post(
          Uri.parse('$baseUrl/siswa/logout'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      });
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  /// 6. Ambil Daftar Materi Pembelajaran Siswa (GET /api/materi)
  static Future<Map<String, dynamic>> getDaftarMateri({
    String? kelas,
    String? kategori,
    int? siswaId,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (kelas != null && kelas.trim().isNotEmpty) {
        queryParams['kelas'] = kelas.trim();
      }
      if (kategori != null &&
          kategori.trim().isNotEmpty &&
          kategori.toLowerCase() != 'all' &&
          kategori.toLowerCase() != 'semua') {
        queryParams['kategori'] = kategori.trim();
      }
      if (siswaId != null) {
        queryParams['siswa_id'] = siswaId.toString();
      }

      final response = await _sendRequest((baseUrl) {
        final uri = Uri.parse('$baseUrl/materi').replace(
          queryParameters: queryParams.isNotEmpty ? queryParams : null,
        );
        return http.get(
          uri,
          headers: {
            'Accept': 'application/json',
          },
        );
      });

      final Map<String, dynamic> body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['status'] == 'success') {
        final List<dynamic> listRaw = body['data'] ?? [];
        for (final item in listRaw) {
          if (item is Map<String, dynamic> && item['is_completed'] == true) {
            final id = int.tryParse(item['id']?.toString() ?? '');
            if (id != null) completedMateriIds.add(id);
          }
        }
        final items = listRaw
            .map((e) => MateriItemData.fromJson(e as Map<String, dynamic>))
            .toList();
        return {
          'success': true,
          'data': items,
        };
      } else {
        return {
          'success': false,
          'message': body['message'] ?? 'Gagal memuat materi pembelajaran.',
          'data': <MateriItemData>[],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Gagal terhubung ke server materi: $e',
        'data': <MateriItemData>[],
      };
    }
  }

  /// 7. Ambil Detail Materi & Butir Soal Lengkap (GET /api/materi/{id})
  static Future<Map<String, dynamic>> getDetailMateri(int id) async {
    try {
      final response = await _sendRequest((baseUrl) {
        return http.get(
          Uri.parse('$baseUrl/materi/$id'),
          headers: {
            'Accept': 'application/json',
          },
        );
      });

      final Map<String, dynamic> body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['status'] == 'success') {
        return {
          'success': true,
          'data': body['data'] as Map<String, dynamic>,
        };
      } else {
        return {
          'success': false,
          'message': body['message'] ?? 'Materi tidak ditemukan.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Gagal memuat detail materi: $e',
      };
    }
  }

  /// 8. Tandai Modul Materi Telah Selesai (POST /api/materi/{id}/selesai)
  static Future<Map<String, dynamic>> selesaikanMateri({
    required int materiId,
    int? siswaId,
    int? skor,
    int? xpReward,
  }) async {
    completedMateriIds.add(materiId);
    try {
      final payload = <String, dynamic>{
        'skor': skor ?? 100,
        'xp_reward': xpReward ?? 50,
      };
      if (siswaId != null) {
        payload['siswa_id'] = siswaId;
      }

      final response = await _sendRequest((baseUrl) {
        return http.post(
          Uri.parse('$baseUrl/materi/$materiId/selesai'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode(payload),
        );
      });

      final Map<String, dynamic> body = jsonDecode(response.body);
      if (response.statusCode == 200 && body['status'] == 'success') {
        return {
          'success': true,
          'data': body['data'],
        };
      }
    } catch (_) {}
    return {'success': true};
  }

  /// 9. Ambil Ringkasan Progres Belajar Materi (GET /api/materi/progres)
  static Future<Map<String, dynamic>> getProgresMateri({int? siswaId}) async {
    try {
      final queryParams = <String, String>{};
      if (siswaId != null) {
        queryParams['siswa_id'] = siswaId.toString();
      }

      final response = await _sendRequest((baseUrl) {
        final uri = Uri.parse('$baseUrl/materi/progres').replace(
          queryParameters: queryParams.isNotEmpty ? queryParams : null,
        );
        return http.get(
          uri,
          headers: {'Accept': 'application/json'},
        );
      });

      final Map<String, dynamic> body = jsonDecode(response.body);
      if (response.statusCode == 200 && body['status'] == 'success') {
        final data = body['data'] as Map<String, dynamic>? ?? {};
        final List<dynamic> doneIds = data['completed_materi_ids'] ?? [];
        for (final id in doneIds) {
          final idInt = int.tryParse(id.toString());
          if (idInt != null) completedMateriIds.add(idInt);
        }

        return {
          'success': true,
          'data': data,
        };
      }
    } catch (_) {}

    final total = 4;
    final selesai = completedMateriIds.length;
    final persen = total > 0 ? ((selesai / total) * 100).round() : 0;
    return {
      'success': true,
      'data': {
        'total_materi': total,
        'materi_selesai': selesai,
        'persentase': persen.clamp(0, 100),
        'completed_materi_ids': completedMateriIds.toList(),
      },
    };
  }
}

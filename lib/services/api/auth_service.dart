import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../models/siswa_model.dart';
import 'api_client.dart';

/// Service untuk menangani alur otentikasi siswa (Register, Login, Me, Logout)
class AuthService {
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
      final response = await ApiClient.sendRequest((baseUrl) {
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
      final response = await ApiClient.sendRequest((baseUrl) {
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
      final response = await ApiClient.sendRequest((baseUrl) {
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
      final response = await ApiClient.sendRequest((baseUrl) {
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
      final response = await ApiClient.sendRequest((baseUrl) {
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
}

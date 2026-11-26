import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/siswa_model.dart';
import 'api/auth_service.dart';

/// Layanan manajemen sesi lokal siswa (Auto-login / Persistent Auth).
/// Menyimpan data akun dan token di perangkat lokal (SharedPreferences)
/// sehingga siswa tidak perlu login ulang setiap kali membuka aplikasi.
class SessionService {
  static const String _keyToken = 'auth_siswa_token';
  static const String _keyData = 'auth_siswa_data';

  /// Menyimpan data sesi siswa ke SharedPreferences lokal.
  static Future<void> saveSession(SiswaModel siswa) async {
    final prefs = await SharedPreferences.getInstance();
    if (siswa.token != null && siswa.token!.isNotEmpty) {
      await prefs.setString(_keyToken, siswa.token!);
    }
    await prefs.setString(_keyData, jsonEncode(siswa.toJson()));
  }

  /// Membaca data siswa yang tersimpan di memori lokal perangkat.
  static Future<SiswaModel?> getSavedSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rawData = prefs.getString(_keyData);
      final token = prefs.getString(_keyToken);

      if (rawData == null || rawData.isEmpty) {
        return null;
      }

      final Map<String, dynamic> json = jsonDecode(rawData);
      return SiswaModel.fromJson(json, token: token);
    } catch (_) {
      return null;
    }
  }

  /// Mendapatkan token autentikasi siswa yang tersimpan.
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  /// Mengecek apakah ada sesi login siswa yang tersimpan.
  static Future<bool> isLoggedIn() async {
    final session = await getSavedSession();
    return session != null && session.token != null && session.token!.isNotEmpty;
  }

  /// Menghapus seluruh data sesi login dari memori lokal (saat logout).
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyData);
  }

  /// Memvalidasi sesi ke server Laravel (/api/siswa/me) dan memperbarui data lokal.
  /// Jika token masih valid, kembalikan SiswaModel terbaru.
  /// Jika token kedaluwarsa/tidak sah, bersihkan sesi dan kembalikan null.
  /// Jika offline, kembalikan sesi lokal tersimpan (offline resilience).
  static Future<SiswaModel?> validateAndRefreshSession() async {
    final saved = await getSavedSession();
    if (saved == null || saved.token == null || saved.token!.isEmpty) {
      return null;
    }

    try {
      final res = await AuthService.getProfilSiswa(token: saved.token!);
      if (res['success'] == true && res['siswa'] is SiswaModel) {
        final freshSiswa = res['siswa'] as SiswaModel;
        await saveSession(freshSiswa);
        return freshSiswa;
      } else if (res['message'] != null &&
          res['message'].toString().toLowerCase().contains('kedaluwarsa')) {
        // Token sudah tidak sah/dicabut oleh server
        await clearSession();
        return null;
      }
    } catch (_) {
      // Jaringan bermasalah/offline: tetap gunakan sesi lokal yang ada
    }

    return saved;
  }
}

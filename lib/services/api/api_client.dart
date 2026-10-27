import 'dart:async';
import 'package:http/http.dart' as http;

/// Helper Client HTTP dasar untuk menangani multi-fallback IP backend
class ApiClient {
  // Alamat server: mendukung koneksi via USB (ADB Reverse), Wi-Fi lokal, dan Emulator
  static const List<String> candidateUrls = [
    'http://127.0.0.1:8000/api',     // Localhost / USB / ADB Reverse / Web (prioritas cepat)
    'http://192.168.1.20:8000/api', // IP Wi-Fi lokal laptop saat ini
    'http://10.0.2.2:8000/api',      // Android Emulator
  ];

  static String activeBaseUrl = candidateUrls.first;

  /// Memastikan URL audio dapat diakses oleh perangkat Android (menyesuaikan host IP aktif)
  static String resolveAudioUrl(String? url) {
    if (url == null || url.trim().isEmpty) return '';
    final trimmed = url.trim();
    if (trimmed.startsWith('http://localhost:8000') || trimmed.startsWith('http://127.0.0.1:8000')) {
      final activeUri = Uri.parse(activeBaseUrl);
      final activeHostAndPort = '${activeUri.host}:${activeUri.port}';
      return trimmed
          .replaceFirst('localhost:8000', activeHostAndPort)
          .replaceFirst('127.0.0.1:8000', activeHostAndPort);
    }
    return trimmed;
  }

  /// Helper untuk mengirim HTTP Request dengan multi-fallback otomatis antar host
  static Future<http.Response> sendRequest(
    Future<http.Response> Function(String baseUrl) requestFn,
  ) async {
    // 1. Coba host aktif terlebih dahulu
    try {
      final response = await requestFn(activeBaseUrl).timeout(
        const Duration(seconds: 4),
      );
      return response;
    } catch (_) {
      // 2. Jika host aktif gagal, coba kandidat host lainnya
      for (final candidate in candidateUrls) {
        if (candidate == activeBaseUrl) continue;
        try {
          final altResponse = await requestFn(candidate).timeout(
            const Duration(seconds: 4),
          );
          activeBaseUrl = candidate; // Simpan host yang berhasil untuk request berikutnya
          return altResponse;
        } catch (_) {
          continue;
        }
      }
      rethrow;
    }
  }
}

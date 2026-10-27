import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_client.dart';

/// Service untuk menangani game edukasi memancing "Word Fishing"
/// (Soal kosakata, progres level, koleksi ikan, rating bintang, dan reward koin)
class FishingService {
  /// 1. Ambil Daftar Soal Memancing (GET /api/fishing/soal)
  static Future<Map<String, dynamic>> getFishingSoal({
    int level = 1,
    String difficulty = 'mudah',
    int limit = 5,
  }) async {
    try {
      final queryParams = <String, String>{
        'level': level.toString(),
        'difficulty': difficulty.toLowerCase(),
        'limit': limit.toString(),
      };

      final response = await ApiClient.sendRequest((baseUrl) {
        final uri = Uri.parse('$baseUrl/fishing/soal').replace(
          queryParameters: queryParams,
        );
        return http.get(
          uri,
          headers: {'Accept': 'application/json'},
        );
      });

      final Map<String, dynamic> body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['status'] == 'success') {
        return {
          'success': true,
          'level': body['level'] ?? level,
          'data': body['data'] ?? [],
        };
      } else {
        return {
          'success': false,
          'message': body['message'] ?? 'Gagal memuat soal memancing.',
          'data': [],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Gagal koneksi ke server soal memancing: $e',
        'data': [],
      };
    }
  }

  /// 2. Ambil Progres & Koleksi Ikan Siswa (GET /api/fishing/progres)
  static Future<Map<String, dynamic>> getFishingProgres({
    int? siswaId,
    String difficulty = 'mudah',
  }) async {
    try {
      final queryParams = <String, String>{
        'difficulty': difficulty.toLowerCase(),
      };
      if (siswaId != null) {
        queryParams['siswa_id'] = siswaId.toString();
      }

      final response = await ApiClient.sendRequest((baseUrl) {
        final uri = Uri.parse('$baseUrl/fishing/progres').replace(
          queryParameters: queryParams,
        );
        return http.get(
          uri,
          headers: {'Accept': 'application/json'},
        );
      });

      final Map<String, dynamic> body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['status'] == 'success') {
        return {
          'success': true,
          'koin': body['koin'] ?? 120,
          'data': body['data'] ?? [],
        };
      } else {
        return {
          'success': false,
          'message': body['message'] ?? 'Gagal memuat progres memancing.',
          'data': [],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Gagal koneksi ke server progres memancing: $e',
        'data': [],
      };
    }
  }

  /// 3. Simpan Hasil Tangkapan Ikan Siswa (POST /api/fishing/selesai)
  static Future<Map<String, dynamic>> submitFishingSelesai({
    int? siswaId,
    required String difficulty,
    required int level,
    required int stars,
    required int score,
    String? fishName,
    String? fishEmoji,
    required int coinsEarned,
  }) async {
    try {
      final payload = <String, dynamic>{
        'difficulty': difficulty.toLowerCase(),
        'level': level,
        'stars': stars,
        'score': score,
        'fish_name': fishName ?? 'Golden Carp',
        'fish_emoji': fishEmoji ?? '🐟',
        'coins_earned': coinsEarned,
      };
      if (siswaId != null) {
        payload['siswa_id'] = siswaId;
      }

      final response = await ApiClient.sendRequest((baseUrl) {
        return http.post(
          Uri.parse('$baseUrl/fishing/selesai'),
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
          'message': body['message'] ?? 'Hasil memancing berhasil disimpan!',
          'koin': body['koin'] ?? 120,
          'coins_awarded': body['coins_awarded'] ??
              (body['data'] != null ? body['data']['coins_awarded'] : null),
          'data': body['data'],
        };
      } else {
        return {
          'success': false,
          'message': body['message'] ?? 'Gagal menyimpan hasil memancing.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Gagal koneksi saat menyimpan hasil memancing: $e',
      };
    }
  }
}

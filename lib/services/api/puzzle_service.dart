import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_client.dart';

/// Service untuk menangani mini game puzzle (level progres, rating bintang, dan reward koin)
class PuzzleService {
  /// 10. Ambil Progres Puzzle Siswa (GET /api/puzzle/progres)
  static Future<Map<String, dynamic>> getPuzzleProgres({
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
        final uri = Uri.parse('$baseUrl/puzzle/progres').replace(
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
          'message': body['message'] ?? 'Gagal memuat progres puzzle.',
          'data': [],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Gagal koneksi ke server puzzle: $e',
        'data': [],
      };
    }
  }

  /// 11. Simpan Penyelesaian Puzzle Siswa (POST /api/puzzle/selesai)
  static Future<Map<String, dynamic>> submitPuzzleSelesai({
    int? siswaId,
    required String difficulty,
    required int level,
    required int stars,
    required String timeSpent,
    required int coinsEarned,
  }) async {
    try {
      final payload = <String, dynamic>{
        'difficulty': difficulty.toLowerCase(),
        'level': level,
        'stars': stars,
        'time_spent': timeSpent,
        'coins_earned': coinsEarned,
      };
      if (siswaId != null) {
        payload['siswa_id'] = siswaId;
      }

      final response = await ApiClient.sendRequest((baseUrl) {
        return http.post(
          Uri.parse('$baseUrl/puzzle/selesai'),
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
          'message': body['message'] ?? 'Progres puzzle berhasil disimpan!',
          'koin': body['koin'] ?? 120,
          'data': body['data'],
        };
      } else {
        return {
          'success': false,
          'message': body['message'] ?? 'Gagal menyimpan progres puzzle.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Gagal koneksi saat menyimpan progres puzzle: $e',
      };
    }
  }
}

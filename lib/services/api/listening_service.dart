import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_client.dart';

/// Service untuk menangani modul listening audio comprehension
class ListeningService {
  /// Cache ID modul listening yang telah diselesaikan siswa
  static final Set<int> completedListeningIds = {};

  static bool isListeningCompleted(int id) => completedListeningIds.contains(id);

  static void markListeningCompleted(int id) {
    completedListeningIds.add(id);
  }

  /// 10. Ambil Daftar Modul Listening Siswa (GET /api/listening)
  static Future<Map<String, dynamic>> getDaftarListening({
    String? tingkat,
    String? kelas,
    int? siswaId,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (tingkat != null &&
          tingkat.trim().isNotEmpty &&
          tingkat.toLowerCase() != 'all' &&
          tingkat.toLowerCase() != 'semua') {
        queryParams['tingkat'] = tingkat.trim();
      }
      if (kelas != null && kelas.trim().isNotEmpty) {
        queryParams['kelas'] = kelas.trim();
      }
      if (siswaId != null) {
        queryParams['siswa_id'] = siswaId.toString();
      }

      final response = await ApiClient.sendRequest((baseUrl) {
        final uri = Uri.parse('$baseUrl/listening').replace(
          queryParameters: queryParams.isNotEmpty ? queryParams : null,
        );
        return http.get(
          uri,
          headers: {'Accept': 'application/json'},
        );
      });

      final Map<String, dynamic> body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['status'] == 'success') {
        final List<dynamic> listRaw = body['data'] ?? [];
        for (final item in listRaw) {
          if (item is Map<String, dynamic> && item['is_completed'] == true) {
            final id = int.tryParse(item['id']?.toString() ?? '');
            if (id != null) completedListeningIds.add(id);
          }
        }
        return {
          'success': true,
          'data': listRaw,
        };
      } else {
        return {
          'success': false,
          'message': body['message'] ?? 'Gagal memuat modul listening.',
          'data': [],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Gagal terhubung ke server listening: $e',
        'data': [],
      };
    }
  }

  /// 11. Ambil Detail Modul Listening & Butir Soal Lengkap (GET /api/listening/{id})
  static Future<Map<String, dynamic>> getDetailListening(int id) async {
    try {
      final response = await ApiClient.sendRequest((baseUrl) {
        return http.get(
          Uri.parse('$baseUrl/listening/$id'),
          headers: {'Accept': 'application/json'},
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
          'message': body['message'] ?? 'Modul listening tidak ditemukan.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Gagal memuat detail modul listening: $e',
      };
    }
  }

  /// 12. Tandai Modul Listening Telah Selesai (POST /api/listening/{id}/selesai)
  static Future<Map<String, dynamic>> selesaikanListening({
    required int listeningId,
    int? siswaId,
    int? skor,
    int? xpReward,
    Map<String, String>? jawaban,
  }) async {
    completedListeningIds.add(listeningId);
    try {
      final payload = <String, dynamic>{
        'skor': skor ?? 100,
        'xp_reward': xpReward ?? 50,
      };
      if (siswaId != null) {
        payload['siswa_id'] = siswaId;
      }
      if (jawaban != null && jawaban.isNotEmpty) {
        payload['jawaban'] = jawaban;
      }

      final response = await ApiClient.sendRequest((baseUrl) {
        return http.post(
          Uri.parse('$baseUrl/listening/$listeningId/selesai'),
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
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_client.dart';

/// Service untuk menangani bank soal & kuis ujian evaluasi
class QuizService {
  /// Cache ID kuis yang telah diselesaikan siswa
  static final Set<int> completedQuizIds = {};

  static bool isQuizCompleted(int id) => completedQuizIds.contains(id);

  static void markQuizCompleted(int id) {
    completedQuizIds.add(id);
  }

  /// 13. Ambil Daftar Kuis Siswa (GET /api/quiz)
  static Future<Map<String, dynamic>> getDaftarQuiz({
    String? kategori,
    String? kelas,
    int? siswaId,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (kategori != null &&
          kategori.trim().isNotEmpty &&
          kategori.toLowerCase() != 'all' &&
          kategori.toLowerCase() != 'semua') {
        queryParams['kategori'] = kategori.trim();
      }
      if (kelas != null && kelas.trim().isNotEmpty) {
        queryParams['kelas'] = kelas.trim();
      }
      if (siswaId != null) {
        queryParams['siswa_id'] = siswaId.toString();
      }

      final response = await ApiClient.sendRequest((baseUrl) {
        final uri = Uri.parse('$baseUrl/quiz').replace(
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
            if (id != null) completedQuizIds.add(id);
          }
        }
        return {
          'success': true,
          'data': listRaw,
        };
      } else {
        return {
          'success': false,
          'message': body['message'] ?? 'Gagal memuat daftar kuis.',
          'data': [],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Gagal terhubung ke server kuis: $e',
        'data': [],
      };
    }
  }

  /// 14. Bergabung Room Kuis dengan Kode Unik (POST /api/quiz/join-room)
  static Future<Map<String, dynamic>> joinQuizRoom(String kodeRoom) async {
    try {
      final response = await ApiClient.sendRequest((baseUrl) {
        return http.post(
          Uri.parse('$baseUrl/quiz/join-room'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode({'kode_room': kodeRoom.trim().toUpperCase()}),
        );
      });

      final Map<String, dynamic> body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['status'] == 'success') {
        return {
          'success': true,
          'message': body['message'] ?? 'Room kuis ditemukan!',
          'data': body['data'],
        };
      } else {
        return {
          'success': false,
          'message': body['message'] ?? 'Kode room tidak valid atau kuis belum aktif.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Gagal bergabung ke room kuis: $e',
      };
    }
  }

  /// 15. Ambil Detail Kuis & Butir Soal Lengkap (GET /api/quiz/{id})
  static Future<Map<String, dynamic>> getDetailQuiz(int id) async {
    try {
      final response = await ApiClient.sendRequest((baseUrl) {
        return http.get(
          Uri.parse('$baseUrl/quiz/$id'),
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
          'message': body['message'] ?? 'Paket kuis tidak ditemukan.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Gagal memuat detail kuis: $e',
      };
    }
  }

  /// 16. Kirim Jawaban Kuis Siswa & Evaluasi Nilai (+ XP Reward) (POST /api/quiz/{id}/submit)
  static Future<Map<String, dynamic>> submitQuizAnswers({
    required int quizId,
    int? siswaId,
    required Map<String, String> jawaban,
    int? waktuPengerjaanDetik,
  }) async {
    completedQuizIds.add(quizId);
    try {
      final payload = <String, dynamic>{
        'jawaban': jawaban,
        'waktu_pengerjaan_detik': waktuPengerjaanDetik ?? 0,
      };
      if (siswaId != null) {
        payload['siswa_id'] = siswaId;
      }

      final response = await ApiClient.sendRequest((baseUrl) {
        return http.post(
          Uri.parse('$baseUrl/quiz/$quizId/submit'),
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
          'message': body['message'] ?? 'Kuis berhasil diselesaikan!',
          'data': body['data'],
        };
      } else {
        return {
          'success': false,
          'message': body['message'] ?? 'Gagal mengirim jawaban kuis.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Gagal mengirim jawaban kuis: $e',
      };
    }
  }
}

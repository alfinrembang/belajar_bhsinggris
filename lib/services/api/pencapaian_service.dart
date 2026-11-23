import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/pencapaian_model.dart';
import 'api_client.dart';

/// Service untuk memuat data Lencana Pencapaian (Achievements) Siswa secara dinamis
class PencapaianService {
  /// Mengambil data seluruh lencana & ringkasan statistik siswa
  /// GET /api/pencapaian?siswa_id={siswaId}
  static Future<Map<String, dynamic>> getPencapaian({int? siswaId}) async {
    try {
      final queryParams = <String, String>{};
      if (siswaId != null && siswaId > 0) {
        queryParams['siswa_id'] = siswaId.toString();
      }

      final response = await ApiClient.sendRequest((baseUrl) {
        final uri = Uri.parse('$baseUrl/pencapaian').replace(
          queryParameters: queryParams.isNotEmpty ? queryParams : null,
        );
        return http.get(
          uri,
          headers: {'Accept': 'application/json'},
        );
      });

      final Map<String, dynamic> body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['status'] == 'success') {
        final summary = PencapaianSummaryModel.fromJson(body['summary'] ?? {});
        final List<dynamic> rawList = body['data'] ?? [];
        final items = rawList.map((j) => PencapaianItemModel.fromJson(j)).toList();

        return {
          'success': true,
          'summary': summary,
          'items': items,
        };
      } else {
        return {
          'success': false,
          'message': body['message'] ?? 'Gagal memuat lencana pencapaian.',
          'summary': const PencapaianSummaryModel(),
          'items': <PencapaianItemModel>[],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Gagal terhubung ke server pencapaian: $e',
        'summary': const PencapaianSummaryModel(),
        'items': <PencapaianItemModel>[],
      };
    }
  }
}

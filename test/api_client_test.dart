import 'dart:convert';
import 'dart:io';

import 'package:belajar_bhsinggris/services/api/api_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    ApiClient.activeBaseUrl = ApiClient.candidateUrls.first;
  });

  group('ApiClient.resolveAudioUrl', () {
    test('rewrites localhost:8000 URL to active Apache base root', () {
      ApiClient.activeBaseUrl =
          'http://192.168.9.210/belajar_bhsinggris_api/public/api';

      final resolved = ApiClient.resolveAudioUrl(
        'http://localhost:8000/storage/listening/audio/sample.wav',
      );

      expect(
        resolved,
        'http://192.168.9.210/belajar_bhsinggris_api/public/storage/listening/audio/sample.wav',
      );
    });

    test('rewrites 127.0.0.1 Apache URL when activeBaseUrl uses another LAN IP', () {
      ApiClient.activeBaseUrl =
          'http://192.168.9.210/belajar_bhsinggris_api/public/api';

      final resolved = ApiClient.resolveAudioUrl(
        'http://127.0.0.1/belajar_bhsinggris_api/public/storage/audio.mp3',
      );

      expect(
        resolved,
        'http://192.168.9.210/belajar_bhsinggris_api/public/storage/audio.mp3',
      );
    });

    test('keeps remote HTTPS URLs unchanged', () {
      ApiClient.activeBaseUrl =
          'http://192.168.9.210/belajar_bhsinggris_api/public/api';

      const externalUrl = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3';
      expect(ApiClient.resolveAudioUrl(externalUrl), externalUrl);
    });
  });

  group('ApiClient manual connection & sendRequest', () {
    test('connectWithManualInput validates /kelas and persists activeBaseUrl', () async {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      addTearDown(server.close);

      server.listen((request) async {
        if (request.uri.path == '/api/kelas') {
          request.response
            ..statusCode = 200
            ..headers.contentType = ContentType.json
            ..write(jsonEncode({
              'status': 'success',
              'tingkat': ['10', '11', '12'],
              'jurusan': ['RPL'],
            }));
        } else if (request.uri.path == '/api/siswa/login') {
          request.response
            ..statusCode = 200
            ..headers.contentType = ContentType.json
            ..write(jsonEncode({'status': 'success'}));
        } else {
          request.response.statusCode = 404;
        }
        await request.response.close();
      });

      final connected = await ApiClient.connectWithManualInput(
        '127.0.0.1:${server.port}',
      );

      expect(connected, 'http://127.0.0.1:${server.port}/api');
      expect(ApiClient.activeBaseUrl, 'http://127.0.0.1:${server.port}/api');

      final res = await ApiClient.sendRequest(
        (baseUrl) => http.post(Uri.parse('$baseUrl/siswa/login')),
      );
      expect(res.statusCode, 200);
    });

    test('connectWithManualInput rejects non-Laravel server responses', () async {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      addTearDown(server.close);

      server.listen((request) async {
        request.response
          ..statusCode = 200
          ..write('<html>Router Admin</html>');
        await request.response.close();
      });

      final connected = await ApiClient.connectWithManualInput(
        '127.0.0.1:${server.port}',
      );
      expect(connected, isNull);
    });
  });
}

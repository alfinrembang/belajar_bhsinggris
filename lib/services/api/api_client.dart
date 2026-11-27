import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Helper Client HTTP dasar untuk menangani multi-fallback & auto-discovery IP backend
class ApiClient {
  static const String _prefBaseUrlKey = 'api_active_base_url';
  static const String _apacheApiPath = '/belajar_bhsinggris_api/public/api';
  static const String _apachePublicPrefix = '/belajar_bhsinggris_api/public';

  // Alamat server: mendukung USB (ADB Reverse)/Localhost, Laragon Apache (port 80),
  // php artisan serve --host=0.0.0.0 (port 8000), dan Android Emulator.
  static const List<String> candidateUrls = [
    'http://127.0.0.1:8000/api', // USB (ADB Reverse) / Localhost
    'http://192.168.9.210/belajar_bhsinggris_api/public/api', // Laragon Apache via Wi-Fi saat ini
    'http://192.168.9.208/belajar_bhsinggris_api/public/api', // Laragon Apache via LAN saat ini
    'http://192.168.9.210:8000/api', // php artisan serve --host=0.0.0.0 via Wi-Fi saat ini
    'http://192.168.9.208:8000/api', // php artisan serve --host=0.0.0.0 via LAN saat ini
    'http://127.0.0.1/belajar_bhsinggris_api/public/api', // Laragon Apache via Localhost
    'http://10.0.2.2:8000/api', // Android Emulator (artisan serve)
    'http://10.0.2.2/belajar_bhsinggris_api/public/api', // Android Emulator (Apache)
  ];

  static String activeBaseUrl = candidateUrls.first;
  static bool _prefsLoaded = false;
  static bool _verifiedThisSession = false;
  static Future<String?>? _ongoingDiscovery;

  /// Muat alamat server terakhir yang berhasil dari penyimpanan lokal sekali saja
  static Future<void> _ensurePrefsLoaded() async {
    if (_prefsLoaded) return;
    _prefsLoaded = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_prefBaseUrlKey);
      if (saved != null && saved.trim().isNotEmpty) {
        activeBaseUrl = saved.trim();
      }
    } catch (_) {}
  }

  /// Simpan alamat server aktif ke penyimpanan lokal
  static Future<void> _saveActiveBaseUrl(String url) async {
    activeBaseUrl = url;
    _verifiedThisSession = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefBaseUrlKey, url);
    } catch (_) {}
  }

  /// Memastikan URL media/audio dapat diakses oleh perangkat Android (menyesuaikan host & path aktif)
  static String resolveAudioUrl(String? url) {
    if (url == null || url.trim().isEmpty) return '';
    final trimmed = url.trim();
    final uri = Uri.tryParse(trimmed);

    if (uri != null && (uri.host == 'localhost' || uri.host == '127.0.0.1')) {
      final baseRoot = activeBaseUrl.endsWith('/api')
          ? activeBaseUrl.substring(0, activeBaseUrl.length - 4)
          : activeBaseUrl;
      var path = uri.path;
      if (path.startsWith(_apachePublicPrefix)) {
        path = path.substring(_apachePublicPrefix.length);
      }
      final query = uri.hasQuery ? '?${uri.query}' : '';
      return '$baseRoot$path$query';
    }
    return trimmed;
  }

  /// Cek apakah error merupakan kegagalan koneksi/jaringan (bukan error respon HTTP/JSON)
  static bool _isConnectionError(Object error) {
    return error is SocketException ||
        error is TimeoutException ||
        error is http.ClientException ||
        error is HandshakeException;
  }

  /// Menguji apakah [baseUrl] adalah backend Laravel belajar_bhsinggris yang aktif
  static Future<String?> _probeHealth(String baseUrl) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/kelas'),
            headers: const {'Accept': 'application/json'},
          )
          .timeout(const Duration(milliseconds: 1500));

      if (response.statusCode == 200 &&
          response.body.contains('"status"') &&
          response.body.contains('"jurusan"')) {
        return baseUrl;
      }
    } catch (_) {}
    return null;
  }

  /// Menjalankan beberapa probe secara paralel dan langsung mengembalikan URL pertama yang valid
  static Future<String?> _firstValidUrl(List<String> urls) async {
    if (urls.isEmpty) return null;

    final completer = Completer<String?>();
    var remaining = urls.length;

    for (final url in urls) {
      _probeHealth(url).then((validUrl) {
        if (validUrl != null && !completer.isCompleted) {
          completer.complete(validUrl);
          return;
        }
        remaining--;
        if (remaining == 0 && !completer.isCompleted) {
          completer.complete(null);
        }
      });
    }

    return completer.future;
  }

  /// Cek koneksi TCP cepat ke satu IP dan port tertentu
  static Future<bool> _isPortOpen(String ip, int port) async {
    try {
      final socket = await Socket.connect(
        ip,
        port,
        timeout: const Duration(milliseconds: 400),
      );
      socket.destroy();
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Memindai satu port pada seluruh host subnet /24 (contoh 192.168.9.1..254)
  static Future<String?> _scanSubnetPort(
    String prefix,
    String ownIp,
    int port,
  ) async {
    final ips = <String>[];
    for (var i = 1; i <= 254; i++) {
      final ip = '$prefix.$i';
      if (ip != ownIp) ips.add(ip);
    }

    final openUrls = <String>[];
    const batchSize = 128;

    for (var start = 0; start < ips.length; start += batchSize) {
      final end = (start + batchSize < ips.length) ? start + batchSize : ips.length;
      final batch = ips.sublist(start, end);

      final results = await Future.wait(
        batch.map((ip) async => (ip, await _isPortOpen(ip, port))),
      );

      for (final (ip, isOpen) in results) {
        if (isOpen) {
          openUrls.add(
            port == 80 ? 'http://$ip$_apacheApiPath' : 'http://$ip:$port/api',
          );
        }
      }

      if (openUrls.isNotEmpty) {
        final matched = await _firstValidUrl(openUrls);
        if (matched != null) return matched;
        openUrls.clear();
      }
    }

    return null;
  }

  /// Deteksi otomatis backend Laravel pada subnet Wi-Fi/LAN lokal perangkat saat ini
  static Future<String?> _discoverFromLocalSubnet() async {
    if (kIsWeb) return null;

    try {
      final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4,
        includeLoopback: false,
      );

      final targets = <(String prefix, String ownIp)>[];
      final seenPrefixes = <String>{};

      for (final iface in interfaces) {
        for (final addr in iface.addresses) {
          final ip = addr.address;
          if (!_isPrivateLanIp(ip)) continue;
          final parts = ip.split('.');
          if (parts.length != 4) continue;
          final prefix = '${parts[0]}.${parts[1]}.${parts[2]}';
          if (seenPrefixes.add(prefix)) {
            targets.add((prefix, ip));
          }
        }
      }

      // Prioritaskan port 80 (Laragon Apache), lalu port 8000 (artisan serve --host=0.0.0.0)
      for (final port in const [80, 8000]) {
        for (final (prefix, ownIp) in targets) {
          final found = await _scanSubnetPort(prefix, ownIp, port);
          if (found != null) return found;
        }
      }
    } catch (_) {}

    return null;
  }

  static bool _isPrivateLanIp(String ip) {
    if (ip.startsWith('192.168.') || ip.startsWith('10.')) return true;
    if (ip.startsWith('172.')) {
      final parts = ip.split('.');
      if (parts.length == 4) {
        final second = int.tryParse(parts[1]) ?? 0;
        return second >= 16 && second <= 31;
      }
    }
    return false;
  }

  /// Mencari server backend yang aktif (kandidat standar paralel + scan subnet Wi-Fi)
  static Future<String?> discoverWorkingBaseUrl({String? excludeUrl}) {
    if (_ongoingDiscovery != null) return _ongoingDiscovery!;

    final future = () async {
      await _ensurePrefsLoaded();

      final orderedCandidates = <String>[
        if (activeBaseUrl != excludeUrl) activeBaseUrl,
        ...candidateUrls.where((url) => url != excludeUrl && url != activeBaseUrl),
      ];

      final candidateMatch = await _firstValidUrl(orderedCandidates);
      if (candidateMatch != null) {
        await _saveActiveBaseUrl(candidateMatch);
        return candidateMatch;
      }

      final subnetMatch = await _discoverFromLocalSubnet();
      if (subnetMatch != null) {
        await _saveActiveBaseUrl(subnetMatch);
        return subnetMatch;
      }

      return null;
    }();

    _ongoingDiscovery = future.whenComplete(() => _ongoingDiscovery = null);
    return _ongoingDiscovery!;
  }

  /// Menguji dan menyimpan IP/URL server yang dimasukkan secara manual oleh pengguna
  static Future<String?> connectWithManualInput(String rawInput) async {
    final cleaned = rawInput.trim().replaceAll(RegExp(r'/+$'), '');
    if (cleaned.isEmpty) return null;

    final candidates = <String>[];
    if (cleaned.startsWith('http://') || cleaned.startsWith('https://')) {
      if (cleaned.endsWith('/api')) {
        candidates.add(cleaned);
      } else {
        final uri = Uri.tryParse(cleaned);
        if (uri != null && (uri.path.isEmpty || uri.path == '/')) {
          candidates.add('$cleaned$_apacheApiPath');
          candidates.add('$cleaned/api');
        } else {
          candidates.add('$cleaned/api');
          candidates.add(cleaned);
        }
      }
    } else if (cleaned.contains(':')) {
      candidates.add('http://$cleaned/api');
    } else {
      candidates.add('http://$cleaned$_apacheApiPath');
      candidates.add('http://$cleaned:8000/api');
    }

    final found = await _firstValidUrl(candidates);
    if (found != null) {
      await _saveActiveBaseUrl(found);
      return found;
    }
    return null;
  }

  /// Helper untuk mengirim HTTP Request dengan multi-fallback & auto-discovery otomatis
  static Future<http.Response> sendRequest(
    Future<http.Response> Function(String baseUrl) requestFn,
  ) async {
    await _ensurePrefsLoaded();
    final initialTimeout =
        _verifiedThisSession ? const Duration(seconds: 6) : const Duration(seconds: 3);

    try {
      final response = await requestFn(activeBaseUrl).timeout(initialTimeout);
      _verifiedThisSession = true;
      return response;
    } catch (e) {
      if (!_isConnectionError(e)) rethrow;

      final discovered = await discoverWorkingBaseUrl(excludeUrl: activeBaseUrl);
      if (discovered != null) {
        return await requestFn(discovered).timeout(const Duration(seconds: 6));
      }
      rethrow;
    }
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service Singleton untuk mengelola Pengingat / Alarm Belajar Harian Siswa secara Realtime.
class PengingatService {
  PengingatService._internal();
  static final PengingatService instance = PengingatService._internal();

  GlobalKey<NavigatorState>? _navigatorKey;

  bool _isAktif = false;
  int _jam = 9;
  int _menit = 0;
  String? _lastRingKey;
  Timer? _timer;

  final List<VoidCallback> _listeners = [];

  bool get isAktif => _isAktif;
  int get jam => _jam;
  int get menit => _menit;

  /// String waktu terformat (contoh: "09:00 WIB")
  String get waktuTampil {
    final j = _jam.toString().padLeft(2, '0');
    final m = _menit.toString().padLeft(2, '0');
    return '$j:$m WIB';
  }

  void addListener(VoidCallback listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  void _notify() {
    for (final l in List.from(_listeners)) {
      l();
    }
  }

  /// Inisialisasi awal saat aplikasi mulai berjalan
  Future<void> init(GlobalKey<NavigatorState> navKey) async {
    _navigatorKey = navKey;
    await _loadFromPrefs();

    // Jalankan timer pemantau waktu realtime (cek setiap 5 detik)
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      _checkRealtimeAlarm();
    });
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isAktif = prefs.getBool('pengingat_aktif') ?? false;
      _jam = prefs.getInt('pengingat_jam') ?? 9;
      _menit = prefs.getInt('pengingat_menit') ?? 0;
      _lastRingKey = prefs.getString('pengingat_last_ring_key');
      _notify();
    } catch (_) {}
  }

  /// Simpan dan terapkan pengaturan pengingat
  Future<void> simpanPengingat({
    required bool aktif,
    required int jam,
    required int menit,
  }) async {
    _isAktif = aktif;
    _jam = jam;
    _menit = menit;
    _notify();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('pengingat_aktif', _isAktif);
      await prefs.setInt('pengingat_jam', _jam);
      await prefs.setInt('pengingat_menit', _menit);
    } catch (_) {}
  }

  /// Nonaktifkan pengingat
  Future<void> matikanPengingat() async {
    _isAktif = false;
    _notify();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('pengingat_aktif', false);
    } catch (_) {}
  }

  /// Pengecekan realtime setiap 5 detik apakah jam perangkat sama dengan jam pengingat
  void _checkRealtimeAlarm() {
    if (!_isAktif) return;

    final now = DateTime.now();
    if (now.hour == _jam && now.minute == _menit) {
      final ringKey = '${now.year}-${now.month}-${now.day}_${now.hour}:${now.minute}';
      if (_lastRingKey != ringKey) {
        _lastRingKey = ringKey;
        SharedPreferences.getInstance().then((prefs) {
          prefs.setString('pengingat_last_ring_key', ringKey);
        });

        // Picu pesan alarm realtime
        showAlarmDialog(isPreview: false);
      }
    }
  }

  /// Menampilkan Pop-up Pesan Alarm Pengingat Belajar
  void showAlarmDialog({
    BuildContext? context,
    bool isPreview = false,
  }) {
    final ctx = context ?? _navigatorKey?.currentContext;
    if (ctx == null) return;

    final j = _jam.toString().padLeft(2, '0');
    final m = _menit.toString().padLeft(2, '0');
    final waktuStr = '$j:$m WIB';

    showDialog(
      context: ctx,
      barrierDismissible: true,
      builder: (dialogCtx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0066D6).withValues(alpha: 0.18),
                  blurRadius: 28,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header Icon Alarm dengan Efek Gelombang
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF38BDF8), Color(0xFF0284C7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0284C7).withValues(alpha: 0.35),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.notifications_active_rounded,
                      color: Colors.white,
                      size: 34,
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // Badge Waktu Pengingat
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F2FE),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: Color(0xFF0369A1),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isPreview ? 'Tes Pengingat ($waktuStr)' : 'Waktu Belajar: $waktuStr',
                        style: GoogleFonts.poppins(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0369A1),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Judul Notifikasi
                Text(
                  'Saatnya Belajar Bahasa Inggris! 🔔',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                    letterSpacing: -0.3,
                  ),
                ),

                const SizedBox(height: 8),

                // Isi Pesan Motivasi
                Text(
                  'Halo! Pengingat harianmu telah berbunyi. Luangkan waktu 10–15 menit untuk mengasah kemampuan reading, listening, atau menyelesaikan kuis hari ini!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF64748B),
                    height: 1.45,
                  ),
                ),

                const SizedBox(height: 22),

                // Tombol Aksi
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(
                            color: Color(0xFFCBD5E1),
                            width: 1.2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () => Navigator.of(dialogCtx).pop(),
                        child: Text(
                          'Nanti Saja',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: const Color(0xFF0066D6),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(dialogCtx).pop();
                          // Kembali ke halaman beranda jika memungkinkan
                          Navigator.of(ctx).popUntil((route) => route.isFirst);
                        },
                        child: Text(
                          'Mulai Belajar 🚀',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

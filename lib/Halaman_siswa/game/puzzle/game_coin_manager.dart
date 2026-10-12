import 'package:flutter/foundation.dart';

/// Pengelola Koin Virtual Siswa (Dinamis & Reaktif)
/// Memungkinkan saldo koin bertambah saat menyelesaikan level,
/// dan otomatis ter-update di seluruh halaman (Home, Pilih Level, dll).
class GameCoinManager {
  // Saldo awal koin siswa (default 120 koin sesuai desain)
  static final ValueNotifier<int> coins = ValueNotifier<int>(120);

  /// Menambah koin (misal setelah menang level puzzle)
  static void addCoins(int amount) {
    coins.value += amount;
  }

  /// Mengurangi koin (misal membeli item di toko)
  static bool spendCoins(int amount) {
    if (coins.value >= amount) {
      coins.value -= amount;
      return true;
    }
    return false;
  }

  /// Mengatur jumlah koin secara langsung
  static void setCoins(int amount) {
    coins.value = amount;
  }
}

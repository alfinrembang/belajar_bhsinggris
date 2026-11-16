import 'package:flutter/foundation.dart';

/// Pengelola Koin Virtual Siswa (Dinamis & Reaktif)
/// Memungkinkan saldo koin bertambah saat menyelesaikan level,
/// dan otomatis ter-update di seluruh halaman (Home, Tangkap Ikan, dll).
class GameCoinManager {
  // Saldo awal koin siswa (default 120 koin sesuai desain)
  static final ValueNotifier<int> coins = ValueNotifier<int>(120);

  // Akumulasi Experience Points (EXP) siswa
  static final ValueNotifier<int> exp = ValueNotifier<int>(350);

  /// Level siswa berdasarkan akumulasi EXP (tiap 200 EXP naik 1 level)
  static int get level => (exp.value ~/ 200) + 1;

  /// Menambah koin (misal setelah menang game)
  static void addCoins(int amount) {
    coins.value += amount;
  }

  /// Menambah EXP siswa
  static void addExp(int amount) {
    exp.value += amount;
  }

  /// Mengurangi koin (misal membeli item)
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

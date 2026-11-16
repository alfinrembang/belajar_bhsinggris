import 'package:flutter/material.dart';

/// Peran Pemain dalam Game Tebak Serigala
enum WerewolfRole {
  domba, // 🐑 Domba (Warga / Civilian)
  serigala, // 🐺 Serigala (Wolf / Undercover)
}

/// Status Tahapan Permainan
enum WerewolfPhase {
  revealCard, // Melihat kartu kata & peran rahasia
  inputClue, // Mengisi form ciri-ciri bahasa Inggris
  readingClues, // Membaca ciri-ciri yang telah dikirim seluruh pemain
  wolfAction, // POV Serigala: Aksi serigala memangsa/membunuh 1 player
  voting, // Memilih pemain yang dicurigai sebagai Serigala (Waktu 30s)
  eliminationResult, // Pengumuman siapa yang di-vote keluar
  gameOver, // Permainan berakhir (Pengumuman Pemenang, Koin & EXP)
}

/// Data Pasangan Kosakata Bahasa Inggris (Word Pair)
class WerewolfWordPair {
  final String id;
  final String theme; // Kategori tema (misal: "Food & Snacks", "Animals", dll)
  final String dombaWord; // Kata untuk Domba (English)
  final String dombaMeaning; // Arti kata Domba (Indonesian)
  final String serigalaWord; // Kata untuk Serigala (English)
  final String serigalaMeaning; // Arti kata Serigala (Indonesian)
  final List<String> botDombaClues; // Contoh petunjuk bot jika jadi Domba
  final List<String> botSerigalaClues; // Contoh petunjuk bot jika jadi Serigala (bluffing)
  final String explanation; // Penjelasan perbedaan edukasi bahasa Inggris

  const WerewolfWordPair({
    required this.id,
    required this.theme,
    required this.dombaWord,
    required this.dombaMeaning,
    required this.serigalaWord,
    required this.serigalaMeaning,
    required this.botDombaClues,
    required this.botSerigalaClues,
    required this.explanation,
  });
}

/// Data Pemain dalam Permainan
class WerewolfPlayer {
  final String id;
  final String name;
  final String avatarEmoji;
  final Color avatarColor;
  final bool isBot;
  WerewolfRole role;
  String word;
  String meaning;
  bool isAlive;
  bool isKilledByWolf;
  String? currentClue;
  final List<String> clueHistory;
  int votesReceived;
  int earnedCoins;
  int earnedExp;

  WerewolfPlayer({
    required this.id,
    required this.name,
    required this.avatarEmoji,
    required this.avatarColor,
    this.isBot = false,
    required this.role,
    required this.word,
    required this.meaning,
    this.isAlive = true,
    this.isKilledByWolf = false,
    this.currentClue,
    List<String>? clueHistory,
    this.votesReceived = 0,
    this.earnedCoins = 0,
    this.earnedExp = 0,
  }) : clueHistory = clueHistory ?? [];

  bool get isSerigala => role == WerewolfRole.serigala;
  bool get isDomba => role == WerewolfRole.domba;

  String get roleName => isSerigala ? 'Serigala' : 'Domba';
  String get roleEmoji => isSerigala ? '🐺' : '🐑';
}

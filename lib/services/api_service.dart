// Facade API Service - Pintu gerbang utama ke semua API domain
// Mendukung ekspor langsung dan pendelegasian statis demi kompatibilitas 100%

export 'api/api_client.dart';
export 'api/auth_service.dart';
export 'api/materi_service.dart';
export 'api/listening_service.dart';
export 'api/quiz_service.dart';
export 'api/puzzle_service.dart';
export 'api/siswa_service.dart';

import 'api/api_client.dart';
import 'api/auth_service.dart';
import 'api/materi_service.dart';
import 'api/listening_service.dart';
import 'api/quiz_service.dart';
import 'api/puzzle_service.dart';
import 'api/siswa_service.dart';

/// Facade untuk menjaga kompatibilitas mundur (backward-compatible)
/// sehingga seluruh halaman UI tetap memanggil `ApiService.xxx()` tanpa error.
class ApiService {
  // ----------------------------------------------------
  // Client & Network Helper
  // ----------------------------------------------------
  static String get activeBaseUrl => ApiClient.activeBaseUrl;
  static set activeBaseUrl(String url) => ApiClient.activeBaseUrl = url;
  static String resolveAudioUrl(String? url) => ApiClient.resolveAudioUrl(url);

  // ----------------------------------------------------
  // Autentikasi Siswa
  // ----------------------------------------------------
  static Future<Map<String, dynamic>> registerSiswa({
    required String nama,
    required String email,
    required String nisn,
    required String kelas,
    required String jurusan,
    required String noKelas,
    String? noAbsen,
    required String sandi,
  }) =>
      AuthService.registerSiswa(
        nama: nama,
        email: email,
        nisn: nisn,
        kelas: kelas,
        jurusan: jurusan,
        noKelas: noKelas,
        noAbsen: noAbsen,
        sandi: sandi,
      );

  static Future<Map<String, dynamic>> loginSiswa({
    String? email,
    String? nisn,
    required String sandi,
  }) =>
      AuthService.loginSiswa(email: email, nisn: nisn, sandi: sandi);

  static Future<Map<String, dynamic>> lupaSandiSiswa({required String email}) =>
      AuthService.lupaSandiSiswa(email: email);

  static Future<Map<String, dynamic>> getProfilSiswa({required String token}) =>
      AuthService.getProfilSiswa(token: token);

  static Future<bool> logoutSiswa({required String token}) =>
      AuthService.logoutSiswa(token: token);

  // ----------------------------------------------------
  // Modul Materi & Reading
  // ----------------------------------------------------
  static Set<int> get completedMateriIds => MateriService.completedMateriIds;
  static bool isMateriCompleted(int id) => MateriService.isMateriCompleted(id);
  static void markMateriCompleted(int id) => MateriService.markMateriCompleted(id);

  static Future<Map<String, dynamic>> getDaftarMateri({
    String? kelas,
    String? kategori,
    int? siswaId,
  }) =>
      MateriService.getDaftarMateri(kelas: kelas, kategori: kategori, siswaId: siswaId);

  static Future<Map<String, dynamic>> getDetailMateri(int id) =>
      MateriService.getDetailMateri(id);

  static Future<Map<String, dynamic>> selesaikanMateri({
    required int materiId,
    int? siswaId,
    int? skor,
    int? xpReward,
    Map<String, String>? jawaban,
  }) =>
      MateriService.selesaikanMateri(
        materiId: materiId,
        siswaId: siswaId,
        skor: skor,
        xpReward: xpReward,
        jawaban: jawaban,
      );

  static Future<Map<String, dynamic>> getProgresMateri({int? siswaId}) =>
      MateriService.getProgresMateri(siswaId: siswaId);

  // ----------------------------------------------------
  // Modul Listening Audio
  // ----------------------------------------------------
  static Set<int> get completedListeningIds => ListeningService.completedListeningIds;
  static bool isListeningCompleted(int id) => ListeningService.isListeningCompleted(id);
  static void markListeningCompleted(int id) => ListeningService.markListeningCompleted(id);

  static Future<Map<String, dynamic>> getDaftarListening({
    String? tingkat,
    String? kelas,
    int? siswaId,
  }) =>
      ListeningService.getDaftarListening(tingkat: tingkat, kelas: kelas, siswaId: siswaId);

  static Future<Map<String, dynamic>> getDetailListening(int id) =>
      ListeningService.getDetailListening(id);

  static Future<Map<String, dynamic>> selesaikanListening({
    required int listeningId,
    int? siswaId,
    int? skor,
    int? xpReward,
    Map<String, String>? jawaban,
  }) =>
      ListeningService.selesaikanListening(
        listeningId: listeningId,
        siswaId: siswaId,
        skor: skor,
        xpReward: xpReward,
        jawaban: jawaban,
      );

  // ----------------------------------------------------
  // Modul Bank Soal & Kuis
  // ----------------------------------------------------
  static Set<int> get completedQuizIds => QuizService.completedQuizIds;
  static bool isQuizCompleted(int id) => QuizService.isQuizCompleted(id);
  static void markQuizCompleted(int id) => QuizService.markQuizCompleted(id);

  static Future<Map<String, dynamic>> getDaftarQuiz({
    String? kategori,
    String? kelas,
    int? siswaId,
  }) =>
      QuizService.getDaftarQuiz(kategori: kategori, kelas: kelas, siswaId: siswaId);

  static Future<Map<String, dynamic>> joinQuizRoom(String kodeRoom) =>
      QuizService.joinQuizRoom(kodeRoom);

  static Future<Map<String, dynamic>> getDetailQuiz(int id) =>
      QuizService.getDetailQuiz(id);

  static Future<Map<String, dynamic>> submitQuizAnswers({
    required int quizId,
    int? siswaId,
    required Map<String, String> jawaban,
    int? waktuPengerjaanDetik,
  }) =>
      QuizService.submitQuizAnswers(
        quizId: quizId,
        siswaId: siswaId,
        jawaban: jawaban,
        waktuPengerjaanDetik: waktuPengerjaanDetik,
      );

  // ----------------------------------------------------
  // Mini Game Puzzle
  // ----------------------------------------------------
  static Future<Map<String, dynamic>> getPuzzleProgres({
    int? siswaId,
    String difficulty = 'mudah',
  }) =>
      PuzzleService.getPuzzleProgres(siswaId: siswaId, difficulty: difficulty);

  static Future<Map<String, dynamic>> submitPuzzleSelesai({
    int? siswaId,
    required String difficulty,
    required int level,
    required int stars,
    required String timeSpent,
    required int coinsEarned,
  }) =>
      PuzzleService.submitPuzzleSelesai(
        siswaId: siswaId,
        difficulty: difficulty,
        level: level,
        stars: stars,
        timeSpent: timeSpent,
        coinsEarned: coinsEarned,
      );

  // ----------------------------------------------------
  // Profil & Kenaikan Kelas Siswa
  // ----------------------------------------------------
  static Future<Map<String, dynamic>> getStatusAkademik({int? siswaId}) =>
      SiswaService.getStatusAkademik(siswaId: siswaId);

  static Future<Map<String, dynamic>> updateProfilSiswa({
    required int siswaId,
    String? namaLengkap,
    String? kelasLengkap,
    String? kelas,
    String? noKelas,
    String? noAbsen,
    String? sandiLama,
    String? sandiBaru,
  }) =>
      SiswaService.updateProfilSiswa(
        siswaId: siswaId,
        namaLengkap: namaLengkap,
        kelasLengkap: kelasLengkap,
        kelas: kelas,
        noKelas: noKelas,
        noAbsen: noAbsen,
        sandiLama: sandiLama,
        sandiBaru: sandiBaru,
      );
}

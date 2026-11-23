import 'package:flutter/material.dart';

/// Model untuk Ringkasan Statistik Lencana Pencapaian Siswa
class PencapaianSummaryModel {
  final int totalTerbuka;
  final int totalTerkunci;
  final int selesai;
  final int totalLencana;
  final int persentase;

  const PencapaianSummaryModel({
    this.totalTerbuka = 0,
    this.totalTerkunci = 0,
    this.selesai = 0,
    this.totalLencana = 0,
    this.persentase = 0,
  });

  factory PencapaianSummaryModel.fromJson(Map<String, dynamic> json) {
    return PencapaianSummaryModel(
      totalTerbuka: (json['total_terbuka'] as num?)?.toInt() ?? 0,
      totalTerkunci: (json['total_terkunci'] as num?)?.toInt() ?? 0,
      selesai: (json['selesai'] as num?)?.toInt() ?? 0,
      totalLencana: (json['total_lencana'] as num?)?.toInt() ?? 0,
      persentase: (json['persentase'] as num?)?.toInt() ?? 0,
    );
  }
}

/// Model untuk Butir Lencana Pencapaian Siswa (Dinamis dari Backend)
class PencapaianItemModel {
  final String id;
  final String title;
  final String description;
  final String info;
  final String kategori;
  final String status; // 'Terbuka', 'Terkunci', 'Selesai', 'Langka'
  final bool isUnlocked;
  final num currentProgress;
  final num targetProgress;
  final String progressText;
  final double progressPercent;
  final String? unlockedAt;
  final String iconName;
  final String iconColorHex;
  final String iconBgColorHex;
  final String tentang;
  final List<String> kriteria;
  final List<String> pencapaianTerkait;

  const PencapaianItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.info,
    required this.kategori,
    required this.status,
    required this.isUnlocked,
    required this.currentProgress,
    required this.targetProgress,
    required this.progressText,
    required this.progressPercent,
    this.unlockedAt,
    required this.iconName,
    required this.iconColorHex,
    required this.iconBgColorHex,
    required this.tentang,
    required this.kriteria,
    required this.pencapaianTerkait,
  });

  factory PencapaianItemModel.fromJson(Map<String, dynamic> json) {
    List<String> parseStringList(dynamic value) {
      if (value is List) {
        return value.map((e) => e.toString()).toList();
      }
      return [];
    }

    return PencapaianItemModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      info: json['info']?.toString() ?? '',
      kategori: json['kategori']?.toString() ?? 'Semua',
      status: json['status']?.toString() ?? 'Terkunci',
      isUnlocked: json['is_unlocked'] == true || json['is_unlocked'] == 1,
      currentProgress: (json['current_progress'] as num?) ?? 0,
      targetProgress: (json['target_progress'] as num?) ?? 1,
      progressText: json['progress_text']?.toString() ?? '',
      progressPercent: (json['progress_percent'] as num?)?.toDouble() ?? 0.0,
      unlockedAt: json['unlocked_at']?.toString(),
      iconName: json['icon_name']?.toString() ?? 'military_tech',
      iconColorHex: json['icon_color']?.toString() ?? '#0066D6',
      iconBgColorHex: json['icon_bg_color']?.toString() ?? '#DBEAFE',
      tentang: json['tentang']?.toString() ?? '',
      kriteria: parseStringList(json['kriteria']),
      pencapaianTerkait: parseStringList(json['pencapaian_terkait']),
    );
  }

  /// Helper untuk mengonversi string icon_name menjadi IconData Flutter yang tepat
  IconData get icon {
    switch (iconName.toLowerCase()) {
      case 'local_fire_department':
        return Icons.local_fire_department_rounded;
      case 'sports_esports':
        return Icons.sports_esports_rounded;
      case 'emoji_events':
        return Icons.emoji_events_rounded;
      case 'wb_sunny':
        return Icons.wb_sunny_rounded;
      case 'check_circle':
        return Icons.check_circle_rounded;
      case 'phishing':
        return Icons.phishing_rounded;
      case 'psychology':
        return Icons.psychology_rounded;
      case 'menu_book':
        return Icons.menu_book_rounded;
      case 'headphones':
        return Icons.headphones_rounded;
      case 'flag':
        return Icons.flag_rounded;
      case 'visibility':
        return Icons.visibility_rounded;
      case 'auto_stories':
        return Icons.auto_stories_rounded;
      case 'star':
        return Icons.star_rounded;
      case 'trending_up':
        return Icons.trending_up_rounded;
      case 'bug_report':
        return Icons.bug_report_rounded;
      default:
        return Icons.military_tech_rounded;
    }
  }

  /// Helper parsing Hex Color untuk icon
  Color get iconColor {
    return _parseHexColor(iconColorHex, fallback: const Color(0xFF0066D6));
  }

  /// Helper parsing Hex Color untuk background icon
  Color get iconBgColor {
    return _parseHexColor(iconBgColorHex, fallback: const Color(0xFFDBEAFE));
  }

  static Color _parseHexColor(String hexString, {required Color fallback}) {
    try {
      final buffer = StringBuffer();
      if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
      buffer.write(hexString.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (_) {
      return fallback;
    }
  }
}

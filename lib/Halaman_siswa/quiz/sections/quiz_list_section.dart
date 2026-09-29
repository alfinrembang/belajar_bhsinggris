import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../isi_quiz/isi_quiz_page.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/materi_thumbnail.dart';

/// Model Data Kuis Siswa
class QuizItemData {
  final String id;
  final String title;
  final String category;
  final int durasiMenit;
  final int jumlahSoal;
  final int xp;
  final IconData? customIcon;

  const QuizItemData({
    required this.id,
    required this.title,
    required this.category,
    required this.durasiMenit,
    required this.jumlahSoal,
    required this.xp,
    this.customIcon,
  });
}

/// Section List Quiz Tersedia: Menampilkan kartu-kartu kuis interaktif
/// lengkap dengan MateriThumbnail squircle pastel, metadata durasi & soal,
/// badge XP keemasan, dan tombol Mulai menggunakan CustomButton.
class QuizListSection extends StatelessWidget {
  final List<QuizItemData> items;
  final ValueChanged<QuizItemData>? onMulaiQuiz;

  const QuizListSection({
    super.key,
    required this.items,
    this.onMulaiQuiz,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildQuizCard(context, item);
      },
    );
  }

  Widget _buildQuizCard(BuildContext context, QuizItemData item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _handleCardTap(context, item),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFF1F5F9),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: 0.05),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Thumbnail Squircle Pastel (MateriThumbnail Reusable)
              MateriThumbnail(
                category: item.category,
                size: 64,
                iconSize: 30,
                borderRadius: BorderRadius.circular(18),
                customIcon: item.customIcon,
              ),

              const SizedBox(width: 13),

              // 2. Info Kuis (Judul, Durasi, Jumlah Soal, XP)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Judul Kuis
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                        height: 1.25,
                      ),
                    ),

                    const SizedBox(height: 5),

                    // Baris Metadata: ⏱ Menit & 📋 Soal
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 13.5,
                          color: Color(0xFF64748B),
                        ),
                        const SizedBox(width: 3.5),
                        Text(
                          '${item.durasiMenit} Menit',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.assignment_outlined,
                          size: 13.5,
                          color: Color(0xFF64748B),
                        ),
                        const SizedBox(width: 3.5),
                        Text(
                          '${item.jumlahSoal} Soal',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 5),

                    // Badge XP Bintang Keemasan
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.stars_rounded,
                          size: 15,
                          color: Color(0xFFD97706),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '+${item.xp} XP',
                          style: GoogleFonts.poppins(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFFD97706),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // 3. Tombol "Mulai ▶" (CustomButton Reusable)
              CustomButton(
                text: 'Mulai',
                icon: Icons.play_arrow_rounded,
                iconSize: 15,
                height: 34,
                width: 86,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                borderRadius: BorderRadius.circular(12),
                onTap: () => _handleCardTap(context, item),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleCardTap(BuildContext context, QuizItemData item) {
    if (onMulaiQuiz != null) {
      onMulaiQuiz!(item);
    } else {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (ctx) => Container(
          padding: const EdgeInsets.all(22),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(26),
              topRight: Radius.circular(26),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  MateriThumbnail(
                    category: item.category,
                    size: 54,
                    iconSize: 26,
                    borderRadius: BorderRadius.circular(16),
                    customIcon: item.customIcon,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          '${item.durasiMenit} Menit • ${item.jumlahSoal} Soal • +${item.xp} XP',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Mulai Kuis Sekarang',
                icon: Icons.play_arrow_rounded,
                height: 44,
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  Navigator.of(ctx).pop();
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (c, a, s) => IsiQuizPage(
                        quizData: item,
                      ),
                      transitionDuration: const Duration(milliseconds: 300),
                      transitionsBuilder: (c, a, s, child) =>
                          FadeTransition(opacity: a, child: child),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    }
  }
}

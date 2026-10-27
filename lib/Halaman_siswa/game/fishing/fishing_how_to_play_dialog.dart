import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../widgets/custom_button.dart';

/// Modal Petunjuk / Cara Bermain Word Fishing
/// Tampilan cerah, lucu, ramah anak, dan nyaman dipandang.
void showFishingHowToPlay(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return Container(
        height: MediaQuery.of(ctx).size.height * 0.82,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
        child: Column(
          children: [
            // Drag Handle
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 16),

            // Header Modal
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF38BDF8), Color(0xFF0284C7)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0284C7).withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text('🐠', style: TextStyle(fontSize: 26)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cara Bermain Tangkap Ikan',
                        style: GoogleFonts.poppins(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        'Petunjuk seru menangkap ikan sambil asah kosakata!',
                        style: GoogleFonts.poppins(
                          fontSize: 11.5,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(color: Color(0xFFF1F5F9), height: 1),
            const SizedBox(height: 12),

            // Konten Panduan Langkah demi Langkah
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildGuideCard(
                    step: '1',
                    emoji: '🐠',
                    title: 'Perhatikan Ikan Laut yang Berenang',
                    desc: 'Ikan-ikan laut (Clownfish, Blue Tang, Yellow Tang, Coral Angel, Ruby Reef) berenang bebas menembus samudra luas.',
                    bgColor: const Color(0xFFF0F9FF),
                    borderColor: const Color(0xFFBAE6FD),
                    accentColor: const Color(0xFF0284C7),
                  ),
                  const SizedBox(height: 12),
                  _buildGuideCard(
                    step: '2',
                    emoji: '🦐',
                    title: 'Gunakan Tombol "Beri Makan Ikan"',
                    desc: 'Ikan berenang terlalu lincah atau sulit dijangkau? Tekan tombol Beri Makan di pojok bawah agar semua ikan berkumpul di tengah laut selama 3 detik!',
                    bgColor: const Color(0xFFFEFCE8),
                    borderColor: const Color(0xFFFDE047),
                    accentColor: const Color(0xFFD97706),
                  ),
                  const SizedBox(height: 12),
                  _buildGuideCard(
                    step: '3',
                    emoji: '👆',
                    title: 'Klik / Tap Ikan untuk Menangkap',
                    desc: 'Sentuh ikan yang sedang berenang. Karena tanpa badge kata di ikan, kamu harus cermat menangkapnya untuk membuka soal kuis kosakata!',
                    bgColor: const Color(0xFFECFDF5),
                    borderColor: const Color(0xFFA7F3D0),
                    accentColor: const Color(0xFF059669),
                  ),
                  const SizedBox(height: 12),
                  _buildGuideCard(
                    step: '4',
                    emoji: '💡',
                    title: 'Jawab Kuis & Dapatkan Feedback',
                    desc: 'Jika benar, ikan berhasil ditangkap! Jika salah, ikan lepas dan kamu akan diberitahu kunci jawaban yang benar agar bisa belajar.',
                    bgColor: const Color(0xFFF5F3FF),
                    borderColor: const Color(0xFFDDD6FE),
                    accentColor: const Color(0xFF7C3AED),
                  ),
                  const SizedBox(height: 12),
                  _buildGuideCard(
                    step: '5',
                    emoji: '🏆',
                    title: 'Tangkap Semua Ikan & Menangkan Koin',
                    desc: 'Kuasai seluruh soal, tangkap semua ikan laut, dan menangkan bintang serta koin hadiah untuk profilmu!',
                    bgColor: const Color(0xFFFFF7ED),
                    borderColor: const Color(0xFFFED7AA),
                    accentColor: const Color(0xFFEA580C),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            // Tombol Tutup
            CustomButton(
              text: 'Mengerti, Siap Tangkap Ikan! 🐠',
              icon: Icons.check_circle_rounded,
              gradientColors: const [Color(0xFF0EA5E9), Color(0xFF0284C7)],
              onTap: () => Navigator.pop(ctx),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildGuideCard({
  required String step,
  required String emoji,
  required String title,
  required String desc,
  required Color bgColor,
  required Color borderColor,
  required Color accentColor,
}) {
  return Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: borderColor, width: 1.4),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: accentColor.withValues(alpha: 0.15),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(emoji, style: const TextStyle(fontSize: 18)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Langkah $step',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: accentColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F172A),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                desc,
                style: GoogleFonts.poppins(
                  fontSize: 11.5,
                  color: const Color(0xFF475569),
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

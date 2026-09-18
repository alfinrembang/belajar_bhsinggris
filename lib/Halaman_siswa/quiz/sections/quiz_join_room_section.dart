import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/custom_button.dart';

/// Section Hero "JOIN ROOM": Kartu hero berukuran dan proporsi konsisten
/// dengan HeroCard di Beranda & Materi (height: 110, radius: 22, border putih 1.5),
/// dilengkapi gradien biru cerah, input kode room (search bar), rakun membaca buku (rakun_quiz.png)
/// yang diperbesar, serta tombol GO interaktif.
class QuizJoinRoomSection extends StatefulWidget {
  final ValueChanged<String>? onJoinRoom;

  const QuizJoinRoomSection({super.key, this.onJoinRoom});

  @override
  State<QuizJoinRoomSection> createState() => _QuizJoinRoomSectionState();
}

class _QuizJoinRoomSectionState extends State<QuizJoinRoomSection> {
  final TextEditingController _codeController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _handleJoin() {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan masukkan kode room kuis terlebih dahulu!'),
          backgroundColor: Color(0xFFEF4444),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() => _isLoading = false);

      if (widget.onJoinRoom != null) {
        widget.onJoinRoom!(code);
      } else {
        showDialog(
          context: context,
          builder: (dialogCtx) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F1FB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.meeting_room_rounded, color: Color(0xFF0066D6), size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Room: $code',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
              ],
            ),
            content: Text(
              'Sedang menghubungkan ke room kuis dengan kode "$code". Bersiaplah untuk tantangan seru!',
              style: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF475569), height: 1.4),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogCtx).pop(),
                child: Text(
                  'Tutup',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0066D6),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 110, // Ukuran proporsional & konsisten dengan HeroCard Beranda & Materi
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF00A2E8), // Sky blue cerah
            Color(0xFF007AE5), // Transisi biru
            Color(0xFF0066D6), // Royal blue pekat
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0066D6).withValues(alpha: 0.28),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(21),
        child: Stack(
          children: [
            // 1. Judul "JOIN ROOM" di Kiri Atas
            Positioned(
              left: 16,
              top: 10,
              child: Text(
                'JOIN ROOM',
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF074382),
                  letterSpacing: 0.5,
                ),
              ),
            ),

            // 2. Search Bar / Input Box "Masukan code room"
            Positioned(
              left: 16,
              right: 102,
              top: 38,
              bottom: 12,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFD8DEE6),
                  borderRadius: BorderRadius.circular(13),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                alignment: Alignment.centerLeft,
                child: TextField(
                  controller: _codeController,
                  onSubmitted: (_) => _handleJoin(),
                  textCapitalization: TextCapitalization.characters,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Masukan code\nroom',
                    hintMaxLines: 2,
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF475569),
                      height: 1.15,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),

            // 3. Karakter Rakun Membaca Buku (Diperbesar dan diletakkan tepat di atas tombol GO)
            Positioned(
              right: 14,
              top: 4,
              bottom: 38,
              width: 76,
              child: Image.asset(
                'assets/images/rakun_quiz.png',
                fit: BoxFit.contain,
                alignment: Alignment.bottomCenter,
                errorBuilder: (ctx, err, stack) => const Icon(
                  Icons.school_rounded,
                  color: Colors.white,
                  size: 44,
                ),
              ),
            ),

            // 4. Tombol GO Interaktif di Bawah Rakun
            Positioned(
              right: 14,
              bottom: 10,
              width: 76,
              height: 28,
              child: CustomButton(
                text: 'GO',
                width: 76,
                height: 28,
                fontSize: 14,
                fontWeight: FontWeight.w900,
                borderRadius: BorderRadius.circular(10),
                isLoading: _isLoading,
                onTap: _handleJoin,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

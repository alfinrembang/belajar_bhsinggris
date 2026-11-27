import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Item pernyataan untuk soal kuis bertipe True / False.
class QuizStatementItem {
  final int no;
  final String teks;

  const QuizStatementItem({
    required this.no,
    required this.teks,
  });
}

/// Section Opsi Tabel Pernyataan True / False untuk soal tipe `true_false`.
class IsiQuizTrueFalseSection extends StatelessWidget {
  final List<QuizStatementItem> statements;
  final Map<int, String> selectedAnswers;
  final void Function(int statementNo, String value) onSelectAnswer;

  const IsiQuizTrueFalseSection({
    super.key,
    required this.statements,
    required this.selectedAnswers,
    required this.onSelectAnswer,
  });

  @override
  Widget build(BuildContext context) {
    final answeredCount =
        statements.where((s) => selectedAnswers.containsKey(s.no)).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Petunjuk & Progres Pernyataan
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFBFDBFE)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.fact_check_outlined,
                size: 18,
                color: Color(0xFF0056D2),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Pilih True (Benar) atau False (Salah) pada setiap pernyataan:',
                  style: GoogleFonts.poppins(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E3A8A),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: answeredCount == statements.length && statements.isNotEmpty
                      ? const Color(0xFFDCFCE7)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$answeredCount/${statements.length}',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: answeredCount == statements.length && statements.isNotEmpty
                        ? const Color(0xFF15803D)
                        : const Color(0xFF0056D2),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Daftar Kartu Pernyataan
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: statements.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = statements[index];
            final currentVal = selectedAnswers[item.no];
            final hasValue = currentVal == 'true' || currentVal == 'false';

            return AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: hasValue
                      ? const Color(0xFF93C5FD)
                      : const Color(0xFFE2E8F0),
                  width: hasValue ? 1.4 : 1.1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00386B).withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: hasValue
                              ? const Color(0xFF0056D2)
                              : const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            '${item.no}',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: hasValue
                                  ? Colors.white
                                  : const Color(0xFF0056D2),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          item.teks,
                          style: GoogleFonts.poppins(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0F172A),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _TrueFalseChoiceButton(
                          label: 'True',
                          sublabel: 'Benar',
                          isSelected: currentVal == 'true',
                          isTrueOption: true,
                          onTap: () => onSelectAnswer(item.no, 'true'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _TrueFalseChoiceButton(
                          label: 'False',
                          sublabel: 'Salah',
                          isSelected: currentVal == 'false',
                          isTrueOption: false,
                          onTap: () => onSelectAnswer(item.no, 'false'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _TrueFalseChoiceButton extends StatelessWidget {
  final String label;
  final String sublabel;
  final bool isSelected;
  final bool isTrueOption;
  final VoidCallback onTap;

  const _TrueFalseChoiceButton({
    required this.label,
    required this.sublabel,
    required this.isSelected,
    required this.isTrueOption,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color activeColor =
        isTrueOption ? const Color(0xFF10B981) : const Color(0xFFEF4444);
    final Color activeBg =
        isTrueOption ? const Color(0xFFECFDF5) : const Color(0xFFFEF2F2);
    final Color activeText =
        isTrueOption ? const Color(0xFF047857) : const Color(0xFFB91C1C);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          decoration: BoxDecoration(
            color: isSelected ? activeBg : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? activeColor : const Color(0xFFE2E8F0),
              width: isSelected ? 1.6 : 1.1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isTrueOption
                    ? Icons.check_circle_rounded
                    : Icons.cancel_rounded,
                size: 18,
                color: isSelected ? activeColor : const Color(0xFF94A3B8),
              ),
              const SizedBox(width: 6),
              Text(
                '$label ($sublabel)',
                style: GoogleFonts.poppins(
                  fontSize: 12.5,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: isSelected ? activeText : const Color(0xFF475569),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

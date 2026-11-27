import 'package:belajar_bhsinggris/Halaman_siswa/quiz/isi_quiz/sections/isi_quiz_navigation_palette_section.dart';
import 'package:belajar_bhsinggris/Halaman_siswa/quiz/isi_quiz/sections/isi_quiz_true_false_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('IsiQuizTrueFalseSection renders statements and updates selection counts',
      (WidgetTester tester) async {
    const statements = [
      QuizStatementItem(no: 1, teks: 'The sun rises in the east.'),
      QuizStatementItem(no: 2, teks: 'Water freezes at 100 degrees Celsius.'),
    ];
    final selected = <int, String>{};

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: IsiQuizTrueFalseSection(
                  statements: statements,
                  selectedAnswers: selected,
                  onSelectAnswer: (no, val) {
                    setState(() => selected[no] = val);
                  },
                ),
              );
            },
          ),
        ),
      ),
    );

    expect(find.text('The sun rises in the east.'), findsOneWidget);
    expect(find.text('Water freezes at 100 degrees Celsius.'), findsOneWidget);
    expect(find.text('0/2'), findsOneWidget);

    await tester.tap(find.text('True (Benar)').first);
    await tester.pumpAndSettle();
    expect(selected[1], 'true');
    expect(find.text('1/2'), findsOneWidget);

    await tester.tap(find.text('False (Salah)').last);
    await tester.pumpAndSettle();
    expect(selected[2], 'false');
    expect(find.text('2/2'), findsOneWidget);
  });

  testWidgets('IsiQuizNavigationPaletteSection uses answeredIndices when provided',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: IsiQuizNavigationPaletteSection(
            totalQuestions: 3,
            currentIndex: 1,
            answers: const {},
            answeredIndices: const {0},
            onSelectQuestion: (_) {},
          ),
        ),
      ),
    );

    // Question 0 is completed (check icon), Q1 and Q2 show numbers 2 and 3
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
  });
}

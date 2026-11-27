import 'package:belajar_bhsinggris/Halaman_siswa/materi/isi_materi/sections/isi_materi_step4_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final sampleSoals = [
    {
      'id': 1,
      'tipe_soal': 'pilgan',
      'pertanyaan': 'Question 1 text?',
      'pilihan': {'A': 'Opt A1', 'B': 'Opt B1', 'C': 'Opt C1', 'D': 'Opt D1'},
      'kunci_jawaban': 'B',
      'pembahasan': 'Because B1.',
    },
    {
      'id': 2,
      'tipe_soal': 'pilgan',
      'pertanyaan': 'Question 2 text?',
      'pilihan': {'A': 'Opt A2', 'B': 'Opt B2', 'C': 'Opt C2', 'D': 'Opt D2'},
      'kunci_jawaban': 'A',
      'pembahasan': 'Because A2.',
    },
  ];

  testWidgets('student can proceed to next question and finish without viewing answer',
      (WidgetTester tester) async {
    Map<String, String>? submittedAnswers;
    int? submittedBenar;
    int? submittedTotal;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: IsiMateriStep4Section(
              soals: sampleSoals,
              xpReward: 50,
              onSelesai: (jawaban, benar, total) {
                submittedAnswers = jawaban;
                submittedBenar = benar;
                submittedTotal = total;
              },
            ),
          ),
        ),
      ),
    );

    // Optional button is shown, and Next button is immediately available without checking answer
    expect(find.text('Lihat Jawaban Benar (Opsional)'), findsOneWidget);
    expect(find.text('Lanjut ke Soal Berikutnya →'), findsOneWidget);
    expect(find.text('Question 1 text?'), findsOneWidget);

    // Select option B on Q1 WITHOUT clicking "Lihat Jawaban Benar"
    await tester.tap(find.text('Opt B1'));
    await tester.pump();

    // Pembahasan must NOT be shown since student chose not to view answer
    expect(find.text('Pembahasan:'), findsNothing);

    // Tap Next directly without viewing answer
    await tester.tap(find.text('Lanjut ke Soal Berikutnya →'));
    await tester.pumpAndSettle();

    // Now on Question 2
    expect(find.text('Question 2 text?'), findsOneWidget);
    expect(find.text('Selesai & Lihat Nilai ✓'), findsOneWidget);

    // Select option A on Q2 and finish without viewing answer
    await tester.tap(find.text('Opt A2'));
    await tester.pump();

    await tester.tap(find.text('Selesai & Lihat Nilai ✓'));
    await tester.pump();

    expect(submittedTotal, 2);
    expect(submittedBenar, 2);
    expect(submittedAnswers, {'1': 'B', '2': 'A'});
  });

  testWidgets('optional check answer button reveals explanation when clicked',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: IsiMateriStep4Section(
              soals: sampleSoals,
              xpReward: 50,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Opt B1'));
    await tester.pump();

    await tester.tap(find.text('Lihat Jawaban Benar (Opsional)'));
    await tester.pumpAndSettle();

    expect(find.text('Pembahasan:'), findsOneWidget);
    expect(find.text('Because B1.'), findsOneWidget);
    expect(find.text('Lanjut ke Soal Berikutnya →'), findsOneWidget);
  });
}

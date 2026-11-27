import 'package:belajar_bhsinggris/Halaman_siswa/materi/sections/materi_list_section.dart';
import 'package:belajar_bhsinggris/Halaman_siswa/quiz/sections/quiz_list_section.dart';
import 'package:belajar_bhsinggris/widgets/modul_status_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('StatusFilterTabs switches between Semua, Belum Selesai, and Selesai',
      (WidgetTester tester) async {
    ModulStatusFilter selected = ModulStatusFilter.semua;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return StatusFilterTabs(
                selected: selected,
                totalCount: 3,
                pendingCount: 2,
                completedCount: 1,
                onChanged: (val) => setState(() => selected = val),
              );
            },
          ),
        ),
      ),
    );

    expect(find.text('Semua'), findsOneWidget);
    expect(find.text('Belum Selesai'), findsOneWidget);
    expect(find.text('Selesai'), findsOneWidget);

    await tester.tap(find.text('Belum Selesai'));
    await tester.pumpAndSettle();
    expect(selected, ModulStatusFilter.belumSelesai);

    await tester.tap(find.text('Selesai'));
    await tester.pumpAndSettle();
    expect(selected, ModulStatusFilter.selesai);
  });

  testWidgets('MateriListSection shows BARU + upload time when uncompleted and hides BARU when completed',
      (WidgetTester tester) async {
    final items = [
      MateriItemData.fromJson({
        'id': 1,
        'judul': 'Materi Baru Belum Dikerjakan',
        'kategori': 'Grammar',
        'deskripsi_singkat': 'Deskripsi singkat 1',
        'xp_reward': 50,
        'jumlah_soal': 5,
        'is_completed': false,
        'created_at': '27 Nov 2026 • 09:15',
        'is_baru': true,
      }),
      MateriItemData.fromJson({
        'id': 2,
        'judul': 'Materi Baru Sudah Selesai',
        'kategori': 'Reading',
        'deskripsi_singkat': 'Deskripsi singkat 2',
        'xp_reward': 50,
        'jumlah_soal': 5,
        'is_completed': true,
        'created_at': '27 Nov 2026 • 08:00',
        'is_baru': true,
      }),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: MateriListSection(items: items),
          ),
        ),
      ),
    );

    expect(find.text('BARU'), findsOneWidget);
    expect(find.text('Selesai'), findsOneWidget);
    expect(find.text('27 Nov 2026 • 09:15 WIB'), findsOneWidget);
    expect(find.text('27 Nov 2026 • 08:00 WIB'), findsOneWidget);
  });

  testWidgets('QuizListSection displays BARU only when uncompleted and shows upload time',
      (WidgetTester tester) async {
    const quizzes = [
      QuizItemData(
        id: '1',
        title: 'Quiz Baru',
        category: 'Grammar',
        durasiMenit: 15,
        jumlahSoal: 10,
        xp: 60,
        isCompleted: false,
        createdAt: '27 Nov 2026 • 09:20',
        isBaru: true,
      ),
      QuizItemData(
        id: '2',
        title: 'Quiz Selesai',
        category: 'Reading',
        durasiMenit: 10,
        jumlahSoal: 5,
        xp: 40,
        isCompleted: true,
        skorTerakhir: 90,
        createdAt: '26 Nov 2026 • 14:00',
        isBaru: false,
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: QuizListSection(items: quizzes),
          ),
        ),
      ),
    );

    expect(find.text('BARU'), findsOneWidget);
    expect(find.text('Nilai: 90'), findsOneWidget);
    expect(find.text('27 Nov 2026 • 09:20 WIB'), findsOneWidget);
    expect(find.text('26 Nov 2026 • 14:00 WIB'), findsOneWidget);
  });
}

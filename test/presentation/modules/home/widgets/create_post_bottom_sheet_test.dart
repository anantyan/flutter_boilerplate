import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/domain/entities/post_item.dart';
import 'package:flutter_boilerplate/presentation/modules/home/widgets/create_post_bottom_sheet.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildWidget(
    void Function({
      required String title,
      required String body,
      required PostStatus status,
    })
    onSubmit,
  ) {
    return MaterialApp(
      home: Scaffold(body: CreatePostBottomSheet(onSubmit: onSubmit)),
    );
  }

  group('CreatePostBottomSheet Tests', () {
    testWidgets('shows validation errors when submitting empty form', (
      tester,
    ) async {
      var submitted = false;

      await tester.pumpWidget(
        buildWidget(({required title, required body, required status}) {
          submitted = true;
        }),
      );

      await tester.tap(find.text('Simpan Item Baru'));
      await tester.pump();

      expect(find.text('Judul tidak boleh kosong'), findsOneWidget);
      expect(find.text('Deskripsi tidak boleh kosong'), findsOneWidget);
      expect(submitted, isFalse);
    });

    testWidgets('submits form with valid data and selected status', (
      tester,
    ) async {
      String? submittedTitle;
      String? submittedBody;
      PostStatus? submittedStatus;

      await tester.pumpWidget(
        buildWidget(({required title, required body, required status}) {
          submittedTitle = title;
          submittedBody = body;
          submittedStatus = status;
        }),
      );

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Judul Item'),
        'Refactor Codebase',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Deskripsi / Detail'),
        'Clean up duplicate dependencies',
      );

      // Tap Pending status choice chip
      await tester.tap(find.widgetWithText(ChoiceChip, 'Pending'));
      await tester.pump();

      await tester.tap(find.text('Simpan Item Baru'));
      await tester.pump();

      expect(submittedTitle, 'Refactor Codebase');
      expect(submittedBody, 'Clean up duplicate dependencies');
      expect(submittedStatus, PostStatus.pending);
    });

    testWidgets(
      'renders SafeArea and SingleChildScrollView for responsive layout',
      (tester) async {
        await tester.pumpWidget(
          buildWidget(({required title, required body, required status}) {}),
        );

        expect(find.byType(SafeArea), findsOneWidget);
        expect(find.byType(SingleChildScrollView), findsOneWidget);
      },
    );
  });
}

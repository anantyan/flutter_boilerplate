import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/domain/entities/post_item.dart';
import 'package:flutter_boilerplate/presentation/modules/home/widgets/post_item_card.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildWidget(PostItem post) {
    return MaterialApp(
      home: Scaffold(body: PostItemCard(post: post)),
    );
  }

  group('PostItemCard Tests', () {
    testWidgets('renders post content correctly with active status', (
      tester,
    ) async {
      final post = PostItem(
        id: 'card-1',
        title: 'Complete Phase 5',
        body: 'Implement presentation widgets and gestures',
        status: PostStatus.active,
        createdAt: DateTime(2026, 3, 10, 14, 30),
      );

      await tester.pumpWidget(buildWidget(post));

      expect(find.text('Complete Phase 5'), findsOneWidget);
      expect(
        find.text('Implement presentation widgets and gestures'),
        findsOneWidget,
      );
      expect(find.text('Active'), findsOneWidget);
      expect(find.text('10 Mar 2026, 14:30'), findsOneWidget);
    });

    testWidgets('renders status label correctly for pending and completed', (
      tester,
    ) async {
      final pendingPost = PostItem(
        id: 'card-2',
        title: 'Pending Task',
        body: 'Pending body',
        status: PostStatus.pending,
        createdAt: DateTime(2026, 3, 10, 15, 0),
      );

      await tester.pumpWidget(buildWidget(pendingPost));
      expect(find.text('Pending'), findsOneWidget);

      final completedPost = PostItem(
        id: 'card-3',
        title: 'Completed Task',
        body: 'Completed body',
        status: PostStatus.completed,
        createdAt: DateTime(2026, 3, 10, 16, 0),
      );

      await tester.pumpWidget(buildWidget(completedPost));
      expect(find.text('Completed'), findsOneWidget);
    });
  });
}

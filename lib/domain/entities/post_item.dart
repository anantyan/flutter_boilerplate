import 'package:equatable/equatable.dart';

enum PostStatus { active, pending, completed }

/// Pure domain entity representing a Post or Item.
class PostItem extends Equatable {
  final String id;
  final String title;
  final String body;
  final PostStatus status;
  final DateTime createdAt;

  const PostItem({
    required this.id,
    required this.title,
    required this.body,
    required this.status,
    required this.createdAt,
  });

  PostItem copyWith({
    String? id,
    String? title,
    String? body,
    PostStatus? status,
    DateTime? createdAt,
  }) {
    return PostItem(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, title, body, status, createdAt];
}

import '../../domain/entities/post_item.dart';

/// Data Transfer Object (DTO) for [PostItem].
class PostModel {
  final String id;
  final String title;
  final String body;
  final String status;
  final String createdAt;

  const PostModel({
    required this.id,
    required this.title,
    required this.body,
    required this.status,
    required this.createdAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      status: json['status'] as String? ?? 'active',
      createdAt: json['createdAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'status': status,
      'createdAt': createdAt,
    };
  }

  PostItem toEntity() {
    final parsedStatus = switch (status.toLowerCase()) {
      'completed' => PostStatus.completed,
      'pending' => PostStatus.pending,
      _ => PostStatus.active,
    };

    return PostItem(
      id: id,
      title: title,
      body: body,
      status: parsedStatus,
      createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
    );
  }

  factory PostModel.fromEntity(PostItem entity) {
    return PostModel(
      id: entity.id,
      title: entity.title,
      body: entity.body,
      status: entity.status.name,
      createdAt: entity.createdAt.toIso8601String(),
    );
  }
}

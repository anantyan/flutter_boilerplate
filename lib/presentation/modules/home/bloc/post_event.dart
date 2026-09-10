import 'package:equatable/equatable.dart';
import '../../../../domain/entities/post_item.dart';

sealed class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object?> get props => [];
}

final class LoadPostsEvent extends PostEvent {
  const LoadPostsEvent();
}

final class AddPostEvent extends PostEvent {
  final String title;
  final String body;
  final PostStatus status;

  const AddPostEvent({
    required this.title,
    required this.body,
    required this.status,
  });

  @override
  List<Object?> get props => [title, body, status];
}

final class RemovePostEvent extends PostEvent {
  final String id;

  const RemovePostEvent(this.id);

  @override
  List<Object?> get props => [id];
}

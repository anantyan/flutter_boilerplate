import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../models/post_model.dart';

abstract class PostRemoteDataSource {
  Future<List<PostModel>> getPosts();
  Future<PostModel> createPost(PostModel model);
  Future<void> deletePost(String id);
}

@LazySingleton(as: PostRemoteDataSource)
class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final Dio dio;

  // Initial seed data demonstrating real REST simulation
  final List<PostModel> _inMemoryStore = [
    PostModel(
      id: 'item-1',
      title: 'Setup Architecture Baseline',
      body:
          'Clean Architecture with Domain, Data, Presentation, and Core layers.',
      status: 'completed',
      createdAt: DateTime.now()
          .subtract(const Duration(hours: 3))
          .toIso8601String(),
    ),
    PostModel(
      id: 'item-2',
      title: 'Implement BLoC State Flow',
      body:
          'Predictable state management with event streaming and Equatable states.',
      status: 'active',
      createdAt: DateTime.now()
          .subtract(const Duration(hours: 1))
          .toIso8601String(),
    ),
    PostModel(
      id: 'item-3',
      title: 'Dependency Injection Setup',
      body:
          'GetIt service locator wired with Injectable compile-time code generator.',
      status: 'pending',
      createdAt: DateTime.now()
          .subtract(const Duration(minutes: 30))
          .toIso8601String(),
    ),
  ];

  PostRemoteDataSourceImpl(this.dio);

  @override
  Future<List<PostModel>> getPosts() async {
    // Simulating remote network latency
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_inMemoryStore);
  }

  @override
  Future<PostModel> createPost(PostModel model) async {
    await Future.delayed(const Duration(milliseconds: 250));
    _inMemoryStore.insert(0, model);
    return model;
  }

  @override
  Future<void> deletePost(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _inMemoryStore.removeWhere((item) => item.id == id);
  }
}

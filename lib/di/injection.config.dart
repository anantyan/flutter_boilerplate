// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../common/storage/secure_storage_service.dart' as _i377;
import '../data/datasources/remote/post_remote_datasource.dart' as _i1035;
import '../data/repositories/post_repository_impl.dart' as _i36;
import '../domain/repositories/post_repository.dart' as _i984;
import '../domain/usecases/create_post_usecase.dart' as _i729;
import '../domain/usecases/delete_post_usecase.dart' as _i734;
import '../domain/usecases/get_posts_usecase.dart' as _i416;
import '../presentation/theme/theme_bloc.dart' as _i755;
import 'modules/register_module.dart' as _i911;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => registerModule.secureStorage,
    );
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i377.ISecureStorageService>(
      () => _i377.SecureStorageService(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i755.ThemeBloc>(
      () => _i755.ThemeBloc(gh<_i377.ISecureStorageService>()),
    );
    gh.lazySingleton<_i1035.PostRemoteDataSource>(
      () => _i1035.PostRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i984.PostRepository>(
      () => _i36.PostRepositoryImpl(gh<_i1035.PostRemoteDataSource>()),
    );
    gh.factory<_i729.CreatePostUseCase>(
      () => _i729.CreatePostUseCase(gh<_i984.PostRepository>()),
    );
    gh.factory<_i734.DeletePostUseCase>(
      () => _i734.DeletePostUseCase(gh<_i984.PostRepository>()),
    );
    gh.factory<_i416.GetPostsUseCase>(
      () => _i416.GetPostsUseCase(gh<_i984.PostRepository>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i911.RegisterModule {}

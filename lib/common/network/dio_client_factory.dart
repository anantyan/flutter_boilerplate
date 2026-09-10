import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'error_handling_interceptor.dart';

/// Factory creating pre-configured [Dio] HTTP client instances.
class DioClientFactory {
  static const Duration defaultTimeout = Duration(seconds: 15);

  static Dio create({
    String baseUrl = '',
    List<Interceptor> additionalInterceptors = const [],
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: defaultTimeout,
        receiveTimeout: defaultTimeout,
        sendTimeout: defaultTimeout,
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Error handling interceptor must be added first to normalize errors
    dio.interceptors.add(ErrorHandlingInterceptor());

    // Additional custom interceptors (e.g. Auth token, caching)
    dio.interceptors.addAll(additionalInterceptors);

    // Logging in debug mode
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
        ),
      );
    }

    return dio;
  }
}

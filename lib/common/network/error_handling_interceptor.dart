import 'package:dio/dio.dart';
import '../errors/exceptions.dart';

/// Interceptor that translates raw [DioException] into strongly typed [NetworkException] subclasses.
class ErrorHandlingInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err is NetworkException || err is NoNetworkException) {
      return handler.next(err);
    }

    final statusCode = err.response?.statusCode;
    final message =
        _extractMessage(err.response?.data) ??
        err.message ??
        'A network error occurred (${err.type.name}).';

    if (err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      return handler.next(
        NoNetworkException(requestOptions: err.requestOptions),
      );
    }

    if (statusCode != null) {
      final networkException = switch (statusCode) {
        400 => BadRequestException(
          requestOptions: err.requestOptions,
          message: message,
          response: err.response,
        ),
        401 => UnauthorizedException(
          requestOptions: err.requestOptions,
          message: message,
          response: err.response,
        ),
        403 => ForbiddenException(
          requestOptions: err.requestOptions,
          message: message,
          response: err.response,
        ),
        404 => NotFoundException(
          requestOptions: err.requestOptions,
          message: message,
          response: err.response,
        ),
        409 => ConflictException(
          requestOptions: err.requestOptions,
          message: message,
          response: err.response,
        ),
        422 => UnprocessableEntityException(
          requestOptions: err.requestOptions,
          message: message,
          response: err.response,
        ),
        429 => TooManyRequestsException(
          requestOptions: err.requestOptions,
          message: message,
          response: err.response,
        ),
        >= 500 && < 600 => InternalServerException(
          requestOptions: err.requestOptions,
          message: message,
          response: err.response,
        ),
        _ => UnknownServerException(
          requestOptions: err.requestOptions,
          message: message,
          response: err.response,
        ),
      };
      return handler.next(networkException);
    }

    return handler.next(err);
  }

  String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data.containsKey('message') && data['message'] is String) {
        return data['message'] as String;
      }
      if (data.containsKey('error') && data['error'] is String) {
        return data['error'] as String;
      }
    }
    return null;
  }
}

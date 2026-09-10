import 'package:dio/dio.dart';

/// Base sealed class for typed network exceptions mapped from [DioException].
sealed class NetworkException extends DioException {
  NetworkException({
    required super.requestOptions,
    required String message,
    super.response,
  }) : super(type: DioExceptionType.badResponse, message: message);

  @override
  String toString() => '$runtimeType: $message';
}

class BadRequestException extends NetworkException {
  BadRequestException({
    required super.requestOptions,
    required super.message,
    super.response,
  });
}

class UnauthorizedException extends NetworkException {
  UnauthorizedException({
    required super.requestOptions,
    required super.message,
    super.response,
  });
}

class ForbiddenException extends NetworkException {
  ForbiddenException({
    required super.requestOptions,
    required super.message,
    super.response,
  });
}

class NotFoundException extends NetworkException {
  NotFoundException({
    required super.requestOptions,
    required super.message,
    super.response,
  });
}

class ConflictException extends NetworkException {
  ConflictException({
    required super.requestOptions,
    required super.message,
    super.response,
  });
}

class UnprocessableEntityException extends NetworkException {
  UnprocessableEntityException({
    required super.requestOptions,
    required super.message,
    super.response,
  });
}

class TooManyRequestsException extends NetworkException {
  TooManyRequestsException({
    required super.requestOptions,
    required super.message,
    super.response,
  });
}

class InternalServerException extends NetworkException {
  InternalServerException({
    required super.requestOptions,
    required super.message,
    super.response,
  });
}

class UnknownServerException extends NetworkException {
  UnknownServerException({
    required super.requestOptions,
    required super.message,
    super.response,
  });
}

class NoNetworkException extends DioException {
  NoNetworkException({required super.requestOptions})
    : super(
        type: DioExceptionType.connectionError,
        message: 'No internet connection available.',
      );

  @override
  String toString() => 'NoNetworkException: $message';
}

/// Thrown when an error occurs during reading/writing to local storage.
class CacheException implements Exception {
  final String message;

  const CacheException([this.message = 'Cache exception occurred']);

  @override
  String toString() => 'CacheException: $message';
}

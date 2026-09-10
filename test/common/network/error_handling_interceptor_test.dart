import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/common/errors/exceptions.dart';
import 'package:flutter_boilerplate/common/network/error_handling_interceptor.dart';
import 'package:flutter_test/flutter_test.dart';

class TestErrorInterceptorHandler extends ErrorInterceptorHandler {
  DioException? capturedException;

  @override
  void next(DioException err) {
    capturedException = err;
  }
}

void main() {
  late ErrorHandlingInterceptor interceptor;

  setUp(() {
    interceptor = ErrorHandlingInterceptor();
  });

  group('ErrorHandlingInterceptor', () {
    final requestOptions = RequestOptions(path: '/test');

    test('maps 400 to BadRequestException with response message', () {
      final handler = TestErrorInterceptorHandler();

      interceptor.onError(
        DioException(
          requestOptions: requestOptions,
          response: Response(
            requestOptions: requestOptions,
            statusCode: 400,
            data: {'message': 'Bad request parameter'},
          ),
          type: DioExceptionType.badResponse,
        ),
        handler,
      );

      expect(handler.capturedException, isA<BadRequestException>());
      expect(
        handler.capturedException?.message,
        equals('Bad request parameter'),
      );
    });

    test('maps 401 to UnauthorizedException', () {
      final handler = TestErrorInterceptorHandler();

      interceptor.onError(
        DioException(
          requestOptions: requestOptions,
          response: Response(
            requestOptions: requestOptions,
            statusCode: 401,
            data: {'message': 'Token expired'},
          ),
          type: DioExceptionType.badResponse,
        ),
        handler,
      );

      expect(handler.capturedException, isA<UnauthorizedException>());
      expect(handler.capturedException?.message, equals('Token expired'));
    });

    test('maps 404 to NotFoundException', () {
      final handler = TestErrorInterceptorHandler();

      interceptor.onError(
        DioException(
          requestOptions: requestOptions,
          response: Response(
            requestOptions: requestOptions,
            statusCode: 404,
            data: {'error': 'Resource not found'},
          ),
          type: DioExceptionType.badResponse,
        ),
        handler,
      );

      expect(handler.capturedException, isA<NotFoundException>());
      expect(handler.capturedException?.message, equals('Resource not found'));
    });

    test('maps 500 to InternalServerException', () {
      final handler = TestErrorInterceptorHandler();

      interceptor.onError(
        DioException(
          requestOptions: requestOptions,
          response: Response(requestOptions: requestOptions, statusCode: 500),
          type: DioExceptionType.badResponse,
        ),
        handler,
      );

      expect(handler.capturedException, isA<InternalServerException>());
    });

    test('maps connectionError to NoNetworkException', () {
      final handler = TestErrorInterceptorHandler();

      interceptor.onError(
        DioException(
          requestOptions: requestOptions,
          type: DioExceptionType.connectionError,
        ),
        handler,
      );

      expect(handler.capturedException, isA<NoNetworkException>());
    });
  });
}

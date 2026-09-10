import 'package:flutter_boilerplate/common/errors/failures.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Failure Equality & Props', () {
    test('ServerFailure instances with same props are equal', () {
      const f1 = ServerFailure(message: 'Error', statusCode: 500);
      const f2 = ServerFailure(message: 'Error', statusCode: 500);
      expect(f1, equals(f2));
    });

    test('NetworkFailure has expected default message', () {
      const failure = NetworkFailure();
      expect(failure.message, contains('koneksi internet'));
    });

    test('CacheFailure has expected default message', () {
      const failure = CacheFailure();
      expect(failure.message, contains('penyimpanan lokal'));
    });
  });
}

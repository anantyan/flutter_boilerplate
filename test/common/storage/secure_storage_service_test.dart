import 'package:flutter_boilerplate/common/storage/secure_storage_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockFlutterSecureStorage mockStorage;
  late SecureStorageService service;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    service = SecureStorageService(mockStorage);
  });

  group('SecureStorageService', () {
    const testKey = 'test_key';
    const testValue = 'test_value';

    test('write calls storage.write with matching key and value', () async {
      when(
        () => mockStorage.write(key: testKey, value: testValue),
      ).thenAnswer((_) async {});

      await service.write(key: testKey, value: testValue);

      verify(() => mockStorage.write(key: testKey, value: testValue)).called(1);
    });

    test('read returns value from storage', () async {
      when(
        () => mockStorage.read(key: testKey),
      ).thenAnswer((_) async => testValue);

      final result = await service.read(key: testKey);

      expect(result, equals(testValue));
      verify(() => mockStorage.read(key: testKey)).called(1);
    });

    test('delete calls storage.delete with matching key', () async {
      when(() => mockStorage.delete(key: testKey)).thenAnswer((_) async {});

      await service.delete(key: testKey);

      verify(() => mockStorage.delete(key: testKey)).called(1);
    });

    test('clearAll calls storage.deleteAll', () async {
      when(() => mockStorage.deleteAll()).thenAnswer((_) async {});

      await service.clearAll();

      verify(() => mockStorage.deleteAll()).called(1);
    });
  });
}

import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mockito/mockito.dart';
import '../../../lib/data/datasources/auth_local_data_source.dart';
import '../../../lib/data/models/user_model.dart';
import '../../../lib/utils/constants.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late AuthLocalDataSourceImpl dataSource;
  late MockFlutterSecureStorage mockStorage;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    dataSource = AuthLocalDataSourceImpl(storage: mockStorage);
  });

  group('cacheUser', () {
    final tUserModel = UserModel(
      id: '1',
      name: 'Test User',
      email: 'test@example.com',
      token: 'test-token',
    );

    test('should cache the user model', () async {
      when(mockStorage.write(
        key: anyNamed('key'),
        value: anyNamed('value'),
      )).thenAnswer((_) async => null);

      await dataSource.cacheUser(tUserModel);

      verify(mockStorage.write(
        key: ApiConstants.userKey,
        value: json.encode(tUserModel.toJson()),
      ));
    });
  });

  group('getLastUser', () {
    test('should return UserModel when there is one in the cache', () async {
      final tUserJson = {
        'id': '1',
        'name': 'Test User',
        'email': 'test@example.com',
        'token': 'test-token',
      };

      when(mockStorage.read(key: ApiConstants.userKey))
          .thenAnswer((_) async => json.encode(tUserJson));

      final result = await dataSource.getLastUser();

      expect(result, isA<UserModel>());
      expect(result?.email, equals('test@example.com'));
    });

    test('should return null when there is no cached value', () async {
      when(mockStorage.read(key: ApiConstants.userKey))
          .thenAnswer((_) async => null);

      final result = await dataSource.getLastUser();

      expect(result, isNull);
    });
  });

  group('clearUserData', () {
    test('should remove all user data from cache', () async {
      when(mockStorage.delete(key: anyNamed('key')))
          .thenAnswer((_) async => null);

      await dataSource.clearUserData();

      verify(mockStorage.delete(key: ApiConstants.tokenKey)).called(1);
      verify(mockStorage.delete(key: ApiConstants.userKey)).called(1);
    });
  });
}

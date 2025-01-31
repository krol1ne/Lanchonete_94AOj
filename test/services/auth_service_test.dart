import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lanchonete/services/auth_service.dart';
import 'package:lanchonete/models/user.dart';

import '../mocks/mock_http_client.mocks.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

@GenerateMocks([http.Client])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AuthService authService;
  late MockClient mockHttpClient;
  late MockFlutterSecureStorage mockStorage;

  setUp(() {
    mockHttpClient = MockClient();
    mockStorage = MockFlutterSecureStorage();
    authService = AuthService(client: mockHttpClient, storage: mockStorage);
  });

  group('AuthService', () {
    test('login success returns user', () async {
      final email = 'test@example.com';
      final password = 'password123';
      final responseData = {
        'email': email,
        'name': 'Test User',
        'token': 'test-token',
      };

      when(mockHttpClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer(
        (_) async => http.Response(json.encode(responseData), 200),
      );

      when(mockStorage.write(
        key: anyNamed('key'),
        value: anyNamed('value'),
      )).thenAnswer((_) async => null);

      final user = await authService.login(
        email: email,
        password: password,
      );

      expect(user.email, equals(email));
      expect(user.name, equals('Test User'));
      expect(user.token, equals('test-token'));

      verify(mockStorage.write(
        key: 'token',
        value: 'test-token',
      )).called(1);
    });

    test('login failure throws exception', () async {
      when(mockHttpClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer(
        (_) async => http.Response('Invalid credentials', 401),
      );

      expect(
        () => authService.login(
          email: 'test@example.com',
          password: 'wrong-password',
        ),
        throwsException,
      );
    });

    test('logout clears storage', () async {
      when(mockStorage.delete(key: anyNamed('key')))
          .thenAnswer((_) async => null);

      await authService.logout();

      verify(mockStorage.delete(key: 'token')).called(1);
    });
  });
}

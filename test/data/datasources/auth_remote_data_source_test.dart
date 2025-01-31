import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import '../../../lib/data/datasources/auth_remote_data_source.dart';
import '../../../lib/domain/exceptions/auth_exception.dart';
import '../../../lib/utils/constants.dart';

@GenerateMocks([http.Client])
void main() {
  late AuthRemoteDataSourceImpl dataSource;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = AuthRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('login', () {
    final tEmail = 'test@example.com';
    final tPassword = 'password123';
    final tResponseData = {
      'id': '1',
      'email': tEmail,
      'name': 'Test User',
      'token': 'test-token',
    };

    test('should return UserModel when the response is 200', () async {
      when(mockHttpClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(json.encode(tResponseData), 200));

      final result = await dataSource.login(tEmail, tPassword);

      expect(result.email, equals(tEmail));
      expect(result.token, equals('test-token'));

      verify(mockHttpClient.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.loginEndpoint}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'login': tEmail,
          'password': tPassword,
        }),
      ));
    });

    test('should throw InvalidCredentialsException when the response is 401',
        () async {
      when(mockHttpClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('Invalid credentials', 401));

      final call = dataSource.login;

      expect(() => call(tEmail, tPassword),
          throwsA(isA<InvalidCredentialsException>()));
    });

    test('should throw ServerException when the response is not 200 or 401',
        () async {
      when(mockHttpClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('Server error', 500));

      final call = dataSource.login;

      expect(() => call(tEmail, tPassword), throwsA(isA<ServerException>()));
    });
  });
}

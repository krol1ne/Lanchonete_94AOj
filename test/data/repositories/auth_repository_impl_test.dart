import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../lib/data/models/user_model.dart';
import '../../../lib/data/repositories/auth_repository_impl.dart';
import '../../../lib/domain/exceptions/auth_exception.dart';
import '../../mocks/mock_auth_data_sources.dart';

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockAuthLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockLocalDataSource = MockAuthLocalDataSource();
    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  group('login', () {
    final tEmail = 'test@example.com';
    final tPassword = 'password123';
    final tUserModel = UserModel(
      id: '1',
      name: 'Test User',
      email: tEmail,
      token: 'test-token',
    );

    test('should return user when login is successful', () async {
      when(mockRemoteDataSource.login(any, any))
          .thenAnswer((_) async => tUserModel);
      when(mockLocalDataSource.cacheToken(any)).thenAnswer((_) async => null);
      when(mockLocalDataSource.cacheUser(any)).thenAnswer((_) async => null);

      final result = await repository.login(tEmail, tPassword);

      expect(result, equals(tUserModel));
      verify(mockLocalDataSource.cacheToken(tUserModel.token));
      verify(mockLocalDataSource.cacheUser(tUserModel));
    });

    test('should throw exception when remote data source fails', () async {
      when(mockRemoteDataSource.login(any, any))
          .thenThrow(InvalidCredentialsException());

      final call = repository.login;

      expect(() => call(tEmail, tPassword),
          throwsA(isA<InvalidCredentialsException>()));
    });
  });

  group('getCurrentUser', () {
    final tUserModel = UserModel(
      id: '1',
      name: 'Test User',
      email: 'test@example.com',
      token: 'test-token',
    );

    test('should return user when there is cached data', () async {
      when(mockLocalDataSource.getLastUser())
          .thenAnswer((_) async => tUserModel);

      final result = await repository.getCurrentUser();

      expect(result, equals(tUserModel));
      verify(mockLocalDataSource.getLastUser());
    });

    test('should return null when there is no cached data', () async {
      when(mockLocalDataSource.getLastUser()).thenAnswer((_) async => null);

      final result = await repository.getCurrentUser();

      expect(result, isNull);
      verify(mockLocalDataSource.getLastUser());
    });
  });

  group('logout', () {
    test('should clear all user data', () async {
      when(mockLocalDataSource.clearUserData()).thenAnswer((_) async => null);

      await repository.logout();

      verify(mockLocalDataSource.clearUserData());
    });
  });
}

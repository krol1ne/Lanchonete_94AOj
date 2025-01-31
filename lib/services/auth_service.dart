import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../data/datasources/auth_local_data_source.dart';
import '../data/datasources/auth_remote_data_source.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/entities/user.dart';
import '../domain/repositories/auth_repository.dart';

class AuthService {
  late final AuthRepository _repository;

  AuthService({
    http.Client? client,
    FlutterSecureStorage? storage,
  }) {
    final remoteDataSource = AuthRemoteDataSourceImpl(client: client);
    final localDataSource = AuthLocalDataSourceImpl(storage: storage);
    _repository = AuthRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );
  }

  Future<User> login({
    required String email,
    required String password,
  }) async {
    return await _repository.login(email, password);
  }

  Future<void> logout() async {
    await _repository.logout();
  }

  Future<String?> getToken() async {
    return await _repository.getToken();
  }

  Future<User?> getCurrentUser() async {
    return await _repository.getCurrentUser();
  }
}

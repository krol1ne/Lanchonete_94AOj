import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<User> login(String email, String password) async {
    final userModel = await remoteDataSource.login(email, password);
    await localDataSource.cacheToken(userModel.token);
    await localDataSource.cacheUser(userModel);
    return userModel;
  }

  @override
  Future<void> logout() async {
    await localDataSource.clearUserData();
  }

  @override
  Future<String?> getToken() async {
    return await localDataSource.getLastToken();
  }

  @override
  Future<User?> getCurrentUser() async {
    return await localDataSource.getLastUser();
  }
}

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../utils/constants.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<void> cacheToken(String token);
  Future<UserModel?> getLastUser();
  Future<String?> getLastToken();
  Future<void> clearUserData();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage storage;

  AuthLocalDataSourceImpl({FlutterSecureStorage? storage})
      : storage = storage ?? const FlutterSecureStorage();

  @override
  Future<void> cacheUser(UserModel user) async {
    await storage.write(
      key: ApiConstants.userKey,
      value: json.encode(user.toJson()),
    );
  }

  @override
  Future<void> cacheToken(String token) async {
    await storage.write(key: ApiConstants.tokenKey, value: token);
  }

  @override
  Future<UserModel?> getLastUser() async {
    final userJson = await storage.read(key: ApiConstants.userKey);
    if (userJson != null) {
      return UserModel.fromJson(json.decode(userJson));
    }
    return null;
  }

  @override
  Future<String?> getLastToken() async {
    return await storage.read(key: ApiConstants.tokenKey);
  }

  @override
  Future<void> clearUserData() async {
    await storage.delete(key: ApiConstants.tokenKey);
    await storage.delete(key: ApiConstants.userKey);
  }
}

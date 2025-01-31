import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../utils/constants.dart';
import '../models/user_model.dart';
import '../../domain/exceptions/auth_exception.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl({http.Client? client})
      : client = client ?? http.Client();

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.loginEndpoint}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'login': email,
          'password': password,
        }),
      );

      // Print response for debugging
      print('Login Response Status: ${response.statusCode}');
      print('Login Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse == null) {
          throw ServerException('Response body is null');
        }
        return UserModel.fromJson(jsonResponse);
      } else if (response.statusCode == 401) {
        final errorMessage = _parseErrorMessage(response.body);
        throw InvalidCredentialsException(errorMessage);
      } else {
        final errorMessage = _parseErrorMessage(response.body);
        throw ServerException(errorMessage);
      }
    } catch (e) {
      print('Login Error: $e');
      if (e is AuthException) rethrow;
      throw ServerException('Failed to connect to the server: $e');
    }
  }

  String _parseErrorMessage(String responseBody) {
    try {
      final jsonResponse = json.decode(responseBody);
      return jsonResponse['message'] ?? jsonResponse['error'] ?? responseBody;
    } catch (_) {
      return responseBody;
    }
  }
}

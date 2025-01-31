import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required String id,
    required String name,
    required String email,
    required String token,
  }) : super(
          id: id,
          name: name,
          email: email,
          token: token,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Handle potential variations in API response
    return UserModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      token: json['token']?.toString() ?? json['accessToken']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'token': token,
    };
  }
}

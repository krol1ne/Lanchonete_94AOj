class User {
  final String email;
  final String name;
  String? token;

  User({
    required this.email,
    required this.name,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      name: json['userName'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'UserName': name,
      'token': token,
    };
  }
}

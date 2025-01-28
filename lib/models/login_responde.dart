class LoginResponse {
  final String userName;
  final String email;
  final String token;

  LoginResponse({
    required this.userName,
    required this.email,
    required this.token,
  });

  // Criando a resposta a partir de um JSON
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      userName: json['userName'],
      email: json['email'],
      token: json['token'],
    );
  }

  // Convertendo o modelo para JSON (caso necessário)
  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'email': email,
      'token': token,
    };
  }
}

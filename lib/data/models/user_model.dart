class UserModel {
  final String email;
  final String token;
  final String? refreshToken;

  UserModel({
    required this.email,
    required this.token,
    this.refreshToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] ?? '',
      token: json['token'] ?? '',
      refreshToken: json['refreshToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'token': token,
      'refreshToken': refreshToken,
    };
  }
}

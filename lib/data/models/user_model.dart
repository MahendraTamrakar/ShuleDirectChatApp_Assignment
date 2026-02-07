class UserModel {
  final String email;
  final String token;

  UserModel({required this.email, required this.token});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Adjust based on actual API response structure
    // If API returns { "token": "...", "user": { "email": "..." } }
    return UserModel(email: json['email'] ?? '', token: json['token'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'email': email, 'token': token};
  }
}

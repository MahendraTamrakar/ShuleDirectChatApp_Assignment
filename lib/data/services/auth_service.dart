import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/user_model.dart';

class AuthService {
  final ApiClient _apiClient;

  AuthService(this._apiClient);

  Future<UserModel> login(String email, String password) async {
    final response = await _apiClient.post(
      ApiConstants.login,
      data: {'email': email, 'password': password},
    );

    final data = response.data;
    String? token = data['token'] ?? data['access_token'] ?? data['access'];

    if (token == null) {
      final authHeader = response.headers.value('authorization');
      if (authHeader != null && authHeader.startsWith('Bearer ')) {
        token = authHeader.substring(7);
      }
    }

    if (token == null || token.isEmpty) {
      throw Exception('Failed to extract token from response');
    }

    // Extract refresh token from headers
    String? refreshToken = response.headers.value('refresh-token');

    return UserModel(
      email: email,
      token: token,
      refreshToken: refreshToken,
    );
  }
}

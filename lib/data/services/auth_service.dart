// import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/user_model.dart';

class AuthService {
  final ApiClient _apiClient;

  AuthService(this._apiClient);

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );

      // Assuming response body contains token directly or inside a field
      // The prompt says "Extract JWT access token".
      // If response.data is just the map.
      // Adjust based on actual response.
      // Example: { "token": "..." } or similar
      final data = response.data;

      String? token;

      // 1. Check Headers (Primary method per logs)
      final authHeader =
          response.headers.value('authorization') ??
          response.headers.value('Authorization');

      if (authHeader != null && authHeader.isNotEmpty) {
        if (authHeader.startsWith('Bearer ')) {
          token = authHeader.substring(7);
        } else {
          token = authHeader;
        }
      }

      // 2. Check Body (Fallback)
      if (token == null) {
        token = data['token'];
        if (token == null) token = data['access'];
        if (token == null) token = data['access_token'];
        if (token == null && data['data'] is Map) {
          token = data['data']['token'] ?? data['data']['access_token'];
        }
      }

      if (token == null || token.isEmpty) {
        throw Exception(
          'Failed to extract token from response. Header: $authHeader, Body: $data',
        );
      }

      // Create user model (mocking email as it might not be in response)
      return UserModel(email: email, token: token);
    } catch (e) {
      rethrow;
    }
  }
}

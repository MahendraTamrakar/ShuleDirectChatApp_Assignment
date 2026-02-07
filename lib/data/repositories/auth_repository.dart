import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import '../../core/network/api_client.dart';

class AuthRepository {
  final AuthService _authService;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final ApiClient _apiClient;

  static const String _tokenKey = 'auth_token';
  static const String _userEmailKey = 'user_email';
  static const String _refreshTokenKey = 'refresh_token';

  AuthRepository(this._authService, this._apiClient);

  Future<void> login(String email, String password) async {
    try {
      final user = await _authService.login(email, password);
      await _saveUserSession(user);
      _apiClient.setToken(user.token);
      if (user.refreshToken != null) {
        _apiClient.setRefreshToken(user.refreshToken!);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _storage.deleteAll();
    _apiClient.clearToken();
  }

  Future<bool> checkAuthStatus() async {
    final token = await _storage.read(key: _tokenKey);
    final refreshToken = await _storage.read(key: _refreshTokenKey);
    if (token != null && token.isNotEmpty) {
      _apiClient.setToken(token);
      if (refreshToken != null) {
        _apiClient.setRefreshToken(refreshToken);
      }
      return true;
    }
    return false;
  }

  Future<String?> getUserEmail() async {
    return await _storage.read(key: _userEmailKey);
  }

  Future<void> _saveUserSession(UserModel user) async {
    await _storage.write(key: _tokenKey, value: user.token);
    await _storage.write(key: _userEmailKey, value: user.email);
    if (user.refreshToken != null) {
      await _storage.write(key: _refreshTokenKey, value: user.refreshToken!);
    }
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  Future<void> updateToken(String newToken) async {
    await _storage.write(key: _tokenKey, value: newToken);
    _apiClient.setToken(newToken);
  }
}

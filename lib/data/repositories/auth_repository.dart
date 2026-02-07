import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import '../../core/network/api_client.dart';

class AuthRepository {
  final AuthService _authService;
  final FlutterSecureStorage _storage;
  final ApiClient _apiClient;

  // Key for storing token
  static const String _tokenKey = 'auth_token';
  static const String _userEmailKey = 'user_email';

  AuthRepository(this._authService, this._apiClient)
    : _storage = const FlutterSecureStorage();

  Future<void> login(String email, String password) async {
    try {
      final user = await _authService.login(email, password);
      await _saveUserSession(user);
      _apiClient.setToken(user.token);
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
    if (token != null && token.isNotEmpty) {
      _apiClient.setToken(token);
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
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }
}

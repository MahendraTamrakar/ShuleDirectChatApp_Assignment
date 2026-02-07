import 'dart:developer';
import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

class ApiClient {
  late Dio _dio;
  // String? _authToken; // Removed unused field

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add logging interceptor
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => log('API Log: $obj'),
      ),
    );
  }

  void setToken(String token) {
    // _authToken = token;
    _dio.options.headers[ApiConstants.authHeader] =
        '${ApiConstants.bearer} $token';
  }

  void clearToken() {
    // _authToken = null;
    _dio.options.headers.remove(ApiConstants.authHeader);
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    if (e.response != null) {
      return Exception(
        'API Error: ${e.response?.statusCode} - ${e.response?.statusMessage}',
      );
    }
    return Exception('Network Error: ${e.message}');
  }
}

import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_constants.dart';

class ApiClient {
  late Dio _dio;
  Function(String)? _onUnauthorized;

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

    // Add logging interceptor for debugging
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (obj) => log('API Log: $obj'),
        ),
      );
    }

    // Add error interceptor for 401 handling
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException error, handler) {
          if (error.response?.statusCode == 401) {
            _onUnauthorized?.call('Unauthorized - Token expired');
          }
          return handler.next(error);
        },
      ),
    );
  }

  void setUnauthorizedCallback(Function(String) callback) {
    _onUnauthorized = callback;
  }

  void setToken(String token) {
    _dio.options.headers[ApiConstants.authHeader] =
        '${ApiConstants.bearer} $token';
  }

  void setRefreshToken(String refreshToken) {
    _dio.options.headers['X-Refresh-Token'] = refreshToken;
  }

  void clearToken() {
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

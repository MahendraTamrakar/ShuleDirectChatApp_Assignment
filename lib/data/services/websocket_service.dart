import 'dart:developer';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../core/constants/api_constants.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  final StreamController<dynamic> _streamController = StreamController<dynamic>.broadcast();
  String? _lastToken;
  int? _lastConversationId;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 3;

  Stream<dynamic> get messages => _streamController.stream;

  void connect(String token, int conversationId) async {
    if (_channel != null) {
      _channel!.sink.close();
    }

    _lastToken = token;
    _lastConversationId = conversationId;
    
    // Only reset attempts on initial connection, not on reconnects
    if (_reconnectAttempts == 0 || _lastToken != token) {
      _reconnectAttempts = 0;
    }

    // Parse the base WebSocket URL and construct the final URI
    final baseUri = Uri.parse(ApiConstants.wsUrl);
    final wsUri = Uri(
      scheme: 'wss',
      host: baseUri.host,
      port: baseUri.hasPort ? baseUri.port : 443,
      path: '${baseUri.path}/$conversationId/',
      queryParameters: {'token': token},
    );
    
    log('Connecting to WebSocket: $wsUri');
    log('Token (first 50 chars): ${token.length > 50 ? token.substring(0, 50) : token}...');
    
    try {
      // Try connection with Authorization header
      final webSocket = await WebSocket.connect(
        wsUri.toString(),
        headers: {
          'Authorization': token,  // Try without 'Bearer ' prefix
          'Cookie': 'token=$token', // Some servers check cookies
        },
      );
      _channel = IOWebSocketChannel(webSocket);
      log('WebSocket connected successfully!');

      _channel!.stream.listen(
        (data) {
          log('WebSocket Received: $data');
          _reconnectAttempts = 0; // Reset on successful connection
          _streamController.add(jsonDecode(data));
        },
        onError: (error) {
          log('WebSocket Error: $error');
          _streamController.addError(error);
          _reconnect();
        },
        onDone: () {
          log('WebSocket disconnected');
          _reconnect();
        },
      );
    } catch (e) {
      log('WebSocket Connection Error: $e');
      _reconnect();
    }
  }

  void _reconnect() {
    if (_reconnectAttempts < _maxReconnectAttempts &&
        _lastToken != null &&
        _lastConversationId != null) {
      _reconnectAttempts++;
      log('Reconnecting... (Attempt $_reconnectAttempts/$_maxReconnectAttempts)');
      Future.delayed(Duration(seconds: 2), () {
        connect(_lastToken!, _lastConversationId!);
      });
    } else {
      log('Max reconnection attempts reached. Stopping reconnection.');
    }
  }

  void sendMessage(String message) {
    if (_channel != null) {
      _channel!.sink.add(jsonEncode({'message': message}));
    }
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
    _reconnectAttempts = 0;
  }

  void dispose() {
    disconnect();
    _streamController.close();
  }
}

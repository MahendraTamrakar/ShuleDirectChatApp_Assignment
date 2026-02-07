import 'dart:developer';
import 'dart:async';
import 'dart:convert';
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

  void connect(String token, int conversationId) {
    if (_channel != null) {
      _channel!.sink.close();
    }

    _lastToken = token;
    _lastConversationId = conversationId;
    _reconnectAttempts = 0;

    final url = '${ApiConstants.wsUrl}/$conversationId/?token=$token';
    _channel = WebSocketChannel.connect(Uri.parse(url));

    _channel!.stream.listen(
      (data) {
        log('WebSocket Received: $data');
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
  }

  void _reconnect() {
    if (_reconnectAttempts < _maxReconnectAttempts &&
        _lastToken != null &&
        _lastConversationId != null) {
      _reconnectAttempts++;
      log('Reconnecting... (Attempt $_reconnectAttempts)');
      Future.delayed(Duration(seconds: 2), () {
        connect(_lastToken!, _lastConversationId!);
      });
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

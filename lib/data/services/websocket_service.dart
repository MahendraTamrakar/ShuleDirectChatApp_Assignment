import 'dart:developer';
import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../core/constants/api_constants.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  final StreamController<dynamic> _streamController =
      StreamController<dynamic>.broadcast();

  Stream<dynamic> get messages => _streamController.stream;

  void connect(String token, int conversationId) {
    if (_channel != null) {
      _channel!.sink.close();
    }

    final url = '${ApiConstants.wsUrl}/$conversationId/?token=$token';
    _channel = WebSocketChannel.connect(Uri.parse(url));

    _channel!.stream.listen(
      (data) {
        log('WebSocket Received: $data');
        _streamController.add(jsonDecode(data));
      },
      onError: (error) {
        _streamController.addError(error);
      },
      onDone: () {
        // Handle disconnection if needed
      },
    );
  }

  void sendMessage(String message) {
    if (_channel != null) {
      _channel!.sink.add(jsonEncode({'message': message}));
    }
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
  }

  void dispose() {
    disconnect();
    _streamController.close();
  }
}

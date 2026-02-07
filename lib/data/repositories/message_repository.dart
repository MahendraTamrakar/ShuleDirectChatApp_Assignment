import '../services/chat_service.dart';
import '../services/websocket_service.dart';
import '../models/message_model.dart';
import 'auth_repository.dart';

class MessageRepository {
  final ChatService _chatService;
  final WebSocketService _webSocketService;
  final AuthRepository _authRepository;

  MessageRepository(
    this._chatService,
    this._webSocketService,
    this._authRepository,
  );

  Stream<dynamic> get liveMessages => _webSocketService.messages;

  Future<List<MessageModel>> getMessageHistory(int conversationId) async =>
      _chatService.getMessages(conversationId);

  Future<void> connectToChat(int conversationId) async {
    final token = await _authRepository.getToken();
    if (token != null) _webSocketService.connect(token, conversationId);
  }

  void disconnect() => _webSocketService.disconnect();

  void sendMessage(String content) => _webSocketService.sendMessage(content);

  Future<String?> getCurrentUserEmail() => _authRepository.getUserEmail();
}

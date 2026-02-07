import '../services/chat_service.dart';
import '../models/conversation_model.dart';

class ChatRepository {
  final ChatService _chatService;

  ChatRepository(this._chatService);

  Future<List<ConversationModel>> getConversations() async =>
      _chatService.getConversations();
}

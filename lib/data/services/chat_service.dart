import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';

class ChatService {
  final ApiClient _apiClient;

  ChatService(this._apiClient);

  Future<List<ConversationModel>> getConversations() async {
    // Mock data for testing ui
    return [
      ConversationModel(
        id: 1,
        name: 'Chemistry Group',
        lastMessage: 'Group created by you',
        timestamp: '12 min',
      ),
      ConversationModel(
        id: 2,
        name: 'Shule Direct Official',
        lastMessage: 'Albert: Have you done assignments?',
        timestamp: '12 min',
      ),
    ];

    // Using real API
    // final response = await _apiClient.get(ApiConstants.conversations);
    // final data = response.data;
    
    // Handle both array and object responses
    // if (data is Map<String, dynamic> && data.containsKey('results')) {
    //   // Django REST Framework paginated response
    //   List<dynamic> list = data['results'] ?? [];
    //   return list.map((e) => ConversationModel.fromJson(e)).toList();
    // } else if (data is List) {
    //   return data.map((e) => ConversationModel.fromJson(e)).toList();
    // } else if (data is Map && data['data'] is List) {
    //   return (data['data'] as List).map((e) => ConversationModel.fromJson(e)).toList();
    // }
    
    // return [];
  }

  Future<List<MessageModel>> getMessages(int conversationId) async {
    final response = await _apiClient.get(
      ApiConstants.messages,
      queryParameters: {'conversation_id': conversationId},
    );

    final data = response.data;
    List<dynamic> list = (data is List) ? data : (data['data'] is List ? data['data'] : []);
    return list.map((e) => MessageModel.fromJson(e)).toList();
  }
}

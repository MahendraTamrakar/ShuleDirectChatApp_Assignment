import 'dart:developer';
import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';

class ChatService {
  final ApiClient _apiClient;

  ChatService(this._apiClient);

  Future<List<ConversationModel>> getConversations() async {
    try {
      final response = await _apiClient.get(ApiConstants.conversations);

      final data = response.data;
      log('ChatService.getConversations Response Data: $data');
      List<dynamic> list = [];

      if (data is List) {
        list = data;
      } else if (data is Map<String, dynamic>) {
        // Handle common wrappers
        if (data['data'] is List) {
          list = data['data'];
        } else if (data['results'] is List) {
          list = data['results'];
        } else if (data['conversations'] is List) {
          list = data['conversations'];
        }
      }

      return list.map((e) => ConversationModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<MessageModel>> getMessages(int conversationId) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.messages,
        queryParameters: {'conversation_id': conversationId},
      );

      final data = response.data;
      List<dynamic> list = [];

      if (data is List) {
        list = data;
      } else if (data is Map<String, dynamic>) {
        // Handle common wrappers
        if (data['data'] is List) {
          list = data['data'];
        } else if (data['results'] is List) {
          list = data['results'];
        } else if (data['messages'] is List) {
          list = data['messages'];
        }
      }

      return list.map((e) => MessageModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }
}

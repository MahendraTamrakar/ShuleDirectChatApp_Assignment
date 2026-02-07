import 'package:flutter/material.dart';
import '../../../data/models/conversation_model.dart';
import '../../../data/repositories/chat_repository.dart';

class ConversationsViewModel extends ChangeNotifier {
  final ChatRepository _chatRepository;

  ConversationsViewModel(this._chatRepository);

  List<ConversationModel> _conversations = [];
  List<ConversationModel> get conversations => _conversations;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchConversations() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _conversations = await _chatRepository.getConversations();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

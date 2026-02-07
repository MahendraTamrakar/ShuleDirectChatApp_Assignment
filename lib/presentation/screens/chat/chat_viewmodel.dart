import 'dart:developer';
import 'package:flutter/material.dart';
import '../../../data/models/message_model.dart';
import '../../../data/repositories/message_repository.dart';

class ChatViewModel extends ChangeNotifier {
  final MessageRepository _messageRepository;

  // We need context or logic to know who is 'me'.
  String? _currentUserEmail;
  String _chatName = '';

  ChatViewModel(this._messageRepository);

  List<MessageModel> _messages = [];
  List<MessageModel> get messages => _messages;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String get chatName => _chatName;

  void init(int conversationId, {String chatName = ''}) async {
    _chatName = chatName;
    _isLoading = true;
    notifyListeners();

    try {
      _currentUserEmail = await _messageRepository.getCurrentUserEmail();
      await _fetchHistory(conversationId);
      await _messageRepository.connectToChat(conversationId);

      _messageRepository.liveMessages.listen((data) {

        try {
          if (data is Map<String, dynamic>) {
            final newMessage = MessageModel.fromJson(
              data,
              currentUserEmail: _currentUserEmail,
            );
            _messages.insert(0, newMessage);
            notifyListeners();
          }
        } catch (e) {
          log('WS Parse Error: $e');
        }
      });
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _fetchHistory(int conversationId) async {
    final history = await _messageRepository.getMessageHistory(conversationId);
    // history might presumably need to be sorted or reversed?
    // Assuming API returns chronological order (oldest first).
    // If UI is reverse list, we should reverse it.
    // Usually chat UI is reverse: true.
    _messages = history.reversed.toList();
    // Wait, if API returns oldest first: [msg1, msg2, msg3]
    // UI Reverse ListView expects: [msg3, msg2, msg1] (index 0 is bottom/newest)
    // So yes, reverse list.
  }

  void sendMessage(String content) {
    if (content.trim().isEmpty) return;

    // Optimistic UI update
    final tempMessage = MessageModel(
      content: content,
      isMe: true,
      timestamp: DateTime.now().toIso8601String(),
    );
    _messages.insert(0, tempMessage); // Add to front for reverse list
    notifyListeners();

    _messageRepository.sendMessage(content);
  }

  @override
  void dispose() {
    _messageRepository.disconnect();
    super.dispose();
  }
}

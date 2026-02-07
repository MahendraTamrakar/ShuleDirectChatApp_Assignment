import 'package:flutter/material.dart';
import '../../../data/models/conversation_model.dart';
import '../../../data/repositories/chat_repository.dart';
import '../../../data/repositories/auth_repository.dart';

class ConversationsViewModel extends ChangeNotifier {
  final ChatRepository _chatRepository;
  final AuthRepository _authRepository;

  ConversationsViewModel(this._chatRepository, this._authRepository);

  List<ConversationModel> _conversations = [];
  List<ConversationModel> get conversations => _conversations;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String _userInitial = 'U';
  String get userInitial => _userInitial;

  String? _userEmail;
  String? get userEmail => _userEmail;

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

  Future<void> loadUserInitial() async {
    try {
      _userEmail = await _authRepository.getUserEmail();
      if (_userEmail != null && _userEmail!.isNotEmpty) {
        _userInitial = _userEmail![0].toUpperCase();
      } else {
        _userInitial = 'U';
      }
      notifyListeners();
    } catch (e) {
      _userInitial = 'U';
      notifyListeners();
    }
  }
}


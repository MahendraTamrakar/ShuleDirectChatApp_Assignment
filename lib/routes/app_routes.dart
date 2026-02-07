import 'package:flutter/material.dart';
import '../presentation/screens/splash/splash_screen.dart';
import '../presentation/screens/login/login_screen.dart';
import '../presentation/screens/conversations/conversations_screen.dart';
import '../presentation/screens/chat/chat_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String conversations = '/conversations';
  static const String chat = '/chat';

  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    conversations: (context) => const ConversationsScreen(),
    chat: (context) => const ChatScreen(),
  };
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_strings.dart';
import 'routes/app_routes.dart';
import 'core/network/api_client.dart';
import 'data/services/auth_service.dart';
import 'data/services/chat_service.dart';
import 'data/services/websocket_service.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/chat_repository.dart';
import 'data/repositories/message_repository.dart';
import 'presentation/screens/login/login_viewmodel.dart';
import 'presentation/screens/conversations/conversations_viewmodel.dart';
import 'presentation/screens/chat/chat_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Network & Services
        Provider(create: (_) => ApiClient()),
        ProxyProvider<ApiClient, AuthService>(
          update: (_, client, __) => AuthService(client),
        ),
        ProxyProvider<ApiClient, ChatService>(
          update: (_, client, __) => ChatService(client),
        ),
        Provider(create: (_) => WebSocketService()),

        // Repositories
        ProxyProvider2<AuthService, ApiClient, AuthRepository>(
          update:
              (_, authService, client, __) =>
                  AuthRepository(authService, client),
        ),
        ProxyProvider<ChatService, ChatRepository>(
          update: (_, chatService, __) => ChatRepository(chatService),
        ),
        ProxyProvider3<
          ChatService,
          WebSocketService,
          AuthRepository,
          MessageRepository
        >(
          update:
              (_, chatService, wsService, authRepo, __) =>
                  MessageRepository(chatService, wsService, authRepo),
        ),

        // ViewModels
        ChangeNotifierProxyProvider<AuthRepository, LoginViewModel>(
          create: (context) => LoginViewModel(context.read<AuthRepository>()),
          update: (_, repo, viewModel) => LoginViewModel(repo),
        ),
        ChangeNotifierProxyProvider2<ChatRepository, AuthRepository, ConversationsViewModel>(
          create:
              (context) =>
                  ConversationsViewModel(context.read<ChatRepository>(), context.read<AuthRepository>()),
          update: (_, chatRepo, authRepo, viewModel) => ConversationsViewModel(chatRepo, authRepo),
        ),
        ChangeNotifierProxyProvider<MessageRepository, ChatViewModel>(
          create: (context) => ChatViewModel(context.read<MessageRepository>()),
          update: (_, repo, viewModel) => ChatViewModel(repo),
        ),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes,
      ),
    );
  }
}

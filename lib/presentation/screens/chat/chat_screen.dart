import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_colors.dart';
import 'chat_viewmodel.dart';
import '../../widgets/chat_bubble.dart';
// import '../../widgets/score_gauge_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final conversationId = ModalRoute.of(context)!.settings.arguments as int;
      context.read<ChatViewModel>().init(conversationId);
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text;
    if (text.isNotEmpty) {
      context.read<ChatViewModel>().sendMessage(text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white,
              child: Icon(Icons.group, size: 20, color: AppColors.primary),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Chemistry Group',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '20 Online',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.person_add), onPressed: () {}),
        ],
      ),
      body: Container(
        color: const Color(
          0xFFFFF5F5,
        ), // Light red/pinkish background pattern placeholder
        child: Column(
          children: [
            // System Message
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2F1), // Light green
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'John added you in group',
                  style: TextStyle(fontSize: 12, color: Colors.green),
                ),
              ),
            ),

            Expanded(
              child: Consumer<ChatViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isLoading && viewModel.messages.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (viewModel.errorMessage != null &&
                      viewModel.messages.isEmpty) {
                    return Center(child: Text(viewModel.errorMessage!));
                  }

                  return ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.all(16),
                    itemCount: viewModel.messages.length,
                    itemBuilder: (context, index) {
                      final message = viewModel.messages[index];
                      return ChatBubble(
                        content: message.content,
                        isMe: message.isMe,
                        timestamp: message.timestamp,
                      );
                    },
                  );
                },
              ),
            ),

            // Input Area
            SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: TextField(
                          controller: _messageController,
                          decoration: const InputDecoration(
                            hintText: 'Enter Message...',
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.emoji_emotions_outlined,
                              color: Colors.grey,
                            ),
                            suffixIcon: Icon(
                              Icons.attach_file,
                              color: Colors.grey,
                            ),
                          ),
                          textCapitalization: TextCapitalization.sentences,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: _sendMessage,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

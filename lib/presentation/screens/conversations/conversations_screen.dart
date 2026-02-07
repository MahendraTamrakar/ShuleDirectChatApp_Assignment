import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
// import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../routes/app_routes.dart';
// import '../../../../core/utils/helpers.dart';
import 'conversations_viewmodel.dart';
import '../../../data/repositories/auth_repository.dart';

class ConversationsScreen extends StatefulWidget {
  const ConversationsScreen({super.key});

  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.primary,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ConversationsViewModel>().loadUserInitial();
    });
  }

  void _logout() async {
    await context.read<AuthRepository>().logout();
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 3,
        shadowColor: Colors.black26,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0,
        toolbarHeight: 70,
        title: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: SizedBox(
            height: 40,
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Placeholder text here',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                suffixIcon: Icon(Icons.search, color: Colors.black54),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
              ),
            ),
          ),
        ),
        leading: Icon(Icons.menu, color: Colors.black),
        actions: [
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              const Icon(
                Icons.notifications_none,
                color: Colors.black,
                size: 26,
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '3',
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _logout();
              }
            },
            offset: const Offset(0, 40),
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Log Out'),
                      ],
                    ),
                  ),
                ],
            child: Consumer<ConversationsViewModel>(
              builder: (context, viewModel, _) {
                return CircleAvatar(
                  radius: 19,
                  backgroundColor: const Color(0xFF333333),
                  child: Text(
                    viewModel.userInitial,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: const Color.fromARGB(255, 255, 253, 253),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),

            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    left: MediaQuery.of(context).size.width * 0.48,
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(100),
                              topRight: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                            color: const Color.fromARGB(76, 166, 205, 237),
                          ),
                        ),
                      
                        Container(
                          width: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(100),
                              topRight: Radius.circular(100),
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                            color: const Color.fromARGB(73, 255, 237, 251),
                          ),
                        ),
                        Container(
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                              bottomLeft: Radius.circular(100),
                              bottomRight: Radius.circular(12),
                            ),
                            color: const Color.fromARGB(74, 216, 255, 227),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Groups',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: const [
                          Text(
                            'Form - 1',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.black,
                            size: 18,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search messages or users',
                hintStyle: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                ),
                suffixIcon: Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Color.fromARGB(255, 255, 255, 255),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 12,
                ),
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Recent',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildMockConversationTile(
                  context,
                  name: 'Chemistry Group',
                  message: 'Group created by you',
                  time: '12 min',
                  color: Colors.pink.shade100,
                  initial: 'C',
                  isOnline: true,
                ),
                _buildMockConversationTile(
                  context,
                  name: 'Shule Direct Official',
                  message: 'Albert: Have you done assignments?',
                  time: '12 min',
                  color:
                      Colors
                          .orange
                          .shade100, // Roughly matching screenshot logo color
                  initial: 'S',
                  isOnline: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMockConversationTile(
    BuildContext context, {
    required String name,
    required String message,
    required String time,
    required Color color,
    required String initial,
    bool isOnline = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        //        borderRadius: BorderRadius.circular(12), // Reference doesn't show card style, but clean list.
        //        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)], // Optional
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: color,
              child: Text(
                initial,
                style: const TextStyle(
                  color: Colors.brown,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            if (isOnline)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            message,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
        trailing: Text(
          time,
          style: TextStyle(color: Colors.grey[400], fontSize: 12),
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.chat,
            arguments: {'name': name, 'id': 1},
          );
        },
      ),
    );
  }
}

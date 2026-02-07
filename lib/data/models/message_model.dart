class MessageModel {
  final String content;
  final bool
  isMe; // Helper to identify if message is from current user (logic might be needed in repo)
  final String timestamp;

  MessageModel({
    required this.content,
    required this.isMe,
    required this.timestamp,
  });

  factory MessageModel.fromJson(
    Map<String, dynamic> json, {
    String? currentUserEmail,
  }) {
    // If API provides sender info, compare with current user
    // Simplified for assignment if structure isn't fully known
    return MessageModel(
      content: json['message'] ?? json['content'] ?? '',
      isMe: json['sender_email'] == currentUserEmail, // Example logic
      timestamp: json['timestamp'] ?? '',
    );
  }
}

class ConversationModel {
  final int id;
  final String name; // e.g., Other participant's name
  final String lastMessage;
  final String timestamp;

  ConversationModel({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.timestamp,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? json['group_name'] ?? 'Unknown',
      lastMessage: json['last_message'] ?? '',
      timestamp: json['timestamp'] ?? '',
    );
  }
}

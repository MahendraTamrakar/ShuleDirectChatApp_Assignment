class ApiConstants {
  static const String baseUrl =
      'https://dev-api.supersourcing.com/shuledirect-service';
  static const String wsUrl =
      'wss://dev-api.supersourcing.com/shuledirect-service/ws/chat';

  // Endpoints
  static const String login = '$baseUrl/candidates/login/';
  static const String conversations = '$baseUrl/chat/conversations/';
  static const String messages = '$baseUrl/chat/messages/';


  static const String authHeader = 'Authorization';
  static const String bearer = 'Bearer';
}

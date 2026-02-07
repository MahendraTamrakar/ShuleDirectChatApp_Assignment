# Shule Direct Chat App

A Flutter-based real-time messaging application that enables users to engage in group and direct conversations with WebSocket support for real-time updates.

## Features

- **User Authentication**: Secure login with Bearer token authentication
- **Real-time Messaging**: WebSocket-based instant messaging
- **Group Chats**: Create and participate in group conversations
- **Chat History**: View message history with timestamps
- **User Presence**: Real-time online status indicators
- **Inline Chat**: Open conversations directly within the conversations list
- **Secure Storage**: Device-level secure data storage

## Technology Stack

- **Framework**: Flutter 3.7.2+
- **State Management**: Provider
- **Networking**: Dio for HTTP, WebSocket for real-time communication
- **Storage**: Flutter Secure Storage, Shared Preferences
- **UI**: Material Design

## Project Structure

```
lib/
├── main.dart                          # Application entry point
│
├── core/                              # Core utilities and constants
│   ├── constants/
│   │   ├── api_constants.dart        # API endpoints and base URLs
│   │   ├── app_colors.dart           # Color palette definitions
│   │   └── app_strings.dart          # Text constants
│   ├── network/
│   │   └── api_client.dart           # HTTP client configuration
│   ├── theme/
│   │   └── app_theme.dart            # Theme definitions for Material Design
│   └── utils/
│       ├── helpers.dart              # Utility functions
│       └── validators.dart           # Input validation functions
│
├── data/                              # Data layer with business logic
│   ├── models/
│   │   ├── conversation_model.dart   # Conversation data structure
│   │   ├── message_model.dart        # Message data structure
│   │   └── user_model.dart           # User data structure
│   ├── services/
│   │   ├── auth_service.dart         # Authentication API calls
│   │   ├── chat_service.dart         # Chat API calls
│   │   └── websocket_service.dart    # WebSocket management
│   └── repositories/
│       ├── auth_repository.dart      # Authentication business logic
│       ├── chat_repository.dart      # Chat operations business logic
│       └── message_repository.dart   # Message operations business logic
│
├── presentation/                      # UI layer
│   ├── screens/
│   │   ├── login/
│   │   │   ├── login_screen.dart     # Login UI and initial authentication
│   │   │   └── login_viewmodel.dart  # Login state management
│   │   ├── conversations/
│   │   │   ├── conversations_screen.dart       # Conversations list and inline chat view
│   │   │   └── conversations_viewmodel.dart    # Conversations state management
│   │   └── chat/
│   │       ├── chat_screen.dart      # Full-screen chat view
│   │       └── chat_viewmodel.dart   # Chat state management
│   └── widgets/
│       ├── chat_bubble.dart          # Individual message widget
│       ├── custom_text_field.dart    # Reusable text input widget
│       └── score_gauge_widget.dart   # Custom gauge widget
│
└── routes/
    └── app_routes.dart               # Navigation route definitions
```

## Getting Started

### Prerequisites

- Flutter SDK 3.7.2 or higher
- Dart SDK
- Android SDK or Xcode for iOS development

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd shule_direct_chat_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure API endpoints in `lib/core/constants/api_constants.dart`:
```dart
static const String baseUrl = 'your-api-base-url';
static const String wsUrl = 'your-websocket-url';
```

4. Run the application:
```bash
flutter run
```

## Key Components

### Authentication
- Login with email and password
- Secure token storage using Flutter Secure Storage
- Automatic logout functionality

### Real-time Chat
- WebSocket connection for instant message delivery
- Message timestamps and user identification
- Support for group conversations
- Inline chat view for seamless experience

### State Management
- Provider pattern with ChangeNotifier for reactive UI
- Separate ViewModels for each screen
- Repository pattern for data abstraction

## Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| provider | ^6.1.5+1 | State management |
| dio | ^5.9.1 | HTTP client |
| flutter_secure_storage | ^10.0.0 | Secure local storage |
| web_socket_channel | ^3.0.3 | WebSocket communication |
| intl | ^0.20.2 | Internationalization |
| google_fonts | ^6.3.2 | Custom fonts |
| flutter_dotenv | ^6.0.0 | Environment configuration |
| shared_preferences | ^2.5.3 | Local preferences |
| flutter_svg | ^2.2.2 | SVG rendering |
| flutter_launcher_icons | ^0.14.4 | App icon generation |

## API Endpoints

Base URL: `https://dev-api.supersourcing.com/shuledirect-service`

- **Login**: `POST /candidates/login/`
- **Conversations**: `GET /chat/conversations/`
- **Messages**: `GET /chat/messages/`
- **WebSocket**: `wss://dev-api.supersourcing.com/shuledirect-service/ws/chat`

## Navigation Flow

```
Login Screen
    ↓
Conversations Screen (inline chat or navigate to Chat Screen)
    ↓
Chat Screen (full-screen view)
```

## Code Architecture

### MVVM Pattern
- **Model**: Data classes in `data/models/`
- **View**: UI screens in `presentation/screens/`
- **ViewModel**: State management in `*_viewmodel.dart` files

### Repository Pattern
- Abstracts data sources (API, WebSocket, Local)
- Centralizes business logic
- Improves testability and maintainability

## Building for Production

### Android
```bash
flutter build apk
# or
flutter build appbundle
```

### iOS
```bash
flutter build ios
```

## Troubleshooting

### WebSocket Connection Issues
- Verify WebSocket URL in `api_constants.dart`
- Check internet connectivity
- Ensure authentication token is valid

### Message Not Sending
- Validate message content is not empty
- Check WebSocket connection status
- Verify user has necessary permissions

## Future Enhancements

- User profile management
- Message search functionality
- Media sharing (images, files)
- Typing indicators
- Message reactions/emojis
- User blocking
- Read receipts

## Contributing

1. Create a feature branch
2. Make your changes
3. Test thoroughly
4. Submit a pull request

## License

This project is proprietary and confidential.

## Support

For issues and support, please contact the development team.

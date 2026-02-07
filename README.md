# Shule Direct Chat App

A Flutter-based real-time messaging application that enables users to engage in group and direct conversations with WebSocket support for real-time updates.

## Features

- **User Authentication**: Secure login with Bearer token authentication
- **Token Management**: Automatic refresh token storage and 401 error handling
- **Real-time Messaging**: WebSocket-based instant messaging
- **Group Chats**: Create and participate in group conversations
- **Chat History**: View message history with timestamps
- **User Presence**: Real-time online status indicators
- **Inline Chat**: Open conversations directly within the conversations list
- **Secure Storage**: Device-level secure data storage with refresh tokens
- **Dynamic UI**: Chat screen displays selected conversation name with first letter avatar
- **Background Support**: Custom background images in chat screens

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

### Authentication & Token Management
- Login with email and password
- Secure token storage using Flutter Secure Storage
- **Refresh token support**: Automatic token refresh on 401 responses
- Tokens persisted across app sessions
- Automatic logout functionality
- Error handling for token expiration

### Real-time Chat
- WebSocket connection for instant message delivery
- Message timestamps and user identification
- Support for group conversations
- Inline chat view for seamless experience
- Dynamic conversation name display in chat header
- Group avatar with first letter in uppercase
- Custom background image support

### State Management
- Provider pattern with ChangeNotifier for reactive UI
- Separate ViewModels for each screen
- Repository pattern for data abstraction
- Automatic data initialization on ViewModel creation
- Hot reload state persistence for smooth development

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

## Recent Updates (v1.1.0)

### Security Enhancements
- ✅ Added refresh token extraction from API response headers
- ✅ Secure storage of refresh tokens in Flutter Secure Storage
- ✅ Automatic token restoration on app startup
- ✅ 401 error interceptor for unauthorized responses
- ✅ Token update mechanism for silent authentication

### UI/UX Improvements
- ✅ Mock data implementation for conversations (Chemistry Group, Shule Direct Official)
- ✅ Dynamic chat name display from selected conversation
- ✅ Group avatar with first letter initial in circle
- ✅ Background image integration in chat screen
- ✅ Border separator above message input area
- ✅ Improved conversation tile rendering with dynamic colors

### State Management Fixes
- ✅ ViewModel auto-initialization on creation (fixes hot reload data loss)
- ✅ Proper loading state handling (starts with `true`)
- ✅ Removed redundant initState callbacks

### API Integration
- ✅ Simplified token extraction logic
- ✅ Response parsing with ternary operators
- ✅ Debug logging with `kDebugMode` check

## Troubleshooting

### Token Refresh Implementation
When a 401 response is received:
1. The `ApiClient` triggers the `_onUnauthorized` callback
2. Call your API's refresh endpoint with the stored refresh token
3. Update the access token using `AuthRepository.updateToken(newToken)`
4. Retry the original request with the new token

Example:
```dart
// In your authentication logic
_apiClient.setUnauthorizedCallback((message) async {
  final refreshToken = await _authRepository.getRefreshToken();
  if (refreshToken != null) {
    // Call refresh endpoint
    // final newToken = await refreshAccessToken(refreshToken);
    // await _authRepository.updateToken(newToken);
  }
});
```

### WebSocket Connection Issues
- Verify WebSocket URL in `api_constants.dart`
- Check internet connectivity
- Ensure authentication token is valid
- Verify refresh token is available for re-authentication

### Message Not Sending
- Validate message content is not empty
- Check WebSocket connection status
- Verify user has necessary permissions
- Ensure token hasn't expired (check via 401 responses)

## Future Enhancements

- User profile management
- Message search functionality
- Message reactions and emojis
- User typing indicators
- Message edit and delete
- File/Media sharing in chat
- Read receipts
- User muting/blocking
- Chat notifications
- Message encryption

## Testing Data

### Mock Conversations (Development)
The app currently uses mock data for conversation development:
- **Chemistry Group** - "Group created by you"
- **Shule Direct Official** - "Albert: Have you done assignments?"

To switch to API calls, modify `lib/data/services/chat_service.dart` and uncomment the API call section.

### Test Credentials
- **Email**: `kenu@yopmail.com`
- **Password**: `kenu1234`
- **Token Expiry**: 7 days
### Test Credentials
- **Email**: `kenu@yopmail.com`
- **Password**: `kenu1234`
- **Token Expiry**: 7 days
- **Refresh Token**: Stored securely and can be used for re-authentication

## Contributing

1. Create a feature branch
2. Make your changes
3. Test thoroughly
4. Submit a pull request

## License

This project is proprietary and confidential.

## Support

For issues and support, please contact the development team.

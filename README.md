# Shule Direct Chat App

A Flutter-based real-time messaging application that enables users to engage in group and direct conversations with WebSocket support for real-time updates.

## Features

- **User Authentication**: Secure login with Bearer token authentication
- **Automatic Session Management**: App remembers your login and auto-restarts from conversations
- **Splash Screen**: Splash screen with app logo on startup
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
│   │   ├── splash/
│   │   │   └── splash_screen.dart     # App startup with auth check
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

### Quick Testing with APK

For quick testing without building from source, you can download the pre-built APK:

1. Navigate to the `apk/` folder in the project
2. Download the latest release APK file
3. Transfer the APK to your Android device
4. Enable "Unknown Sources" in your device settings
5. Open the APK file and install it
6. Launch the app and login with your credentials

**Note**: This is the fastest way to test the app on a physical device!

### Installation from Source

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


## Navigation Flow

```
Splash Screen (Auto Auth Check)
    ↓
    ├─→ Conversations Screen (if logged in)
    │       ↓
    │   Chat Screen (full-screen view)
    │
    └─→ Login Screen (if not logged in)
            ↓
        Conversations Screen (after login)
            ↓
        Chat Screen (full-screen view)
```

**Splash Screen Features**:
- Displays app logo from `assets/app_icon/app.png`
- Loads for 2 seconds for branding
- Automatically checks if user is logged in
- Redirects to appropriate screen based on auth status

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

## Testing Data

### Login Credentials (Development)
```
Email: kenu@yopmail.com
Password: kenu1234
```

### Mock Conversations (Fallback)
When the API returns empty conversations, the app automatically uses mock data:
- **Chemistry Group** - "Group created by you"
- **Shule Direct Official** - "Albert: Have you done assignments?"

**Note**: These mock conversations are for UI testing only. WebSocket connections to mock conversations may fail if the IDs don't exist on the server.

## APK Distribution

Pre-built APK files are available in the `apk/` folder for easy testing without building from source:


### Quick Installation

**Method 1: Using ADB (Recommended)**
```bash
adb install apk/app-release.apk
```

**Method 2: Manual Installation**
1. Download APK from `apk/` folder
2. Enable "Unknown Sources" in device Settings → Security
3. Copy APK to your Android device
4. Open file manager and tap the APK
5. Follow the installation prompts

### Testing the Installed App

1. **Launch the app** - You'll see the splash screen with the Shule Direct logo
2. **Auto-login** - If you were previously logged in, it will skip to conversations
3. **Manual login** - If first time, use test credentials:
   ```
   Email: kenu@yopmail.com
   Password: kenu1234
   ```
4. **Explore conversations** - Browse available conversations
5. **Send messages** - Tap any conversation to open chat
6. **Reliable persistence** - Close and reopen the app; your session persists!
```

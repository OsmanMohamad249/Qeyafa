---
name: 004 - Flutter Mobile App Scaffold
about: Scaffold Flutter mobile application with API client
title: '[MOBILE] Scaffold Flutter Mobile App and API Client'
labels: enhancement, mobile
assignees: ''

---

## Description
Create a scaffold for the Flutter mobile application with a proper API client to communicate with the backend.

## Objectives
- [ ] Set up Flutter project structure
- [ ] Create API client with HTTP service
- [ ] Implement authentication state management
- [ ] Create basic UI screens (Login, Home, Measurement)
- [ ] Implement image capture and upload
- [ ] Add measurement display screen
- [ ] Set up navigation and routing

## Project Structure
```
mobile-app/
├── lib/
│   ├── main.dart
│   ├── config/
│   │   └── api_config.dart
│   ├── services/
│   │   ├── api_client.dart
│   │   ├── auth_service.dart
│   │   └── measurement_service.dart
│   ├── models/
│   │   ├── user.dart
│   │   ├── measurement.dart
│   │   └── api_response.dart
│   ├── screens/
│   │   ├── login_screen.dart
│   │   ├── home_screen.dart
│   │   ├── camera_screen.dart
│   │   └── measurement_screen.dart
│   ├── widgets/
│   │   └── measurement_card.dart
│   └── providers/
│       ├── auth_provider.dart
│       └── measurement_provider.dart
```

## Technical Requirements

### API Client
- Use `dio` package for HTTP requests
- Implement interceptors for:
  - JWT token injection
  - Error handling
  - Logging
- Handle network errors gracefully
- Support multipart file uploads

### State Management
- Use Provider or Riverpod for state management
- Implement authentication state (logged in/out)
- Manage measurement history state
- Cache user preferences locally

### UI Screens

#### Login Screen
- Email and password input
- Login button with loading state
- Registration link
- Error message display

#### Home Screen
- User profile summary
- Recent measurements list
- New measurement button
- Navigation drawer

#### Camera Screen
- Camera integration for photo capture
- Gallery picker for selecting existing photos
- Photo preview before upload
- Multi-photo selection (up to 5 photos)

#### Measurement Screen
- Display processed measurements
- Show body diagram with measurements
- Export/share functionality
- History of measurements

### Features
- [ ] User authentication (login/register)
- [ ] Photo capture and upload
- [ ] Measurement processing and display
- [ ] Measurement history
- [ ] Profile management
- [ ] Offline mode support

## Environment Configuration
```dart
class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:5000',
  );
  
  static const String apiVersion = 'v1';
}
```

## Acceptance Criteria
- [ ] Flutter project compiles without errors
- [ ] API client successfully communicates with backend
- [ ] Users can login and authenticate
- [ ] Users can capture/select photos
- [ ] Photos are uploaded to backend
- [ ] Measurements are displayed correctly
- [ ] Navigation between screens works smoothly
- [ ] Error handling shows user-friendly messages
- [ ] App works on both iOS and Android
- [ ] Unit tests for services and models
- [ ] Widget tests for UI components

## Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  dio: ^5.3.0
  provider: ^6.0.5
  shared_preferences: ^2.2.0
  camera: ^0.10.5
  image_picker: ^1.0.0
  flutter_secure_storage: ^9.0.0
  json_annotation: ^4.8.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.0
  json_serializable: ^6.7.0
  mockito: ^5.4.0
```

## Platform Support
- iOS: 12.0+
- Android: API 21+ (Android 5.0)

## References
- Flutter Documentation: https://flutter.dev/docs
- Dio Package: https://pub.dev/packages/dio
- Provider Pattern: https://pub.dev/packages/provider
- Camera Plugin: https://pub.dev/packages/camera

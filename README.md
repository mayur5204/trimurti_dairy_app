# Dairy App

A modern dairy management mobile application built with Flutter, Firebase, and Riverpod for state management.

## 🚀 Features

- **Authentication**: Email/password authentication with Firebase Auth
- **Secure Storage**: Session management with Flutter Secure Storage
- **State Management**: Reactive state management with Riverpod
- **Cross-Platform**: Supports Android and iOS
- **Modern UI**: Material Design 3 with light/dark theme support
- **Firebase Integration**: Real-time data with Firestore

## 📱 Planned Features (Phase 2)

- Inventory Management
- Customer Management
- Order Tracking
- Sales Reports & Analytics
- Delivery Route Management
- Local Database Integration with Drift/SQLite

## 🛠️ Setup Instructions

### Prerequisites

- Flutter SDK (3.8.0 or higher)
- Dart SDK
- Firebase account
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd trimurti_dairy
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   
   Follow the detailed instructions in [FIREBASE_SETUP.md](FIREBASE_SETUP.md)
   
   Quick setup:
   ```bash
   # Install FlutterFire CLI
   dart pub global activate flutterfire_cli
   
   # Configure Firebase for your project
   flutterfire configure
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

## 📂 Project Structure

```
lib/
├── main.dart                    # App entry point with Firebase initialization
├── firebase_options.dart       # Firebase configuration (auto-generated)
├── screens/
│   ├── login_screen.dart       # Authentication screen
│   └── home_screen.dart        # Main dashboard
└── services/
    ├── firebase_auth_service.dart  # Authentication service
    └── firestore_service.dart      # Database service
```

## 🔧 Dependencies

### Core Dependencies
- `flutter`: Flutter SDK
- `flutter_riverpod`: State management
- `firebase_core`: Firebase initialization
- `firebase_auth`: Authentication
- `cloud_firestore`: Database
- `flutter_secure_storage`: Secure session storage
- `path_provider`: File system access

### Dev Dependencies
- `flutter_test`: Testing framework
- `flutter_lints`: Code quality

## 🏗️ Architecture

The app follows a clean architecture pattern with:

- **Presentation Layer**: Screens and UI components
- **Business Logic Layer**: Riverpod providers and controllers
- **Data Layer**: Firebase services and local storage

## 🔐 Security Features

- Secure token storage with `flutter_secure_storage`
- Firebase Authentication with email/password
- Automatic session management
- Secure Firebase rules (to be configured)

## 🚧 Development Roadmap

### Phase 1: Authentication & Setup ✅
- [x] Firebase integration
- [x] Email/password authentication
- [x] Secure session management
- [x] Basic UI framework
- [x] State management setup

### Phase 2: Core Features (Next)
- [ ] Local database integration (Drift/SQLite)
- [ ] Inventory management
- [ ] Customer management
- [ ] Order tracking
- [ ] Basic reporting

### Phase 3: Advanced Features
- [ ] Real-time synchronization
- [ ] Offline support
- [ ] Advanced analytics
- [ ] Delivery route optimization
- [ ] Multi-user support

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🐛 Known Issues

- Firebase configuration requires manual setup
- Some features are placeholders pending Phase 2 development

## 📞 Support

For support, please open an issue in the repository or contact the development team.

---

**Note**: This is Phase 1 of the dairy management app. Core features will be implemented in subsequent phases.

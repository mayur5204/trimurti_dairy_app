# Firebase Configuration Instructions

## Prerequisites
Before running the app, you need to configure Firebase for your project.

### Step 1: Install FlutterFire CLI
```bash
dart pub global activate flutterfire_cli
```

### Step 2: Create a Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project named "dairy-app" (or your preferred name)
3. Enable Google Analytics if desired

### Step 3: Configure Firebase Services
In the Firebase Console:

#### Authentication
1. Go to Authentication > Sign-in method
2. Enable "Email/Password" provider
3. Save the changes

#### Firestore Database
1. Go to Firestore Database
2. Create database in production mode (or test mode for development)
3. Choose your preferred location
4. Set up security rules as needed

### Step 4: Configure Flutter Project
Run the following command in your project root:
```bash
flutterfire configure
```

This will:
- Create the `firebase_options.dart` file with your project configuration
- Download and place the necessary configuration files:
  - `android/app/google-services.json` (for Android)
  - `ios/Runner/GoogleService-Info.plist` (for iOS)

### Step 5: Android Configuration
The FlutterFire CLI should handle most of the Android configuration, but verify:

1. Check that `android/app/google-services.json` exists
2. Ensure the following is in `android/app/build.gradle.kts`:
   ```kotlin
   // At the top of the file
   plugins {
       id("com.google.gms.google-services")
   }
   ```

3. Ensure the following is in `android/build.gradle.kts`:
   ```kotlin
   dependencies {
       classpath("com.google.gms:google-services:4.4.0")
   }
   ```

### Step 6: iOS Configuration
The FlutterFire CLI should handle iOS configuration, but verify:

1. Check that `ios/Runner/GoogleService-Info.plist` exists
2. Ensure the bundle ID matches your Firebase project

### Step 7: Test the Configuration
Run the app:
```bash
flutter run
```

If everything is configured correctly:
- The app should start without Firebase initialization errors
- You should be able to create an account and sign in
- Authentication state should persist between app restarts

## Troubleshooting

### Common Issues:
1. **Firebase not initialized**: Ensure `firebase_options.dart` exists and contains your project configuration
2. **Authentication errors**: Check that Email/Password is enabled in Firebase Console
3. **Platform-specific errors**: Ensure the correct configuration files are in place for each platform

### Support:
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase Console](https://console.firebase.google.com/)

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/firebase_auth_service.dart';
import '../config/app_theme.dart';

/// GetX Controller for login functionality
/// Handles authentication logic and UI state management
class LoginController extends GetxController {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Form controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Observable states
  final _isLoading = false.obs;
  final _obscurePassword = true.obs;
  final _rememberMe = false.obs;
  final _error = RxString('');

  // Getters for reactive UI
  bool get isLoading => _isLoading.value;
  bool get obscurePassword => _obscurePassword.value;
  bool get rememberMe => _rememberMe.value;
  String get error => _error.value;

  /// Toggle password visibility
  void togglePasswordVisibility() {
    _obscurePassword.value = !_obscurePassword.value;
  }

  /// Toggle remember me checkbox
  void toggleRememberMe(bool? value) {
    _rememberMe.value = value ?? false;

    // Save preference
    if (_rememberMe.value && emailController.text.isNotEmpty) {
      _saveLoginInfo();
    } else {
      _clearSavedLoginInfo();
    }
  }

  /// Save login email for remembering user
  Future<void> _saveLoginInfo() async {
    try {
      await _secureStorage.write(
        key: 'remembered_email',
        value: emailController.text.trim(),
      );
      await _secureStorage.write(key: 'remember_me', value: 'true');
    } catch (e) {
      debugPrint('Could not save login info: $e');
    }
  }

  /// Clear saved login information
  Future<void> _clearSavedLoginInfo() async {
    try {
      await _secureStorage.delete(key: 'remembered_email');
      await _secureStorage.delete(key: 'remember_me');
    } catch (e) {
      debugPrint('Could not clear login info: $e');
    }
  }

  /// Load saved login information if any
  Future<void> _loadSavedLoginInfo() async {
    try {
      final rememberMe = await _secureStorage.read(key: 'remember_me');
      if (rememberMe == 'true') {
        _rememberMe.value = true;
        final savedEmail = await _secureStorage.read(key: 'remembered_email');
        if (savedEmail != null && savedEmail.isNotEmpty) {
          emailController.text = savedEmail;
        }
      }
    } catch (e) {
      debugPrint('Could not load login info: $e');
    }
  }

  /// Handle user sign in with proper validation and error handling
  Future<void> handleSignIn() async {
    // Clear previous errors
    _error.value = '';

    // Validate form
    if (!formKey.currentState!.validate()) return;

    _isLoading.value = true;

    try {
      final userCredential = await _authService.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      // Save login info if rememberMe is checked
      if (_rememberMe.value && userCredential != null) {
        await _saveLoginInfo();
      }

      // Navigate to home screen on successful login
      Get.offAllNamed('/home');
    } catch (e) {
      // Set error message
      _error.value = e.toString();

      // Show error message
      Get.snackbar(
        'Login Failed',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
        borderRadius: 10,
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  /// Handle password reset with improved validation and feedback
  Future<void> handlePasswordReset() async {
    final email = emailController.text.trim();

    // Email validation
    if (email.isEmpty) {
      Get.dialog(
        AlertDialog(
          title: const Text('Email Required'),
          content: const Text(
            'Please enter your email address to reset your password.',
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text(
                'OK',
                style: TextStyle(color: AppTheme.primaryGreen),
              ),
            ),
          ],
        ),
      );
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.dialog(
        AlertDialog(
          title: const Text('Invalid Email'),
          content: const Text('Please enter a valid email address.'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text(
                'OK',
                style: TextStyle(color: AppTheme.primaryGreen),
              ),
            ),
          ],
        ),
      );
      return;
    }

    // Show loading dialog
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(color: AppTheme.primaryGreen),
      ),
      barrierDismissible: false,
    );

    try {
      await _authService.resetPassword(email: email);

      // Close loading dialog
      Get.back();

      // Show success dialog
      Get.dialog(
        AlertDialog(
          title: const Text('Password Reset Email Sent'),
          content: Text('We\'ve sent a password reset email to $email.'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text(
                'OK',
                style: TextStyle(color: AppTheme.primaryGreen),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      // Close loading dialog
      Get.back();

      // Show error dialog
      Get.dialog(
        AlertDialog(
          title: const Text('Password Reset Failed'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text(
                'OK',
                style: TextStyle(color: AppTheme.primaryGreen),
              ),
            ),
          ],
        ),
      );
    }
  }

  /// Reset controller state (useful when returning to login after logout)
  void resetState() {
    passwordController.clear();
    _isLoading.value = false;
    _obscurePassword.value = true;
    _error.value = '';
    formKey.currentState?.reset();
    // Don't clear email and remember me flag if remembered
  }

  @override
  void onInit() {
    super.onInit();
    // Load saved login info if available
    _loadSavedLoginInfo();
  }

  bool _isDisposed = false;

  @override
  void onClose() {
    // Only dispose controllers if they haven't been disposed yet
    if (!_isDisposed) {
      _isDisposed = true;
      try {
        emailController.dispose();
        passwordController.dispose();
      } catch (e) {
        debugPrint('Error disposing controllers: $e');
      }
    }
    super.onClose();
  }
}

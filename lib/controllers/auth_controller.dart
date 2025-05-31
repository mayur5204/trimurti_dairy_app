import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../services/firebase_auth_service.dart';

class AuthController extends GetxController {
  final FirebaseAuthService _authService = FirebaseAuthService();

  // Observable states
  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool rememberMe = false.obs;
  final RxString errorMessage = ''.obs;

  // Form controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    // Load saved email if remember me was checked
    _loadSavedCredentials();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Toggle remember me
  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  // Clear error message
  void clearError() {
    errorMessage.value = '';
  }

  // Validate email
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // Validate password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  // Sign in method
  Future<void> signIn() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Simulate loading for better UX (minimum 2 seconds)
      await Future.delayed(const Duration(milliseconds: 1500));

      final user = await _authService.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (user != null) {
        // Save credentials if remember me is checked
        if (rememberMe.value) {
          await _saveCredentials();
        } else {
          await _clearSavedCredentials();
        }

        // Navigate to home screen
        Get.offAllNamed('/home');
      }
    } catch (e) {
      errorMessage.value = _getErrorMessage(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Reset password
  Future<void> resetPassword() async {
    if (emailController.text.isEmpty) {
      errorMessage.value = 'Please enter your email address first';
      return;
    }

    try {
      isLoading.value = true;
      await _authService.resetPassword(email: emailController.text.trim());

      Get.snackbar(
        'Password Reset',
        'Password reset email sent. Please check your inbox.',
        backgroundColor: Colors.green.withValues(alpha: 0.1),
        colorText: Colors.green,
        icon: const Icon(Icons.check_circle, color: Colors.green),
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      errorMessage.value = _getErrorMessage(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Load saved credentials
  Future<void> _loadSavedCredentials() async {
    // TODO: Implement with flutter_secure_storage
    // For now, just a placeholder
  }

  // Save credentials
  Future<void> _saveCredentials() async {
    // TODO: Implement with flutter_secure_storage
    // For now, just a placeholder
  }

  // Clear saved credentials
  Future<void> _clearSavedCredentials() async {
    // TODO: Implement with flutter_secure_storage
    // For now, just a placeholder
  }

  // Get user-friendly error message
  String _getErrorMessage(String error) {
    if (error.contains('user-not-found')) {
      return 'No account found with this email address';
    } else if (error.contains('wrong-password')) {
      return 'Incorrect password. Please try again';
    } else if (error.contains('invalid-email')) {
      return 'Invalid email address format';
    } else if (error.contains('user-disabled')) {
      return 'This account has been disabled';
    } else if (error.contains('too-many-requests')) {
      return 'Too many failed attempts. Please try again later';
    } else if (error.contains('network-request-failed')) {
      return 'Network error. Please check your connection';
    } else {
      return 'Login failed. Please try again';
    }
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import '../controllers/login_controller.dart';
import '../config/app_theme.dart';
import '../widgets/animated_gradient_button.dart';
import '../controllers/language_controller.dart';

/// Login screen for dairy owner authentication
/// This screen provides authentication for admin users only
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller with unique tag and permanent retention
    final LoginController controller = Get.put(
      LoginController(),
      tag: 'login_controller',
      permanent: true,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: GestureDetector(
        // Dismiss keyboard when tapping outside of text fields
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          // Prevent resize when keyboard appears
          resizeToAvoidBottomInset: false,
          body: _ResponsiveLoginLayout(controller: controller),
        ),
      ),
    );
  }
}

/// Responsive layout for login screen that adapts to different screen sizes
class _ResponsiveLoginLayout extends StatelessWidget {
  final LoginController controller;

  const _ResponsiveLoginLayout({required this.controller});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    final bool isSmallScreen = size.height < 600;

    // Use Stack to layer UI elements with fixed positions
    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. Fixed Background - always stays in place
        Positioned.fill(child: _buildBackground()),

        // 2. Scrolling Content
        Positioned.fill(
          child: _buildScrollableContent(
            context,
            isKeyboardVisible,
            isSmallScreen,
          ),
        ),

        // 3. Fixed Language Selector - always stays in place
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20, right: 20),
            child: _buildLanguageSelector(),
          ),
        ),
      ],
    );
  }

  /// Build scrollable content that adapts to keyboard visibility
  Widget _buildScrollableContent(
    BuildContext context,
    bool isKeyboardVisible,
    bool isSmallScreen,
  ) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              // Adapt logo section based on available space
              if (!isKeyboardVisible || !isSmallScreen)
                _buildLogoSection()
              else
                _buildCompactLogoSection(),

              // Main content card
              _LoginCard(controller: controller),

              // Add bottom padding to ensure form is fully visible with keyboard
              SizedBox(height: isKeyboardVisible ? 20 : 40),

              // Footer with version info - only show when keyboard is not visible
              if (!isKeyboardVisible)
                const Text(
                  'Trimurti Dairy Management v1.0.0',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),

              // Extra space at bottom to account for the FAB
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  /// Build the background gradient with subtle pattern
  Widget _buildBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppTheme.darkGreen.withAlpha(242), AppTheme.primaryGreen],
        ),
      ),
      child: IgnorePointer(
        // Prevents background from intercepting gestures
        ignoring: true,
        child: CustomPaint(
          painter: _GradientPatternPainter(),
          size: Size.infinite,
        ),
      ),
    );
  }

  /// Build the logo section for the login screen
  Widget _buildLogoSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 60, bottom: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Logo container with icon
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(38), // 0.15 opacity = 38 alpha
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(26), // 0.1 opacity = 26 alpha
                  blurRadius: 20,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Center(
              child: Icon(Icons.grass_rounded, size: 48, color: Colors.white),
            ),
          ),

          const SizedBox(height: 24),

          // Title and subtitle
          const Text(
            'Trimurti Dairy',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.0,
            ),
          ),

          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(38), // 0.15 opacity = 38 alpha
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Management Portal',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build compact logo section when keyboard is visible
  Widget _buildCompactLogoSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: Row(
        children: [
          // Small logo container
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(38), // 0.15 opacity = 38 alpha
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Icon(Icons.grass_rounded, size: 24, color: Colors.white),
            ),
          ),

          const SizedBox(width: 12),

          // Title and subtitle stacked vertically
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Trimurti Dairy',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const Text(
                'Management Portal',
                style: TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build language selector FAB
  Widget _buildLanguageSelector() {
    return FloatingActionButton.small(
      onPressed: _showLanguageSelector,
      backgroundColor: Colors.white,
      elevation: 4,
      child: const Icon(Icons.language, color: AppTheme.primaryGreen),
    );
  }

  /// Show bottom sheet for language selection
  void _showLanguageSelector() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(
              children: [
                Icon(Icons.language, color: AppTheme.primaryGreen),
                SizedBox(width: 12),
                Text(
                  'Select Language',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            _buildLanguageOption(
              name: 'English',
              code: 'en',
              iconPath: 'assets/images/flags/en.png',
            ),
            _buildLanguageOption(
              name: 'मराठी',
              code: 'mr',
              iconPath: 'assets/images/flags/mr.png',
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  /// Build individual language option
  Widget _buildLanguageOption({
    required String name,
    required String code,
    required String iconPath,
  }) {
    final languageController = Get.find<LanguageController>();

    return Obx(
      () => ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        leading: const CircleAvatar(
          backgroundColor: AppTheme.lightGreyColor,
          child: Icon(Icons.language, color: AppTheme.primaryGreen),
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        trailing: languageController.currentLanguageCode == code
            ? const Icon(Icons.check_circle, color: AppTheme.primaryGreen)
            : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap: () {
          // Change language using the controller
          languageController.changeLanguage(code);
          Get.back();
        },
      ),
    );
  }
}

/// Main login card with form fields and buttons
class _LoginCard extends StatelessWidget {
  final LoginController controller;

  const _LoginCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: controller.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome header
              const Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkGreyColor,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sign in to continue to your account',
                style: TextStyle(color: AppTheme.greyColor, fontSize: 14),
              ),
              const SizedBox(height: 24),

              // Email field
              TextFormField(
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  hintText: 'Enter your admin email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!GetUtils.isEmail(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Password field
              Obx(
                () => TextFormField(
                  controller: controller.passwordController,
                  obscureText: controller.obscurePassword,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your secure password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) => _attemptLogin(),
                ),
              ),

              const SizedBox(height: 12),

              // Remember me and forgot password
              Row(
                children: [
                  // Remember me checkbox
                  Obx(
                    () => Checkbox(
                      value: controller.rememberMe,
                      onChanged: controller.toggleRememberMe,
                      activeColor: AppTheme.primaryGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const Text('Remember me', style: TextStyle(fontSize: 14)),

                  const Spacer(),

                  // Forgot password button
                  TextButton(
                    onPressed: controller.handlePasswordReset,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Sign in button
              Obx(
                () => AnimatedGradientButton(
                  onPressed: controller.isLoading ? null : _attemptLogin,
                  isLoading: controller.isLoading,
                  text: 'Sign In',
                  gradient: const LinearGradient(
                    colors: [AppTheme.darkGreen, AppTheme.primaryGreen],
                  ),
                  height: 54,
                ),
              ),

              const SizedBox(height: 16),

              // Error message box
              Obx(
                () => Visibility(
                  visible: controller.error.isNotEmpty,
                  child: Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            controller.error,
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Security notice
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'Authorized Dairy Personnel Only',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppTheme.greyColor,
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Attempt to login using the controller
  void _attemptLogin() {
    if (controller.formKey.currentState?.validate() ?? false) {
      controller.handleSignIn();
    }
  }
}

/// Custom pattern painter for the background
class _GradientPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
          .withAlpha(26) // 0.1 opacity = 26 alpha
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    // Draw several wave patterns
    for (int i = 0; i < 3; i++) {
      final path = Path();
      final startY = size.height * (0.2 + 0.1 * i);

      path.moveTo(0, startY);

      // Create a flowing wave pattern
      path.quadraticBezierTo(
        size.width * 0.2,
        startY - size.height * 0.05,
        size.width * 0.4,
        startY,
      );

      path.quadraticBezierTo(
        size.width * 0.6,
        startY + size.height * 0.05,
        size.width * 0.8,
        startY,
      );

      path.quadraticBezierTo(
        size.width * 0.9,
        startY - size.height * 0.025,
        size.width,
        startY,
      );

      canvas.drawPath(path, paint);
    }

    // Draw decorative circles
    final circlePaint = Paint()
      ..color = Colors.white
          .withAlpha(18) // 0.07 opacity = 18 alpha
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 0.1),
      20,
      circlePaint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.2),
      30,
      circlePaint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.3, size.height * 0.3),
      15,
      circlePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

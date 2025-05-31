import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import '../controllers/login_controller.dart';
import '../config/app_theme.dart';
import '../widgets/animated_gradient_button.dart';
import '../controllers/language_controller.dart';
import '../l10n/app_localizations.dart';

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
class _ResponsiveLoginLayout extends StatefulWidget {
  final LoginController controller;

  const _ResponsiveLoginLayout({required this.controller});

  @override
  State<_ResponsiveLoginLayout> createState() => _ResponsiveLoginLayoutState();
}

class _ResponsiveLoginLayoutState extends State<_ResponsiveLoginLayout> {
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

        // 3. Fixed Language Selector - moved to top-right corner
        Positioned(
          top: MediaQuery.of(context).padding.top + 16,
          right: 20,
          child: _buildLanguageSelector(),
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
              _LoginCard(controller: widget.controller),

              // Add bottom padding to ensure form is fully visible with keyboard
              SizedBox(height: isKeyboardVisible ? 20 : 40),

              // Footer with version info - only show when keyboard is not visible
              if (!isKeyboardVisible)
                const Text(
                  'Trimurti Dairy Management v1.0.0',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),

              // Bottom spacing
              const SizedBox(height: 40),
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
          Builder(
            builder: (context) => Text(
              AppLocalizations.of(context)?.appTitle ?? 'Trimurti Dairy',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.0,
              ),
            ),
          ),

          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(38), // 0.15 opacity = 38 alpha
              borderRadius: BorderRadius.circular(20),
            ),
            child: Builder(
              builder: (context) => Text(
                AppLocalizations.of(context)?.managementPortal ??
                    'Management Portal',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
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
              Builder(
                builder: (context) => Text(
                  AppLocalizations.of(context)?.appTitle ?? 'Trimurti Dairy',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              Builder(
                builder: (context) => Text(
                  AppLocalizations.of(context)?.managementPortal ??
                      'Management Portal',
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build language selector button for top-right corner
  Widget _buildLanguageSelector() {
    return GetBuilder<LanguageController>(
      builder: (languageController) => Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _showLanguageSelector,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(51), // 0.2 opacity = 51 alpha
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withAlpha(77), // 0.3 opacity = 77 alpha
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(26), // 0.1 opacity = 26 alpha
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.language, color: Colors.white, size: 18),
                const SizedBox(width: 6),
                Text(
                  languageController.currentLanguageCode.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Show dropdown menu for language selection in top-right corner
  void _showLanguageSelector() {
    // Calculate position for top-right corner popup
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double safeAreaTop = MediaQuery.of(context).padding.top;

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        screenWidth - 200, // Right-aligned with some margin
        safeAreaTop + 60, // Below the button with safe area
        20, // Right margin
        screenHeight - 300, // Bottom constraint
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 12,
      color: Colors.white,
      items: [
        // Header item
        PopupMenuItem<String>(
          enabled: false,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen.withAlpha(26), // 0.1 opacity
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.language,
                    color: AppTheme.primaryGreen,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Builder(
                  builder: (context) => Text(
                    AppLocalizations.of(context)?.selectLanguage ??
                        'Select Language',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.darkGreyColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Divider
        PopupMenuItem<String>(
          enabled: false,
          height: 1,
          child: Divider(
            color: AppTheme.lightGreyColor,
            height: 1,
            thickness: 1,
          ),
        ),

        // English option
        _buildPopupLanguageOption(
          name: 'English',
          code: 'en',
          nativeName: 'English',
          flag: '🇺🇸',
        ),

        // Marathi option
        _buildPopupLanguageOption(
          name: 'मराठी',
          code: 'mr',
          nativeName: 'Marathi',
          flag: '🇮🇳',
        ),
      ],
    ).then((selectedLang) {
      if (selectedLang != null) {
        final languageController = Get.find<LanguageController>();
        languageController.changeLanguage(selectedLang);
      }
    });
  }

  /// Build individual popup language option with enhanced design
  PopupMenuItem<String> _buildPopupLanguageOption({
    required String name,
    required String code,
    required String nativeName,
    required String flag,
  }) {
    return PopupMenuItem<String>(
      value: code,
      child: GetBuilder<LanguageController>(
        builder: (languageController) {
          final bool isSelected =
              languageController.currentLanguageCode == code;

          return Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.primaryGreen.withAlpha(26) // 0.1 opacity
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                // Flag container
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.primaryGreen.withAlpha(77) // 0.3 opacity
                          : Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(flag, style: const TextStyle(fontSize: 16)),
                  ),
                ),

                const SizedBox(width: 12),

                // Language info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: isSelected
                              ? AppTheme.primaryGreen
                              : AppTheme.darkGreyColor,
                        ),
                      ),
                      if (name != nativeName)
                        Text(
                          nativeName,
                          style: TextStyle(
                            fontSize: 11,
                            color: AppTheme.greyColor,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ],
                  ),
                ),

                // Selection indicator
                if (isSelected)
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
              ],
            ),
          );
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
      color: Colors.transparent, // Make card transparent to show the gradient
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.white.withAlpha(250),
              Colors.grey.shade50.withAlpha(240),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: controller.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome header
                Builder(
                  builder: (context) => Text(
                    AppLocalizations.of(context)?.welcomeBack ?? 'Welcome Back',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkGreyColor,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Builder(
                  builder: (context) => Text(
                    AppLocalizations.of(context)?.signInContinue ??
                        'Sign in to continue to your account',
                    style: const TextStyle(
                      color: AppTheme.greyColor,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Email field
                Builder(
                  builder: (context) => TextFormField(
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autocorrect: false,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                    decoration: InputDecoration(
                      labelText:
                          AppLocalizations.of(context)?.emailAddress ??
                          'Email Address',
                      hintText:
                          AppLocalizations.of(context)?.enterEmail ??
                          'Enter your admin email',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)?.emailRequired ??
                            'Please enter your email';
                      }
                      if (!GetUtils.isEmail(value)) {
                        return AppLocalizations.of(context)?.emailInvalid ??
                            'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Password field
                Obx(
                  () => TextFormField(
                    controller: controller.passwordController,
                    obscureText: controller.obscurePassword,
                    textInputAction: TextInputAction.done,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import '../controllers/login_controller.dart';
import '../config/app_theme.dart';
import '../widgets/animated_gradient_button.dart';

/// Login screen for dairy owner authentication
/// This screen provides authentication for admin users only
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Scroll controller to handle keyboard appearance
  final ScrollController _scrollController = ScrollController();

  // Focus nodes for form fields to track currently focused field
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  // Height of the white background container
  double _whiteContainerHeight = 500;

  @override
  void initState() {
    super.initState();

    // Add listeners to focus nodes to scroll to fields when they gain focus
    _emailFocusNode.addListener(_handleFocusChange);
    _passwordFocusNode.addListener(_handleFocusChange);

    // Calculate appropriate white container height based on screen size
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _whiteContainerHeight = MediaQuery.of(context).size.height * 0.65;
      });
    });
  }

  @override
  void dispose() {
    // Clean up controllers and focus nodes
    _scrollController.dispose();
    _emailFocusNode.removeListener(_handleFocusChange);
    _passwordFocusNode.removeListener(_handleFocusChange);
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  // Handle focus changes to scroll to the currently focused field
  void _handleFocusChange() {
    if (_emailFocusNode.hasFocus || _passwordFocusNode.hasFocus) {
      // Add a slight delay to ensure the keyboard is fully visible
      Future.delayed(const Duration(milliseconds: 300), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _emailFocusNode.hasFocus ? 150 : 220,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Initialize controller with unique tag and permanent retention
    final LoginController controller = Get.put(
      LoginController(),
      tag: 'login_controller',
      permanent: true,
    );

    // Calculate screen size
    final screenSize = MediaQuery.of(context).size;
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: GestureDetector(
        // Dismiss keyboard when tapping outside of text fields
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          // Keep resizeToAvoidBottomInset false to prevent UI shifting
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              // Background with gradient
              _buildBackground(context),

              // Login Content with improved scrolling
              SafeArea(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight:
                          MediaQuery.of(context).size.height -
                          MediaQuery.of(context).padding.top,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo and header section - smaller when keyboard is visible
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: keyboardVisible
                              ? screenSize.height * 0.15
                              : null,
                          child: keyboardVisible
                              ? _buildCompactHeader()
                              : _buildHeaderSection(),
                        ),

                        // Login form
                        _buildLoginForm(controller),
                      ],
                    ),
                  ),
                ),
              ),

              // Language selector button - small flag button at the bottom corner
              Positioned(
                bottom: 16,
                right: 16,
                child: _buildLanguageSelector(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a compact header when keyboard is visible
  Widget _buildCompactHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 5),
      child: Row(
        children: [
          // Logo container
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.grass_rounded,
              size: 24,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          // App title
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Trimurti Dairy',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Text(
                'Management Portal',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the background with gradient and pattern overlay
  Widget _buildBackground(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    // Adjust white container height when keyboard is visible
    final whiteContainerHeight = isKeyboardVisible
        ? screenSize.height * 0.75
        : _whiteContainerHeight;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF2C8D3D), // Dark green
            Color(0xFF4CAF50), // Primary green
          ],
          stops: [0.0, 0.7],
        ),
      ),
      child: Stack(
        children: [
          // Curved patterns
          Positioned.fill(child: CustomPaint(painter: CurvedPatternPainter())),

          // White bottom section - responsive height
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: 0,
            left: 0,
            right: 0,
            height: whiteContainerHeight,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the header section with logo and title
  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 20),
      child: Column(
        children: [
          // Logo container
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.grass_rounded,
              size: 50,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 20),

          // App title
          const Text(
            'Trimurti Dairy',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),

          const SizedBox(height: 6),

          // Subtitle
          const Text(
            'Management Portal',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w300,
              letterSpacing: 1.0,
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// Builds the login form
  Widget _buildLoginForm(LoginController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: controller.formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome text
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Welcome Back',
                  style: AppTheme.headingStyle.copyWith(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sign in to continue managing your dairy business',
                  style: TextStyle(color: AppTheme.greyColor, fontSize: 16),
                ),
                const SizedBox(height: 30),
              ],
            ),

            // Form fields
            Column(
              children: [
                // Email field with animation
                _AnimatedFormField(
                  controller: controller.emailController,
                  labelText: 'Email Address',
                  hintText: 'Enter your admin email',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  focusNode: _emailFocusNode,
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

                // Password field with animation
                Obx(
                  () => _AnimatedFormField(
                    controller: controller.passwordController,
                    labelText: 'Password',
                    hintText: 'Enter your secure password',
                    prefixIcon: Icons.lock_outline,
                    focusNode: _passwordFocusNode,
                    obscureText: controller.obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppTheme.greyColor.withOpacity(0.8),
                      ),
                      onPressed: controller.togglePasswordVisibility,
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
                  ),
                ),
              ],
            ),

            // Remember me and forgot password
            Row(
              children: [
                Obx(
                  () => Row(
                    children: [
                      Transform.scale(
                        scale: 0.9,
                        child: Checkbox(
                          value: controller.rememberMe,
                          onChanged: controller.toggleRememberMe,
                          activeColor: AppTheme.primaryGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const Text(
                        'Remember me',
                        style: TextStyle(
                          color: AppTheme.greyColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                TextButton(
                  onPressed: controller.handlePasswordReset,
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: AppTheme.primaryGreen,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Login button
            Obx(
              () => AnimatedGradientButton(
                onPressed: controller.isLoading
                    ? null
                    : controller.handleSignIn,
                isLoading: controller.isLoading,
                text: 'Sign In',
                gradient: const LinearGradient(
                  colors: [AppTheme.darkGreen, AppTheme.primaryGreen],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Error message area
            Obx(
              () => controller.error.isNotEmpty
                  ? Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              controller.error,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            // Admin notice
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: const Text(
                'Authorized Dairy Personnel Only',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.greyColor,
                  fontStyle: FontStyle.italic,
                  fontSize: 13,
                ),
              ),
            ),

            // Add extra padding at bottom to ensure all content is accessible
            SizedBox(
              height: MediaQuery.of(context).viewInsets.bottom > 0 ? 150 : 10,
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the language selector button
  Widget _buildLanguageSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(
          Icons.language,
          color: AppTheme.primaryGreen,
          size: 22,
        ),
        onPressed: () {
          // Will be implemented with language controller
          Get.bottomSheet(
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Select Language',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  _buildLanguageOption('English', 'en'),
                  _buildLanguageOption('मराठी', 'mr'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Builds a language option item
  Widget _buildLanguageOption(String name, String code) {
    return ListTile(
      title: Text(name),
      onTap: () {
        // Get.find<LanguageController>().changeLanguage(code);
        Get.back();
      },
    );
  }
}

/// Animated form field for enhanced user experience
class _AnimatedFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final IconData prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;

  const _AnimatedFormField({
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(
        color: AppTheme.darkGreyColor,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        hintStyle: TextStyle(color: AppTheme.greyColor.withOpacity(0.7)),
        prefixIcon: Icon(
          prefixIcon,
          color: AppTheme.greyColor.withOpacity(0.8),
          size: 22,
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.grey.shade50,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppTheme.primaryGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.red.shade400, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.red.shade600, width: 2),
        ),
        floatingLabelStyle: const TextStyle(color: AppTheme.primaryGreen),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
      validator: validator,
    );
  }
}

/// Custom painter for creating curved background patterns
class CurvedPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final Path firstWavePath = Path();
    firstWavePath.moveTo(0, size.height * 0.25);

    // Create a flowing wave pattern
    firstWavePath.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.15,
      size.width * 0.5,
      size.height * 0.25,
    );

    firstWavePath.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.35,
      size.width,
      size.height * 0.25,
    );

    canvas.drawPath(firstWavePath, paint);

    // Second wave
    final Path secondWavePath = Path();
    secondWavePath.moveTo(0, size.height * 0.35);

    secondWavePath.quadraticBezierTo(
      size.width * 0.2,
      size.height * 0.45,
      size.width * 0.5,
      size.height * 0.35,
    );

    secondWavePath.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.25,
      size.width,
      size.height * 0.35,
    );

    canvas.drawPath(secondWavePath, paint);

    // Circle elements
    final circlePaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.15, size.height * 0.15),
      30,
      circlePaint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.4),
      25,
      circlePaint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.7, size.height * 0.1),
      15,
      circlePaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

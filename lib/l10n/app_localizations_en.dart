// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Trimurti Dairy';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get signInContinue =>
      'Sign in to continue managing your dairy business';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get enterEmail => 'Enter your admin email';

  @override
  String get password => 'Password';

  @override
  String get enterPassword => 'Enter your secure password';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get signIn => 'Sign In';

  @override
  String get authorizedAccessOnly => 'Authorized Dairy Personnel Only';

  @override
  String get emailRequired => 'Please enter your email';

  @override
  String get emailInvalid => 'Please enter a valid email';

  @override
  String get passwordRequired => 'Please enter your password';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get loginFailed => 'Login Failed';

  @override
  String get passwordReset => 'Password Reset';

  @override
  String get passwordResetSuccess => 'Password reset email sent successfully!';

  @override
  String get resetFailed => 'Reset Failed';

  @override
  String get emailRequiredReset => 'Email Required';

  @override
  String get enterEmailReset => 'Please enter your email address';

  @override
  String get invalidEmail => 'Invalid Email';

  @override
  String get enterValidEmail => 'Please enter a valid email address';

  @override
  String get passwordResetSent => 'Password Reset Email Sent';

  @override
  String passwordResetMessage(Object email) {
    return 'We\'ve sent a password reset email to $email';
  }

  @override
  String get managementPortal => 'Management Portal';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get ok => 'OK';
}

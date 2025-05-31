import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_mr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('mr'),
  ];

  /// The application title
  ///
  /// In en, this message translates to:
  /// **'Trimurti Dairy'**
  String get appTitle;

  /// Welcome message on login screen
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// Subtitle on login screen
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue managing your dairy business'**
  String get signInContinue;

  /// Label for email address field
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// Hint for email address field
  ///
  /// In en, this message translates to:
  /// **'Enter your admin email'**
  String get enterEmail;

  /// Label for password field
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Hint for password field
  ///
  /// In en, this message translates to:
  /// **'Enter your secure password'**
  String get enterPassword;

  /// Label for remember me checkbox
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// Label for forgot password button
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// Label for sign in button
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// Security notice on login screen
  ///
  /// In en, this message translates to:
  /// **'Authorized Dairy Personnel Only'**
  String get authorizedAccessOnly;

  /// Validation message for empty email
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get emailRequired;

  /// Validation message for invalid email format
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get emailInvalid;

  /// Validation message for empty password
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get passwordRequired;

  /// Validation message for password too short
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// Title for login failure message
  ///
  /// In en, this message translates to:
  /// **'Login Failed'**
  String get loginFailed;

  /// Title for password reset dialog
  ///
  /// In en, this message translates to:
  /// **'Password Reset'**
  String get passwordReset;

  /// Success message for password reset email
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent successfully!'**
  String get passwordResetSuccess;

  /// Title for reset failure message
  ///
  /// In en, this message translates to:
  /// **'Reset Failed'**
  String get resetFailed;

  /// Title for email required dialog in password reset
  ///
  /// In en, this message translates to:
  /// **'Email Required'**
  String get emailRequiredReset;

  /// Prompt for email in password reset
  ///
  /// In en, this message translates to:
  /// **'Please enter your email address'**
  String get enterEmailReset;

  /// Title for invalid email dialog
  ///
  /// In en, this message translates to:
  /// **'Invalid Email'**
  String get invalidEmail;

  /// Prompt for valid email
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get enterValidEmail;

  /// Title for password reset email sent dialog
  ///
  /// In en, this message translates to:
  /// **'Password Reset Email Sent'**
  String get passwordResetSent;

  /// Message about password reset email being sent
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a password reset email to {email}'**
  String passwordResetMessage(String email);

  /// Subtitle for the application
  ///
  /// In en, this message translates to:
  /// **'Management Portal'**
  String get managementPortal;

  /// Title for language selection dialog
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// Standard affirmative button text
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'mr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'mr':
      return AppLocalizationsMr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

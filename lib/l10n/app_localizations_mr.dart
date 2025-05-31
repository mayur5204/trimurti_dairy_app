// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get appTitle => 'त्रिमूर्ती डेअरी';

  @override
  String get welcomeBack => 'पुन्हा स्वागत आहे';

  @override
  String get signInContinue =>
      'आपला डेअरी व्यवसाय व्यवस्थापित करण्यासाठी साइन इन करा';

  @override
  String get emailAddress => 'ईमेल पत्ता';

  @override
  String get enterEmail => 'आपला प्रशासक ईमेल प्रविष्ट करा';

  @override
  String get password => 'पासवर्ड';

  @override
  String get enterPassword => 'आपला सुरक्षित पासवर्ड प्रविष्ट करा';

  @override
  String get rememberMe => 'माझी आठवण ठेवा';

  @override
  String get forgotPassword => 'पासवर्ड विसरलात?';

  @override
  String get signIn => 'साइन इन करा';

  @override
  String get authorizedAccessOnly => 'केवळ अधिकृत डेअरी कर्मचारी';

  @override
  String get emailRequired => 'कृपया आपला ईमेल प्रविष्ट करा';

  @override
  String get emailInvalid => 'कृपया वैध ईमेल प्रविष्ट करा';

  @override
  String get passwordRequired => 'कृपया आपला पासवर्ड प्रविष्ट करा';

  @override
  String get passwordTooShort => 'पासवर्ड किमान 6 वर्ण असणे आवश्यक आहे';

  @override
  String get loginFailed => 'लॉगिन अयशस्वी';

  @override
  String get passwordReset => 'पासवर्ड रीसेट';

  @override
  String get passwordResetSuccess => 'पासवर्ड रीसेट ईमेल यशस्वीरित्या पाठवला!';

  @override
  String get resetFailed => 'रीसेट अयशस्वी';

  @override
  String get emailRequiredReset => 'ईमेल आवश्यक आहे';

  @override
  String get enterEmailReset => 'कृपया आपला ईमेल पत्ता प्रविष्ट करा';

  @override
  String get invalidEmail => 'अवैध ईमेल';

  @override
  String get enterValidEmail => 'कृपया वैध ईमेल पत्ता प्रविष्ट करा';

  @override
  String get passwordResetSent => 'पासवर्ड रीसेट ईमेल पाठवला';

  @override
  String passwordResetMessage(Object email) {
    return 'आम्ही $email वर पासवर्ड रीसेट ईमेल पाठवला आहे';
  }

  @override
  String get managementPortal => 'व्यवस्थापन पोर्टल';

  @override
  String get selectLanguage => 'भाषा निवडा';

  @override
  String get ok => 'ठीक आहे';
}

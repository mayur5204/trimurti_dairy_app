import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Localization service for managing app translations
class LocalizationService extends Translations {
  // Default locale
  static const locale = Locale('en', 'US');

  // Fallback locale
  static const fallbackLocale = Locale('en', 'US');

  // Supported languages
  static final supportedLanguages = {
    'en': 'English',
    'mr': 'मराठी', // Marathi
  };

  // Supported locales
  static final locales = [
    const Locale('en', 'US'),
    const Locale('mr', 'IN'),
  ];

  // Keys and translations
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'welcome': 'Welcome',
          // Keys will be automatically loaded from ARB files
        },
        'mr_IN': {
          'welcome': 'स्वागत आहे',
          // Keys will be automatically loaded from ARB files
        },
      };

  // Gets locale from language code
  static Locale getLocaleFromLanguage(String languageCode) {
    if (languageCode == 'en') return const Locale('en', 'US');
    if (languageCode == 'mr') return const Locale('mr', 'IN');

    // Default English locale
    return const Locale('en', 'US');
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Controller for managing application language
class LanguageController extends GetxController {
  // Default language is English
  final RxString _currentLanguage = 'en'.obs;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Available languages
  final Map<String, String> _languages = {
    'en': 'English',
    'mr': 'मराठी', // Marathi
  };

  // Getter for current language code
  String get currentLanguageCode => _currentLanguage.value;

  // Getter for current language name
  String get currentLanguageName =>
      _languages[_currentLanguage.value] ?? 'English';

  // Getter for available languages
  Map<String, String> get languages => _languages;

  @override
  void onInit() {
    super.onInit();
    loadSavedLanguage();
  }

  /// Load the saved language preference
  Future<void> loadSavedLanguage() async {
    try {
      final savedLang = await _storage.read(key: 'language');
      if (savedLang != null && _languages.containsKey(savedLang)) {
        _currentLanguage.value = savedLang;
        await updateLanguage(savedLang);
      }
    } catch (e) {
      debugPrint('Error loading saved language: $e');
    }
  }

  /// Change the application language
  Future<void> changeLanguage(String langCode) async {
    if (_languages.containsKey(langCode)) {
      _currentLanguage.value = langCode;
      await updateLanguage(langCode);
      await saveLanguagePreference(langCode);

      // Refresh the UI
      Get.forceAppUpdate();
    }
  }

  /// Update the GetX locale
  Future<void> updateLanguage(String langCode) async {
    final locale = Locale(langCode);
    await Get.updateLocale(locale);
  }

  /// Save language preference to secure storage
  Future<void> saveLanguagePreference(String langCode) async {
    try {
      await _storage.write(key: 'language', value: langCode);
    } catch (e) {
      debugPrint('Error saving language preference: $e');
    }
  }
}

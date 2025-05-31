import 'package:flutter/material.dart';

class AppTheme {
  // Dairy-themed color palette - Natural, Fresh, Agricultural
  static const Color primaryGreen = Color(0xFF4CAF50); // Fresh green
  static const Color lightGreen = Color(0xFF81C784); // Light fresh green
  static const Color darkGreen = Color(0xFF388E3C); // Deep green
  static const Color milkWhite = Color(0xFFFFFFFE); // Pure milk white
  static const Color creamColor = Color(0xFFFFF8E1); // Cream/butter color
  static const Color farmBlue = Color(0xFF2196F3); // Sky blue
  static const Color lightBlue = Color(0xFF64B5F6); // Light sky blue
  static const Color earthBrown = Color(0xFF8D6E63); // Earth/soil brown
  static const Color backgroundColor = Color(
    0xFFF1F8E9,
  ); // Very light green background
  static const Color greyColor = Color(0xFF6B7280); // Neutral grey
  static const Color darkGreyColor = Color(0xFF2E2E2E); // Dark text
  static const Color lightGreyColor = Color(0xFFF5F5F5); // Light grey

  // Dairy-specific accent colors
  static const Color freshYellow = Color(0xFFFFC107); // Fresh butter yellow
  static const Color naturalBrown = Color(0xFF795548); // Natural brown
  static const Color softPink = Color(0xFFE1BEE7); // Soft dairy pink

  // Gradient colors - Nature inspired
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [lightGreen, primaryGreen, darkGreen],
  );

  // Background pattern gradient - Fresh morning sky
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [lightBlue, farmBlue, primaryGreen],
  );

  // Dairy product gradient - Milk to cream
  static const LinearGradient dairyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [milkWhite, creamColor, Color(0xFFF4F4F4)],
  );

  static ThemeData get theme {
    return ThemeData(
      primarySwatch: createMaterialColor(primaryGreen),
      primaryColor: primaryGreen,
      scaffoldBackgroundColor: backgroundColor,
      fontFamily: 'SF Pro Display',

      // Text Theme for consistent text colors
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: darkGreyColor),
        bodyMedium: TextStyle(color: darkGreyColor),
        bodySmall: TextStyle(color: greyColor),
        titleLarge: TextStyle(color: darkGreyColor),
        titleMedium: TextStyle(color: darkGreyColor),
        titleSmall: TextStyle(color: darkGreyColor),
        labelLarge: TextStyle(color: darkGreyColor),
        labelMedium: TextStyle(color: darkGreyColor),
        labelSmall: TextStyle(color: greyColor),
      ),

      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: darkGreyColor),
        titleTextStyle: TextStyle(
          color: darkGreyColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: milkWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lightGreyColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        labelStyle: TextStyle(
          color: greyColor.withValues(alpha: 0.8),
          fontSize: 16,
        ),
        hintStyle: TextStyle(
          color: greyColor.withValues(alpha: 0.7),
          fontSize: 16,
        ),
        // Add explicit text style for input text
        floatingLabelStyle: const TextStyle(
          color: primaryGreen,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        prefixIconColor: greyColor.withValues(alpha: 0.8),
        suffixIconColor: greyColor.withValues(alpha: 0.8),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: milkWhite,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryGreen,
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryGreen;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(milkWhite),
        side: const BorderSide(color: greyColor, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }

  // Helper method to create MaterialColor from Color
  static MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = (color.r * 255.0).round() & 0xff;
    final int g = (color.g * 255.0).round() & 0xff;
    final int b = (color.b * 255.0).round() & 0xff;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }

    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }

    return MaterialColor(color.toARGB32(), swatch);
  }

  // Text Styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: darkGreyColor,
  );

  static const TextStyle subHeadingStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: greyColor,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: darkGreyColor,
  );

  static const TextStyle captionStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: greyColor,
  );
}

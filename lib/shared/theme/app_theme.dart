import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Warm, friendly light theme: cream surfaces, a terracotta accent, soft
/// rounded shapes, and a serif display face for headlines.
class AppTheme {
  const AppTheme._();

  static const _cream = Color(0xFFF7F1E6);
  static const _card = Color(0xFFFDFAF4);
  static const _terracotta = Color(0xFFD9824F);
  static const _terracottaDark = Color(0xFFB5643A);
  static const _sage = Color(0xFF8FA382);
  static const _textPrimary = Color(0xFF3A322B);
  static const _textSecondary = Color(0xFF8C8479);
  static const _outline = Color(0xFFE7DFD2);

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _terracotta,
      brightness: Brightness.light,
    ).copyWith(
      primary: _terracotta,
      onPrimary: Colors.white,
      secondary: _sage,
      surface: _card,
      onSurface: _textPrimary,
      error: const Color(0xFFC2604A),
      outline: _outline,
    );

    // Fraunces gives the soft, friendly serif look for headlines; body text
    // stays on the default sans so dense/Persian text stays crisp — Flutter
    // falls back to the platform font for glyphs Fraunces doesn't cover.
    final displayFontFamily = GoogleFonts.fraunces().fontFamily;

    final textTheme = Typography.blackMountainView.apply(
      bodyColor: _textPrimary,
      displayColor: _textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _cream,
      textTheme: textTheme.copyWith(
        headlineLarge: textTheme.headlineLarge?.copyWith(
          fontFamily: displayFontFamily,
          fontWeight: FontWeight.w500,
        ),
        headlineMedium: textTheme.headlineMedium?.copyWith(
          fontFamily: displayFontFamily,
          fontWeight: FontWeight.w500,
        ),
        headlineSmall: textTheme.headlineSmall?.copyWith(
          fontFamily: displayFontFamily,
          fontWeight: FontWeight.w500,
        ),
        titleLarge: textTheme.titleLarge?.copyWith(
          fontFamily: displayFontFamily,
          fontWeight: FontWeight.w500,
        ),
        bodyMedium: textTheme.bodyMedium?.copyWith(color: _textSecondary),
        bodySmall: textTheme.bodySmall?.copyWith(color: _textSecondary),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: _textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: _card,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: _outline),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _terracotta,
          foregroundColor: Colors.white,
          disabledBackgroundColor: _terracotta.withValues(alpha: 0.4),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _terracottaDark,
          side: const BorderSide(color: _outline),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _terracottaDark,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _card,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: _outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: _outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: _terracotta, width: 1.5),
        ),
        hintStyle: const TextStyle(color: _textSecondary),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _cream,
        selectedItemColor: _textPrimary,
        unselectedItemColor: _textSecondary,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _terracotta,
        foregroundColor: Colors.white,
      ),
      dividerTheme: const DividerThemeData(color: _outline, space: 1),
    );
  }
}

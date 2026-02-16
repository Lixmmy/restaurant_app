import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Define a nice, modern color palette suitable for a restaurant app
const _primaryColor = Color.fromARGB(
  255,
  115,
  229,
  124,
); // A warm, inviting reddish-pink
const _secondaryColor = Color(0xFFFFB74D); // A complementary warm orange

class AppTheme {
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primaryColor,
      brightness: Brightness.light,
      primary: _primaryColor,
      secondary: _secondaryColor,
      onPrimary: Colors.black,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: TextTheme(
        titleLarge: GoogleFonts.lato(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: colorScheme.onPrimary,
        ),
        titleMedium: GoogleFonts.lato(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: colorScheme.onPrimary,
        ),
        titleSmall: GoogleFonts.lato(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: colorScheme.onPrimary,
        ),
        bodyLarge: GoogleFonts.lato(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: colorScheme.onPrimary,
        ),
        bodyMedium: GoogleFonts.lato(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: colorScheme.onPrimary,
        ),
        bodySmall: GoogleFonts.lato(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: colorScheme.onPrimary,
        ),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.green),
        elevation: 2,
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        labelStyle: TextStyle(color: colorScheme.onSurface),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.onSurface),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.onSurface),
        ),
        prefixIconColor: colorScheme.onSurface,
        suffixIconColor: colorScheme.onSurface,
      ),
    );
  }

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primaryColor,
      brightness: Brightness.dark,
      primary: _primaryColor,
      secondary: _secondaryColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: TextTheme(
        titleLarge: GoogleFonts.lato(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: colorScheme.secondary,
        ),
        titleMedium: GoogleFonts.lato(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: colorScheme.secondary,
        ),
        titleSmall: GoogleFonts.lato(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: colorScheme.secondary,
        ),
        bodyLarge: GoogleFonts.lato(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: colorScheme.secondary,
        ),
        bodyMedium: GoogleFonts.lato(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: colorScheme.secondary,
        ),
        bodySmall: GoogleFonts.lato(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: colorScheme.secondary,
        ),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: colorScheme
            .surface, // In dark theme, app bar is often surface color
        elevation: 2,
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          backgroundColor: colorScheme.secondary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.onPrimary),
        ),
        labelStyle: TextStyle(color: colorScheme.onPrimary),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.secondary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.onPrimary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.onPrimary),
        ),
        prefixIconColor: colorScheme.onSurface,
        suffixIconColor: colorScheme.onSurface,
      ),
    );
  }
}

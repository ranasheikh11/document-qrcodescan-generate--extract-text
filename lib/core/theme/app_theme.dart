import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors - ArchivePro Professional Palette
  static const Color primaryNavy = Color(0xFF031632);
  static const Color primaryContainer = Color(0xFF1A2B48);
  static const Color backgroundLight = Color(0xFFF7F9FB);
  static const Color surfaceLow = Color(0xFFF2F4F6);
  static const Color surfaceLowest = Color(0xFFFFFFFF);
  static const Color secondarySlate = Color(0xFF545F72);
  static const Color onSurface = Color(0xFF191C1E);
  static const Color onSurfaceVariant = Color(0xFF44474D);
  static const Color primaryContainerText = Color(0xFF8293B5);
  static const Color tertiaryAmber = Color(0xFFFFDEAD);
  static const Color errorRed = Color(0xFFBA1A1A);
  static const Color primaryIndigo = Color(0xFF4F46E5);
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color secondaryEmerald = Color(0xFF10B981);

  static List<BoxShadow> premiumShadow = [
    BoxShadow(
      color: const Color(0xFF191C1E).withOpacity(0.06),
      blurRadius: 32,
      offset: const Offset(0, 12),
    ),
  ];

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: primaryNavy,
      onPrimary: Colors.white,
      primaryContainer: primaryContainer,
      onPrimaryContainer: Colors.white,
      secondary: secondarySlate,
      tertiary: tertiaryAmber,
      surface: backgroundLight,
      onSurface: onSurface,
      error: errorRed,
      onError: Colors.white,
      outlineVariant: const Color(0xFFC5C6CE),
    ),
    scaffoldBackgroundColor: backgroundLight,
    textTheme: GoogleFonts.interTextTheme().copyWith(
      displayLarge: GoogleFonts.manrope(
        fontWeight: FontWeight.w800,
        color: primaryNavy,
      ),
      displayMedium: GoogleFonts.manrope(
        fontWeight: FontWeight.w700,
        color: primaryNavy,
      ),
      headlineLarge: GoogleFonts.manrope(
        fontWeight: FontWeight.w800,
        color: primaryNavy,
        letterSpacing: -1.0,
      ),
      headlineMedium: GoogleFonts.manrope(
        fontWeight: FontWeight.w700,
        color: primaryNavy,
      ),
      titleLarge: GoogleFonts.manrope(
        fontWeight: FontWeight.w700,
        color: primaryNavy,
      ),
      titleMedium: GoogleFonts.manrope(
        fontWeight: FontWeight.w600,
        color: primaryNavy,
      ),
      bodyLarge: GoogleFonts.inter(color: onSurfaceVariant, fontSize: 16),
      bodyMedium: GoogleFonts.inter(color: onSurfaceVariant, fontSize: 14),
      labelLarge: GoogleFonts.inter(
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      iconTheme: const IconThemeData(color: primaryNavy),
      titleTextStyle: GoogleFonts.manrope(
        color: primaryNavy,
        fontSize: 24,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: Colors.white,
      onPrimary: primaryNavy,
      primaryContainer: primaryContainer,
      onPrimaryContainer: Colors.white70,
      surface: const Color(0xFF0F172A),
      background: const Color(0xFF020617),
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
      displayLarge: GoogleFonts.manrope(
        fontWeight: FontWeight.w800,
        color: Colors.white,
      ),
      headlineLarge: GoogleFonts.manrope(
        fontWeight: FontWeight.w800,
        color: Colors.white,
      ),
      titleLarge: GoogleFonts.manrope(
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// LibasAI design tokens — mirrors the design handoff spec.
class AppColors {
  static const bg = Color(0xFFF7EDDF); // warm cream
  static const surface = Color(0xFFFFFDF9); // card white
  static const ink = Color(0xFF171515); // primary text
  static Color inkSecondary = const Color(0xFF171515).withValues(alpha: 0.60);
  static Color inkFaint = const Color(0xFF171515).withValues(alpha: 0.38);
  static const accent = Color(0xFF8A102B); // maroon
  static const accentPressed = Color(0xFF650B20);
  static const splash = Color(0xFF941528);
  static const mutedRose = Color(0xFFA76F70);
  static const blushRose = Color(0xFFC98F82);
  static const sand = Color(0xFFF2E4D2);
  static Color border = const Color(0xFF171515).withValues(alpha: 0.12);
  static Color hairline = const Color(0xFF171515).withValues(alpha: 0.06);

  static const accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF9F1733), Color(0xFF650B20)],
  );
}

class AppRadius {
  static const card = 16.0;
  static const button = 14.0;
  static const pill = 999.0;
}

class AppShadows {
  static List<BoxShadow> button = [
    BoxShadow(
      color: const Color(0xFF8A102B).withValues(alpha: 0.28),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];
  static List<BoxShadow> soft = [
    BoxShadow(
      color: const Color(0xFF171515).withValues(alpha: 0.06),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];
}

TextStyle heading(double size, {FontWeight weight = FontWeight.w700, Color? color}) =>
    GoogleFonts.playfairDisplay(
      fontSize: size,
      fontWeight: weight,
      height: 1.22,
      color: color ?? AppColors.ink,
    );

TextStyle body(double size,
        {FontWeight weight = FontWeight.w500, Color? color, double? spacing, double height = 1.5}) =>
    GoogleFonts.manrope(
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: spacing,
      color: color ?? AppColors.ink,
    );

TextStyle overline(double size, {Color? color}) => GoogleFonts.manrope(
      fontSize: size,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.06 * size,
      color: color ?? AppColors.mutedRose,
    );

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.accent,
      primary: AppColors.accent,
      surface: AppColors.surface,
      brightness: Brightness.light,
    ),
    textTheme: GoogleFonts.manropeTextTheme(),
    splashColor: AppColors.accent.withValues(alpha: 0.08),
  );
  return base;
}

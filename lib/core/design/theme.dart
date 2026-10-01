import 'package:flutter/material.dart';

import 'tokens.dart';

/// Text styles used across both modes. Sizes are logical pixels and are scaled
/// by the user's system font size (we clamp in `app.dart`, never disable).
abstract final class BsText {
  static TextStyle sans(
    double size, {
    FontWeight w = FontWeight.w400,
    Color? color,
    double? height,
    double? spacing,
  }) => TextStyle(
    fontFamily: BsFonts.sans,
    fontFamilyFallback: BsFonts.fallback,
    fontSize: size,
    fontWeight: w,
    color: color ?? BsColors.ink,
    height: height ?? 1.3,
    letterSpacing: spacing,
  );

  static TextStyle serif(double size, {Color? color, double height = 1.08}) =>
      TextStyle(
        fontFamily: BsFonts.serif,
        fontFamilyFallback: BsFonts.fallback,
        fontSize: size,
        color: color ?? BsColors.ink,
        height: height,
      );

  /// Small spaced-out label, e.g. "THIS WEEK".
  static TextStyle mono(
    double size, {
    Color? color,
    FontWeight w = FontWeight.w500,
  }) => TextStyle(
    fontFamily: BsFonts.mono,
    fontFamilyFallback: BsFonts.fallback,
    fontSize: size,
    fontWeight: w,
    color: color ?? BsColors.inkFaint,
    letterSpacing: 1.1,
    height: 1.2,
  );
}

ThemeData buildTheme() {
  const scheme = ColorScheme.light(
    primary: BsColors.navy,
    onPrimary: Colors.white,
    secondary: BsColors.amber,
    onSecondary: BsColors.ink,
    error: BsColors.red,
    onError: Colors.white,
    surface: BsColors.paper,
    onSurface: BsColors.ink,
  );
  OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(BsRadius.button),
    borderSide: BorderSide(color: c, width: w),
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: BsColors.paper,
    fontFamily: BsFonts.sans,
    fontFamilyFallback: BsFonts.fallback,
    materialTapTargetSize: MaterialTapTargetSize.padded,
    appBarTheme: const AppBarTheme(
      backgroundColor: BsColors.paper,
      foregroundColor: BsColors.ink,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    dividerTheme: const DividerThemeData(
      color: BsColors.hairline,
      space: 1,
      thickness: 1,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: border(BsColors.hairline),
      enabledBorder: border(BsColors.hairline),
      focusedBorder: border(BsColors.navy, 1.6),
      hintStyle: BsText.sans(15, color: BsColors.inkFaint),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: BsColors.ink,
      contentTextStyle: BsText.sans(14, color: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: BsColors.navy,
    ),
  );
}

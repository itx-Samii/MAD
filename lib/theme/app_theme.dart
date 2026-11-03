import 'package:flutter/material.dart';

abstract final class PortalColors {
  static const ink = Color(0xff2c2540);
  static const primary = Color(0xff6545c1);
  static const background = Color(0xfff8f6fd);
  static const muted = Color(0xff706980);
  static const line = Color(0xffe3ddef);
  static const tint = Color(0xfff0eafa);
  static const gradientStart = Color(0xff5636a6);
  static const gradientEnd = Color(0xff8463d7);
  static const expandedStart = Color(0xff432480);
  static const expandedEnd = Color(0xff6c4cbd);
  static const cardShadow = Color(0x266545c1);
  static const onPrimary = Color(0xffeee7ff);
  static const error = Color(0xffb3261e);
  static const previewBackground = Color(0xffeeebf5);
  static const previewShadow = Color(0x256545c1);
  static const frame = Color(0xff0d1117);
}

abstract final class PortalTheme {
  static BoxDecoration cardDecoration({bool highlighted = false}) =>
      BoxDecoration(
        color: highlighted ? PortalColors.tint : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: PortalColors.line),
      );

  static OutlineInputBorder inputBorder([
    Color color = PortalColors.line,
    double width = 1,
  ]) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: color, width: width),
  );

  static ThemeData get data => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: PortalColors.background,
    colorScheme: ColorScheme.fromSeed(seedColor: PortalColors.primary).copyWith(
      primary: PortalColors.primary,
      onPrimary: Colors.white,
      primaryContainer: PortalColors.tint,
      onPrimaryContainer: PortalColors.ink,
      surface: Colors.white,
      onSurface: PortalColors.ink,
      onSurfaceVariant: PortalColors.muted,
      outline: PortalColors.line,
      error: PortalColors.error,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: PortalColors.primary,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        color: PortalColors.primary,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: PortalColors.line),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
      prefixIconColor: PortalColors.primary,
      labelStyle: const TextStyle(color: PortalColors.muted, fontSize: 14),
      hintStyle: const TextStyle(color: PortalColors.muted, fontSize: 13),
      errorMaxLines: 2,
      border: inputBorder(),
      enabledBorder: inputBorder(),
      focusedBorder: inputBorder(PortalColors.primary, 2),
      errorBorder: inputBorder(PortalColors.error),
      focusedErrorBorder: inputBorder(PortalColors.error, 2),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(64, 52),
        backgroundColor: PortalColors.primary,
        foregroundColor: Colors.white,
        disabledBackgroundColor: PortalColors.primary,
        disabledForegroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(48, 48),
        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(minimumSize: const Size(48, 48)),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: PortalColors.primary,
      selectionColor: Color(0x336545c1),
      selectionHandleColor: PortalColors.primary,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: PortalColors.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}

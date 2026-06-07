import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  static const blue = Color(0xFF0878FF);
  static const red = Color(0xFFFF101E);
  static const green = Color(0xFF10BF55);
  static const violet = Color(0xFF7A4DFF);
  static const ink = Color(0xFF111827);
  static const muted = Color(0xFF657085);
  static const line = Color(0xFFDCE5F0);
  static const glass = Color(0xAFFFFFFF);
  static const white = Color(0xFFFFFFFF);
  static const bg = Color(0xFFF7FAFF);
  static const detailBg = Color(0xFFF5F5F5);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: bg,
      fontFamily: 'Roboto',
      colorScheme: ColorScheme.fromSeed(
        seedColor: blue,
        primary: blue,
        secondary: red,
        surface: bg,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      inputDecorationTheme: InputDecorationTheme(border: InputBorder.none),
    );
  }

  static TextStyle get hero => TextStyle(
    fontSize: 51,
    height: 0.98,
    fontWeight: FontWeight.w800,
    letterSpacing: 0,
    color: blue,
  );

  static TextStyle get h1 => TextStyle(
    fontSize: 32,
    height: 1.04,
    fontWeight: FontWeight.w800,
    letterSpacing: 0,
    color: ink,
  );

  static TextStyle get h2 => TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    color: ink,
  );

  static TextStyle get body => TextStyle(
    fontSize: 14,
    height: 1.42,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: muted,
  );

  static TextStyle get label => TextStyle(
    fontSize: 11,
    height: 1.1,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    color: blue,
  );
}

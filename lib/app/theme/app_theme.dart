import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class C {
  static const g700 = Color(0xFFC49A00);
  static const g600 = Color(0xFFD4AA10);
  static const g500 = Color(0xFFE8C020);
  static const g400 = Color(0xFFF0CE40);
  static const g300 = Color(0xFFF5DC70);
  static const g200 = Color(0xFFFAEAA0);
  static const g100 = Color(0xFFFDF3CC);
  static const g50 = Color(0xFFFEF9E7);
  static const s900 = Color(0xFF141414);
  static const s800 = Color(0xFF1E1E1E);
  static const s750 = Color(0xFF252525);
  static const s700 = Color(0xFF2E2E2E);
  static const s600 = Color(0xFF424242);
  static const s500 = Color(0xFF757575);
  static const s400 = Color(0xFFBDBDBD);
  static const s300 = Color(0xFFE0E0E0);
  static const s200 = Color(0xFFEEEEEE);
  static const s100 = Color(0xFFF5F5F5);
  static const s50 = Color(0xFFFAFAFA);
  static const green = Color(0xFF2E7D32);
  static const greenBg = Color(0xFFE8F5E9);
  static const red = Color(0xFFC62828);
  static const redBg = Color(0xFFFFEBEE);
  static const orange = Color(0xFFE65100);
  static const orangeBg = Color(0xFFFFF3E0);
  static const teal = Color(0xFF00695C);
  static const tealBg = Color(0xFFE0F2F1);
  static const indigo = Color(0xFF283593);
  static const indigoBg = Color(0xFFE8EAF6);
}

class AppTheme {
  static TextTheme _t(Color c) =>
      GoogleFonts.poppinsTextTheme().apply(bodyColor: c, displayColor: c);

  static final light = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: C.g700,
      secondary: C.g500,
      surface: Colors.white,
      background: C.s100,
      onPrimary: Colors.white,
      onSurface: C.s900,
    ),
    scaffoldBackgroundColor: C.s100,
    textTheme: _t(C.s900),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      iconTheme: const IconThemeData(color: C.s900),
      titleTextStyle: GoogleFonts.poppins(
          color: C.s900, fontSize: 18, fontWeight: FontWeight.w600),
    ),
    // cardTheme: CardTheme(
    //   color: Colors.white, elevation: 0, margin: EdgeInsets.zero,
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: C.s200)),
    // ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: C.s100,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: C.g700, width: 1.5)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: C.red)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: C.red, width: 1.5)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      labelStyle: GoogleFonts.poppins(color: C.s500, fontSize: 14),
      errorStyle: GoogleFonts.poppins(fontSize: 12, color: C.red),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: C.g700,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle:
            GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),
  );

  static final dark = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: C.g400,
      secondary: C.g300,
      surface: C.s800,
      background: C.s900,
      onPrimary: C.s900,
      onSurface: C.s200,
    ),
    scaffoldBackgroundColor: C.s900,
    textTheme: _t(C.s200),
    appBarTheme: AppBarTheme(
      backgroundColor: C.s800,
      elevation: 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      iconTheme: const IconThemeData(color: C.s200),
      titleTextStyle: GoogleFonts.poppins(
          color: C.s200, fontSize: 18, fontWeight: FontWeight.w600),
    ),
    // cardTheme: CardTheme(
    //   color: C.s750, elevation: 0, margin: EdgeInsets.zero,
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: C.s700)),
    // ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: C.s750,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: C.g400, width: 1.5)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: C.red)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      labelStyle: GoogleFonts.poppins(color: C.s500, fontSize: 14),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: C.g600,
        foregroundColor: C.s900,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle:
            GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),
  );

  static get darkCard => null;

  static get goldColor => null;

  static Color? get primaryColor => null;

  static get accentColor => null;

  static get silver100 => null;

  static get darkBorder => null;

  static Color? get gold700 => null;

  static get gold600 => null;

  static Color? get success => null;

  static Color? get teal => null;

  static Color? get indigo => null;

  static Color? get white => null;

  static Color? get danger => null;
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const bgGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[Color(0xffD1E2F7), Color(0xffFFFFFF)],
  );

  static const alert = Color(0xffF24D72);
  static const fail = Color(0xffE90033);
  static const success = Color(0xff488333);
  static const primary = Color(0xff4083B9);
  static const lightGrey = Color(0xffAAB5CF);
  static const darkGrey = Color(0xff3A3A3A);
  static const containerColor = Color(0xffFFFFFF);
  static const borderGrey = Color(0xffDEE3EF);

  static final mainFont = GoogleFonts.montserrat;
  static final altFont = GoogleFonts.inter;

  static ThemeData get theme => ThemeData(
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: primary,
      onPrimary: Colors.white,
      secondary: success,
      onSecondary: Colors.white,
      error: alert,
      onError: Colors.white,
      surface: containerColor,
      onSurface: darkGrey,
    ),
    textTheme: TextTheme(
      headlineLarge: mainFont(
        fontWeight: FontWeight.w700,
        fontSize: 15,
        color: darkGrey,
      ),
      headlineMedium: mainFont(
        fontWeight: FontWeight.w700,
        fontSize: 14,
        color: darkGrey,
      ),
      headlineSmall: mainFont(
        fontWeight: FontWeight.w700,
        fontSize: 14.27,
        color: darkGrey,
      ),
      bodyMedium: mainFont(
        fontWeight: FontWeight.w400,
        fontSize: 13,
        color: darkGrey,
      ),
      bodySmall: altFont(
        fontWeight: FontWeight.w500,
        fontSize: 11,
        color: lightGrey,
      ),
      labelLarge: mainFont(fontWeight: FontWeight.w600, fontSize: 15),
      labelMedium: mainFont(fontWeight: FontWeight.w400, fontSize: 14),
      labelSmall: mainFont(
        fontWeight: FontWeight.w500,
        fontSize: 11,
        color: darkGrey,
      ),
    ),
  );
}

import 'dart:ui' show Color;

import 'package:flutter/material.dart';

class AppColors {
  static final Color primary = Color(0xff347EEB);
  static final Color secondary = Color(0xff09B349);

  static const Color headline = Color(0xFF15284F);
  static const Color subtitle = Color(0xFF15284F);

  static const Color scaffoldLight = Color(0xFFF0F1F5);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color inputFill = Color(0xFFFFFFFF);

  static const Color redColor = Color(0xFFFF441F);
}

class AppTextTheme {
  static const textThemeLight = TextTheme(
    headline1: TextStyle(
        fontSize: 96,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w300,
        color: AppColors.headline,
        letterSpacing: -1.5),
    headline2: TextStyle(
        fontSize: 60,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w300,
        color: AppColors.headline,
        letterSpacing: -0.5),
    headline3: TextStyle(
        fontSize: 48,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w300,
        color: AppColors.headline,
        letterSpacing: 0.0),
    headline4: TextStyle(
        fontSize: 34,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
        color: AppColors.headline,
        letterSpacing: 0.25),
    headline5: TextStyle(
        fontSize: 24,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
        color: AppColors.headline,
        letterSpacing: 0.0),
    headline6: TextStyle(
        fontSize: 20,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
        color: AppColors.headline,
        letterSpacing: 0.15),
    subtitle1: TextStyle(
        fontSize: 16,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
        color: AppColors.subtitle,
        letterSpacing: 0.15),
    subtitle2: TextStyle(
        fontSize: 14,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w500,
        color: AppColors.subtitle,
        letterSpacing: 0.1),
    bodyText1: TextStyle(
        fontSize: 16,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
        color: Colors.black,
        letterSpacing: 0.5),
    bodyText2: TextStyle(
        fontSize: 14,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
        color: Colors.black,
        letterSpacing: 0.25),
    button: TextStyle(
        fontSize: 14,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w500,
        color: Colors.black38,
        letterSpacing: 1.25),
    caption: TextStyle(
        fontSize: 12,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
        color: Colors.black,
        letterSpacing: 0.4),
    overline: TextStyle(
        fontSize: 10,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
        color: Colors.black,
        letterSpacing: 1.5),
  );
}

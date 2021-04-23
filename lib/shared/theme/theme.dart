import 'package:flutter/material.dart';

import 'app_colors.dart';

final lightTheme = ThemeData.light().copyWith(
  visualDensity: VisualDensity.adaptivePlatformDensity,
  scaffoldBackgroundColor: AppColors.scaffoldLight,
  primaryColor: AppColors.primary,
  secondaryHeaderColor: AppColors.secondary,
  textTheme: AppTextTheme.textThemeLight,
  iconTheme: IconThemeData(color: AppColors.primary, size: 28),
  appBarTheme: AppBarTheme(
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black87, size: 28),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: AppColors.primary,
  ),
  inputDecorationTheme: InputDecorationTheme(
      focusColor: AppColors.primary,
      hoverColor: AppColors.primary,
      fillColor: AppColors.inputFill),
  cardColor: AppColors.cardLight,
  brightness: Brightness.light,
);

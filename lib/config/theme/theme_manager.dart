import 'package:daprot_v1/config/theme/colors_manager.dart';
import 'package:daprot_v1/config/theme/text_style_manager.dart';
import 'package:flutter/material.dart';

ColorScheme kColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.light,
  seedColor: ColorsManager.primaryColor,
  secondary: ColorsManager.secondaryColor,
);
ThemeData getApplicationTheme() {
  return ThemeData(
    fontFamily: 'Poppins',
    colorScheme: kColorScheme,
    primaryColor: ColorsManager.primaryColor,
    appBarTheme: const AppBarTheme().copyWith(
      color: kColorScheme.onPrimaryContainer,
      foregroundColor: kColorScheme.onSecondary,
    ),
    textTheme: TextTheme(
      bodyLarge: getExtraBold(
        color: ColorsManager.textColor,
      ),
      displayMedium: getSemiBoldStyle(
        color: ColorsManager.textColor,
      ),
      bodySmall: getLightStyle(
        color: ColorsManager.greyColor,
      ),
    ),
  );
}

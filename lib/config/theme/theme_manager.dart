import 'package:gozip/config/theme/colors_manager.dart';
import 'package:gozip/config/theme/text_style_manager.dart';
import 'package:flutter/material.dart';

ColorScheme kColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.light,
  seedColor: ColorsManager.primaryColor,
  secondary: const Color.fromARGB(237, 143, 75, 232),
);
ThemeData getApplicationTheme() {
  return ThemeData(
    fontFamily: 'Poppins',
    fontFamilyFallback: const ['AppFonts'],
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

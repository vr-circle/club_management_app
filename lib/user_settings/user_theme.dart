import 'package:flutter/material.dart';

class UserThemeSettings {
  UserThemeSettings(
      {ThemeData generalTheme,
      Color personalEventColor,
      Color organizationEventColor})
      : generalTheme = generalTheme ?? ThemeData.dark(),
        personalEventColor = personalEventColor ?? Colors.red,
        organizationEventColor = organizationEventColor ?? Colors.blue;
  ThemeData generalTheme;
  Color personalEventColor;
  Color organizationEventColor;
}

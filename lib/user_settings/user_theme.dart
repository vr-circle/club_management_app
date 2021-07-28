import 'package:flutter/material.dart';

class UserThemeSettings {
  UserThemeSettings()
      : generalTheme = ThemeData.dark(),
        personalEventColor = Colors.red,
        organizationEventColor = Colors.blue;
  ThemeData generalTheme;
  Color personalEventColor;
  Color organizationEventColor;
}

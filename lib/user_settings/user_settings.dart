import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/user_settings/user_theme.dart';

class UserSettings {
  UserSettings({
    @required this.id,
    @required this.name,
    @required this.userThemeSettings,
    @required this.participatingOrganizationIdList,
  });
  final String id;
  String name;
  UserThemeSettings userThemeSettings;
  Color get personalEventColor => userThemeSettings.personalEventColor;
  Color get organizationEventColor => userThemeSettings.organizationEventColor;
  List<String> participatingOrganizationIdList;
}

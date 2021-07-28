import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/user_settings/user_theme.dart';

class UserSettings {
  UserSettings(
      {@required this.id,
      @required this.name,
      @required this.userThemeSettings});
  final String id;
  String name;
  List<String> participatingOrganizationIdList;
  UserThemeSettings userThemeSettings;
}

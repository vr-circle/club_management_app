import 'package:flutter/cupertino.dart';

class UserTheme {
  Color appTheme;
}

class Club {
  String id;
  String name;
  List<String> members;
}

class UserSetting {
  String userName;
  List<Club> clubIds;
  UserTheme theme;
}

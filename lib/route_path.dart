import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class RoutePath {}

class LoginPath extends RoutePath {
  static const String location = '/login';
}

class HomePath extends RoutePath {
  static const int index = 0;
  static const String location = '/home';
}

class SchedulePath extends RoutePath {
  static const int index = 1;
  static const String location = '/schedule';
}

class ScheduleListViewPath extends RoutePath {
  ScheduleListViewPath(this.day);
  String get location =>
      '${SchedulePath.location}/${this.day.year}-${this.day.month}';
  final DateTime day;
}

class ScheduleAddPath extends RoutePath {
  ScheduleAddPath(this.day);
  String get location =>
      '${SchedulePath.location}/${this.day.year}-${this.day.month}/add';
  final DateTime day;
}

class ScheduleDetailPath extends RoutePath {
  ScheduleDetailPath(this.id);
  static const String location = '';
  final String id;
}

class TodoPath extends RoutePath {
  static const int index = 2;
  TodoPath({@required this.targetId});
  static const String location = '/todo';
  final String targetId;
}

class SearchPath extends RoutePath {
  static const int index = 3;
  SearchPath({@required this.searchingParam});
  static const String location = '/search';
  final String searchingParam;
}

class SettingPath extends RoutePath {
  static const int index = 4;
  static const String location = '/setting';
}

class OrganizationDetailPath extends RoutePath {
  OrganizationDetailPath(this.id);
  final String id;
  static const String location = '/organization';
}

class UserSettingPath extends RoutePath {
  static const String location = '/setting/user';
}

class DummyPath extends RoutePath {
  static const String location = '/dummy';
}

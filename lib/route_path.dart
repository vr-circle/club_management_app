import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/shell_pages/schedule/schedule.dart';

abstract class RoutePath {}

class LoginPath extends RoutePath {
  static const String location = '/login';
}

class SignUpPath extends RoutePath {
  static const String location = '/signup';
}

class HomePath extends RoutePath {
  static const int index = 0;
  static const String location = '/home';
}

class SchedulePath extends RoutePath {
  SchedulePath({@required this.targetDate});
  static const int index = 1;
  static const String location = '/schedule';
  DateTime targetDate;
}

class ScheduleListViewPath extends RoutePath {
  ScheduleListViewPath({@required this.day});
  String get location =>
      '${SchedulePath.location}/${this.day.year}-${this.day.month}';
  final DateTime day;
}

class ScheduleAddPath extends RoutePath {
  ScheduleAddPath(this.day);
  final DateTime day;
}

class ScheduleDetailPath extends RoutePath {
  // /schedule/detail/year-month-day/organizationId/groupName/scheduleId
  ScheduleDetailPath(
      {@required this.day,
      @required this.organizationId,
      @required this.groupName,
      @required this.scheduleId});
  static const String location = '';
  final DateTime day;
  final String organizationId;
  final String groupName;
  final String scheduleId;
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

class SettingOrganizationPath extends RoutePath {
  SettingOrganizationPath(this.id);
  static const String location = '/organization';
  final String id;
}

class SettingAddOrganizationPath extends RoutePath {
  SettingAddOrganizationPath();
  static const String lcoation =
      '${SettingPath.location}${SettingOrganizationPath.location}/add';
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

import 'package:flutter_application_1/app_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/home/home.dart';
import 'package:flutter_application_1/pages/schedule/schedule.dart';
import 'package:flutter_application_1/pages/schedule/schedule_details.dart';
import 'package:flutter_application_1/pages/schedule/schedule_list_on_day.dart';
import 'package:flutter_application_1/pages/schedule/schedule_page.dart';
import 'package:flutter_application_1/pages/search/search_option_page.dart';
import 'package:flutter_application_1/pages/search/search_page.dart';
import 'package:flutter_application_1/pages/todo/todo_page.dart';
import 'package:flutter_application_1/pages/user_settings/settings.dart';
import 'package:flutter_application_1/pages/user_settings/user_account_view.dart';
import 'animation_pages/fade_animation_page.dart';

class NavigationState {
  String name;
  String location;
  Icon icon;
  RoutePath Function(MyAppState appState) getRoutePath;
  void Function(MyAppState appState) initAppState;
  void Function(MyAppState appState) onPopPage;
  List<Page> Function(MyAppState appState) getPages;
  NavigationState({
    @required this.name,
    @required this.icon,
    @required this.location,
    @required this.getRoutePath,
    @required this.initAppState,
    @required this.onPopPage,
    @required this.getPages,
  });
}

final List<NavigationState> navigationList = [
  NavigationState(
      name: 'Home',
      icon: Icon(Icons.home),
      location: '/home',
      getRoutePath: (appState) {
        return HomePath();
      },
      initAppState: (appState) {},
      onPopPage: (appState) {},
      getPages: (appState) {
        return [
          FadeAnimationPage(
              child: HomePage(
            appState: appState,
          ))
        ];
      }),
  NavigationState(
      name: 'Schedule',
      icon: Icon(Icons.calendar_today),
      location: '/schedule',
      getRoutePath: (appState) {
        if (appState.selectedDay != null) {
          if (appState.selectedSchedule != null) {
            return ScheduleDetailPath(
                appState.selectedDay, appState.selectedSchedule.id);
          } else {
            return ScheduleListViewPath(appState.selectedDay);
          }
        }
        return SchedulePath();
      },
      initAppState: (appState) {
        appState.selectedDay = null;
        appState.selectedSchedule = null;
      },
      onPopPage: (appState) {
        if (appState.selectedDay != null) {
          if (appState.selectedSchedule != null) {
            appState.selectedSchedule = null;
          } else {
            appState.selectedDay = null;
            appState.selectedSchedule = null;
          }
        } else {
          if (appState.selectedSchedule != null) {
            appState.selectedSchedule = null;
          } else {
            appState.selectedDay = null;
            appState.selectedSchedule = null;
          }
        }
      },
      getPages: (appState) {
        return [
          FadeAnimationPage(
              child: SchedulePage(
                appState: appState,
                handleChangePage: (DateTime day) {
                  appState.selectedCalendarPage = day;
                },
                handleOpenList: (DateTime day) {
                  appState.selectedDay = day;
                },
                scheduleCollection: appState.scheduleCollection,
              ),
              key: ValueKey('SchedulePage')),
          if (appState.selectedDay != null)
            MaterialPage(
                child: ScheduleListOnDay(
                    handleOpenScheduleDetails: (Schedule schedule) {
                      appState.selectedSchedule = schedule;
                    },
                    targetDate: appState.selectedDay,
                    addSchedule: appState.addSchedule,
                    deleteSchedule: appState.deleteSchedule,
                    schedules: appState.getScheduleList(appState.selectedDay))),
          if (appState.selectedSchedule != null)
            MaterialPage(
                child: ScheduleDetails(
              schedule: appState.selectedSchedule,
              deleteSchedule: appState.deleteSchedule,
            )),
        ];
      }),
  NavigationState(
      name: 'Todo',
      icon: Icon(Icons.task_outlined),
      location: '/todo',
      getRoutePath: (appState) {
        return TodoPath(appState.selectedTabInTodo);
      },
      initAppState: (appState) {
        appState.selectedTabInTodo = 0;
      },
      onPopPage: (appState) {
        appState.selectedTabInTodo = 0;
      },
      getPages: (appState) {
        return [
          FadeAnimationPage(
              child: TodoPage(
                appState: appState,
              ),
              key: ValueKey('TodoPage'))
        ];
      }),
  NavigationState(
      name: 'Search',
      icon: Icon(Icons.search),
      location: '/search',
      getRoutePath: (appState) {
        return SearchPath(appState.searchingParams);
      },
      initAppState: (appState) {
        appState.selectedSearchingClubId = null;
        appState.isSearchingMode = false;
      },
      onPopPage: (appState) {
        appState.selectedSearchingClubId = null;
        appState.isSearchingMode = false;
      },
      getPages: (appState) {
        return [
          FadeAnimationPage(child: SearchPage(), key: ValueKey('SearchPage')),
          if (appState.isSearchingMode)
            MaterialPage(
                key: ValueKey('SearchOptionPage'),
                child: SearchOptionPage(
                  appState: appState,
                )),
        ];
      }),
  NavigationState(
      name: 'Settings',
      icon: Icon(Icons.settings),
      location: '/settings',
      getRoutePath: (appState) {
        if (appState.isSelectedUserSettings) {
          return UserSettingsPath();
        }
        return SettingsPath();
      },
      initAppState: (appState) {
        appState.isSelectedUserSettings = false;
      },
      onPopPage: (appState) {
        appState.isSelectedUserSettings = false;
      },
      getPages: (appState) {
        return [
          FadeAnimationPage(
            child: SettingsPage(
                handleOpenUserSettings: () {
                  appState.isSelectedUserSettings = true;
                },
                signOut: appState.signOut),
            key: ValueKey('SettingsPage'),
          ),
          if (appState.isSelectedUserSettings)
            MaterialPage(
                key: ValueKey('UserSettingPage'),
                child: UserAccountView(
                  user: appState.getCurrentUser(),
                ))
        ];
      }),
];

abstract class RoutePath {}

class LoginPath extends RoutePath {}

class HomePath extends RoutePath {
  static final int index = 0;
}

class SchedulePath extends RoutePath {
  static final int index = 1;
}

class ScheduleDetailPath extends RoutePath {
  final String id;
  final DateTime day;
  ScheduleDetailPath(this.day, this.id);
}

class ScheduleListViewPath extends RoutePath {
  final DateTime day;
  ScheduleListViewPath(this.day);
}

class TodoPath extends RoutePath {
  static final int index = 2;
  final int targetTabIndex;
  TodoPath(this.targetTabIndex);
}

class TodoAddPath extends RoutePath {
  final int targetTabIndex;
  TodoAddPath(this.targetTabIndex);
}

class GroupViewPath extends RoutePath {
  static final int index = 3;
}

class SearchPath extends RoutePath {
  final List<String> keywords;
  SearchPath(this.keywords);
}

class SettingsPath extends RoutePath {
  static final int index = 4;
}

class UserSettingsPath extends RoutePath {}

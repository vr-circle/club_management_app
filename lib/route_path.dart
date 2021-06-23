import 'package:flutter_application_1/app_state.dart';
import 'package:flutter_application_1/schedule/schedule.dart';
import 'package:flutter_application_1/schedule/schedule_details.dart';
import 'package:flutter_application_1/schedule/schedule_list_on_day.dart';
import 'package:flutter_application_1/schedule/schedule_page.dart';
import 'package:flutter_application_1/search/search.dart';
import 'package:flutter_application_1/todo/todo.dart';
import 'package:flutter_application_1/user_settings/settings.dart';
import 'package:flutter_application_1/user_settings/user_account_view.dart';

import 'main.dart';
import 'package:flutter/material.dart';
import 'home/home.dart';

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
        return [FadeAnimationPage(child: HomePage())];
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
          }
        } else {
          appState.selectedDay = null;
          appState.selectedSchedule = null;
        }
      },
      getPages: (appState) {
        return [
          FadeAnimationPage(
              child: SchedulePage(
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
        return TodoPath();
      },
      initAppState: (appState) {},
      onPopPage: (appState) {},
      getPages: (appState) {
        return [
          FadeAnimationPage(child: TodoPage(), key: ValueKey('TodoPage'))
        ];
      }),
  NavigationState(
      name: 'Search',
      icon: Icon(Icons.search),
      location: '/search',
      getRoutePath: (appState) {
        return SearchPath();
      },
      initAppState: (appState) {},
      onPopPage: (appState) {},
      getPages: (appState) {
        return [
          FadeAnimationPage(child: SearchPage(), key: ValueKey('SearchPage'))
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

class HomePath extends RoutePath {}

class SchedulePath extends RoutePath {}

class ScheduleDetailPath extends RoutePath {
  final String id;
  final DateTime day;
  ScheduleDetailPath(this.day, this.id);
}

class ScheduleListViewPath extends RoutePath {
  final DateTime day;
  ScheduleListViewPath(this.day);
}

class TodoPath extends RoutePath {}

class SearchPath extends RoutePath {}

class SettingsPath extends RoutePath {}

class UserSettingsPath extends RoutePath {}

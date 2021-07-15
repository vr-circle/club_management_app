import 'package:flutter_application_1/app_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/shell_pages/home/home.dart';
import 'package:flutter_application_1/shell_pages/schedule/schedule.dart';
import 'package:flutter_application_1/shell_pages/schedule/schedule_details.dart';
import 'package:flutter_application_1/shell_pages/schedule/schedule_list_on_day.dart';
import 'package:flutter_application_1/shell_pages/schedule/schedule_page.dart';
import 'package:flutter_application_1/shell_pages/search/organization_details.dart';
import 'package:flutter_application_1/shell_pages/search/search_page.dart';
import 'package:flutter_application_1/shell_pages/todo/todo_page.dart';
import 'package:flutter_application_1/shell_pages/user_settings/settings.dart';
import 'package:flutter_application_1/shell_pages/user_settings/user_account_view.dart';
import 'animation_pages/fade_animation_page.dart';

class NavigationState {
  String name;
  Icon icon;
  RoutePath Function(MyAppState appState) getRoutePath;
  void Function(MyAppState appState) initAppState;
  void Function(MyAppState appState) onPopPage;
  List<Page> Function(MyAppState appState) getPages;
  NavigationState({
    @required this.name,
    @required this.icon,
    @required this.getRoutePath,
    @required this.initAppState,
    @required this.onPopPage,
    @required this.getPages,
  });
}

final List<NavigationState> navigationList = [
  NavigationState(
      name: 'Home',
      icon: const Icon(Icons.home),
      getRoutePath: (appState) {
        return HomePath();
      },
      initAppState: (appState) {},
      onPopPage: (appState) {},
      getPages: (appState) {
        return [
          FadeAnimationPage(child: HomePage(
            handleChangeSelectedIndex: (int index) {
              appState.selectedIndex = index;
            },
          ))
        ];
      }),
  NavigationState(
      name: 'Schedule',
      icon: const Icon(Icons.calendar_today),
      getRoutePath: (appState) {
        if (appState.selectedDay != null) {
          if (appState.isOpeningAddSchedulePage) {
            return ScheduleAddPage();
          }
          if (appState.selectedSchedule != null) {
            return ScheduleDetailPath(
                appState.selectedDay, appState.selectedSchedule.id);
          }
          return ScheduleListViewPath(appState.selectedDay);
        }
        return SchedulePath();
      },
      initAppState: (appState) {
        appState.selectedDay = null;
        appState.selectedSchedule = null;
        appState.isOpeningAddSchedulePage = false;
      },
      onPopPage: (appState) {
        if (appState.selectedDay != null) {
          if (appState.isOpeningAddSchedulePage) {
            appState.isOpeningAddSchedulePage = false;
          } else if (appState.selectedSchedule != null) {
            appState.selectedSchedule = null;
          } else {
            appState.selectedDay = null;
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
              key: ValueKey('SchedulePage'),
              child: SchedulePage(
                handleOpenListPage: (DateTime day) {
                  appState.selectedDay = day;
                },
                handleSelectSchedule: (Schedule schedule) {
                  appState.selectedSchedule = schedule;
                },
              )),
          if (appState.selectedDay != null)
            MaterialPage(
                key: ValueKey('ScheduleList'),
                child: ScheduleListOnDay(
                  handleOpenScheduleDetails: (Schedule schedule) {
                    appState.selectedSchedule = schedule;
                  },
                  targetDate: appState.selectedDay,
                  handleOpenAddPage: () {
                    appState.isOpeningAddSchedulePage = true;
                  },
                )),
          if (appState.selectedSchedule != null)
            MaterialPage(
                key: ValueKey('ScheduleDetails'),
                child: ScheduleDetails(
                  schedule: appState.selectedSchedule,
                  // deleteSchedule: ,
                  handleCloseDetailsPage: () {
                    appState.selectedSchedule = null;
                  },
                )),
        ];
      }),
  NavigationState(
      name: 'Todo',
      icon: const Icon(Icons.task_outlined),
      getRoutePath: (appState) {
        return TodoPath(appState.selectedTabInTodo);
      },
      initAppState: (appState) {
        appState.selectedTabInTodo = '';
        appState.isOpeningAddTodoPage = false;
      },
      onPopPage: (appState) {
        appState.selectedTabInTodo = '';
        appState.isOpeningAddTodoPage = false;
      },
      getPages: (appState) {
        return [
          FadeAnimationPage(
              child: TodoPage(
                appState: appState,
              ),
              key: ValueKey('TodoPage')),
        ];
      }),
  NavigationState(
      name: 'Search',
      icon: Icon(Icons.search),
      getRoutePath: (appState) {
        if (appState.selectedSearchingOrganizationId.isNotEmpty) {
          return OrganizationDetailViewPath(
              appState.selectedSearchingOrganizationId);
        }
        return SearchViewPath(appState.searchingParams);
      },
      initAppState: (appState) {
        appState.selectedSearchingOrganizationId = '';
      },
      onPopPage: (appState) {
        appState.selectedSearchingOrganizationId = '';
      },
      getPages: (appState) {
        return [
          FadeAnimationPage(
            key: ValueKey('SearchPage'),
            child: SearchPage(
              appState: appState,
            ),
          ),
          if (appState.selectedSearchingOrganizationId.isNotEmpty)
            MaterialPage(
                key: ValueKey('OrganizationDetail'),
                child: OrganizationDetailPage(
                  organizationId: appState.selectedSearchingOrganizationId,
                )),
        ];
      }),
  NavigationState(
      name: 'Settings',
      icon: Icon(Icons.settings),
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

class LoginPath extends RoutePath {
  static const String location = 'login';
}

class HomePath extends RoutePath {
  static final int index = 0;
  static const String location = 'home';
}

class SchedulePath extends RoutePath {
  static final int index = 1;
  static const String location = 'schedule';
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

class ScheduleAddPage extends RoutePath {}

class TodoPath extends RoutePath {
  static final int index = 2;
  static const String location = 'todo';
  final String targetTabId;
  TodoPath(this.targetTabId);
}

class TodoAddPath extends RoutePath {
  final String targetTabId;
  TodoAddPath(this.targetTabId);
}

class SearchViewPath extends RoutePath {
  static final int index = 3;
  static const String location = 'search';
  String searchParam;
  SearchViewPath(this.searchParam);
}

class OrganizationDetailViewPath extends RoutePath {
  final String id;
  OrganizationDetailViewPath(this.id);
  static const String location = 'organization';
}

// class SearchPath extends RoutePath {
//   final List<String> keywords;
//   SearchPath(this.keywords);
// }

class SettingsPath extends RoutePath {
  static final int index = 4;
  static const String location = 'settings';
}

class UserSettingsPath extends RoutePath {}

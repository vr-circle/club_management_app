import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_state.dart';
import 'package:flutter_application_1/route_path.dart';
import 'package:flutter_application_1/shell_pages/home/home.dart';
import 'package:flutter_application_1/shell_pages/schedule/schedule_page.dart';
import 'package:flutter_application_1/shell_pages/search/organization_details.dart';
import 'package:flutter_application_1/shell_pages/search/search_page.dart';
import 'package:flutter_application_1/shell_pages/todo/todo_page.dart';
import 'package:flutter_application_1/shell_pages/user_settings/settings.dart';
import 'package:flutter_application_1/shell_pages/user_settings/user_account_view.dart';

class ShellState {
  ShellState(
      {@required this.name,
      @required this.icon,
      @required this.getPages,
      @required this.getRoutePath,
      @required this.onPopPage});
  String name;
  Icon icon;
  List<Page> Function(AppState appState) getPages;
  RoutePath Function(AppState appState) getRoutePath;
  void Function(AppState appState) onPopPage;
}

List<ShellState> shellList = <ShellState>[
  ShellState(
      name: 'Home',
      icon: const Icon(Icons.home),
      getPages: (appState) {
        return [
          MaterialPage(
              child: HomePage(
            appState: appState,
          )),
        ];
      },
      getRoutePath: (appState) {
        return HomePath();
      },
      onPopPage: (appState) {
        //
      }),
  ShellState(
      name: 'Schedule',
      icon: const Icon(Icons.calendar_today),
      getPages: (appState) {
        return [
          MaterialPage(
              child: SchedulePage(
            key: ValueKey('schedule'),
            initFocusDay: DateTime.now(),
            handleChangeCalendarPage: (day) {},
            handleOpenListPage: (day) {},
            handleSelectSchedule: (schedule) {},
          ))
        ];
      },
      getRoutePath: (appState) {
        return SchedulePath();
      },
      onPopPage: (appState) {
        //
      }),
  ShellState(
      name: 'Todo',
      icon: const Icon(Icons.task),
      getPages: (appState) {
        return [
          MaterialPage(
              child: TodoPage(
            key: ValueKey('todo'),
            appState: appState,
          )),
        ];
      },
      getRoutePath: (appState) {
        return TodoPath(targetId: appState.targetTodoTabId);
      },
      onPopPage: (appState) {
        appState.targetTodoTabId = '';
      }),
  ShellState(
      name: 'Search',
      icon: const Icon(Icons.search),
      getPages: (appState) {
        return [
          MaterialPage(
              child: SearchPage(
            key: ValueKey('search'),
            appState: appState,
          )),
          if (appState.targetOrganizationId.isNotEmpty)
            MaterialPage(
                child: OrganizationDetailPage(
                    organizationId: appState.targetOrganizationId)),
        ];
      },
      getRoutePath: (appState) {
        if (appState.targetOrganizationId.isEmpty)
          return SearchPath(searchingParam: appState.searchingParam);
        return OrganizationDetailPath(appState.targetOrganizationId);
      },
      onPopPage: (appState) {
        appState.searchingParam = '';
        appState.targetOrganizationId = '';
      }),
  ShellState(
      name: 'Setting',
      icon: const Icon(Icons.settings),
      getPages: (appState) {
        return [
          MaterialPage(
              key: ValueKey('settings'),
              child: SettingsPage(
                appState: appState,
              )),
          if (appState.isOpenAccountView)
            MaterialPage(
                child: UserAccountView(
              user: appState.user,
            )),
        ];
      },
      getRoutePath: (appState) {
        if (appState.isOpenAccountView) return UserSettingPath();
        return SettingPath();
      },
      onPopPage: (appState) {
        appState.isOpenAccountView = false;
      }),
];
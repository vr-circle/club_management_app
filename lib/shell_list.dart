import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_state.dart';
import 'package:flutter_application_1/route_path.dart';
import 'package:flutter_application_1/shell_pages/home/home.dart';
import 'package:flutter_application_1/shell_pages/schedule/schedule.dart';
import 'package:flutter_application_1/shell_pages/schedule/schedule_add.dart';
import 'package:flutter_application_1/shell_pages/schedule/schedule_details.dart';
import 'package:flutter_application_1/shell_pages/schedule/schedule_list_view_for_day.dart';
import 'package:flutter_application_1/shell_pages/schedule/schedule_page.dart';
import 'package:flutter_application_1/shell_pages/search/organization_details.dart';
import 'package:flutter_application_1/shell_pages/search/search_page.dart';
import 'package:flutter_application_1/shell_pages/todo/todo_page.dart';
import 'package:flutter_application_1/shell_pages/user_settings/setting_add_organization.dart';
import 'package:flutter_application_1/shell_pages/user_settings/setting_organization.dart';
import 'package:flutter_application_1/shell_pages/user_settings/settings.dart';
import 'package:flutter_application_1/shell_pages/user_settings/user_account_view.dart';
import 'package:flutter_application_1/store/store_service.dart';

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
        print('getPages in SchellState');
        return [
          MaterialPage(
              child: SchedulePage(
            key: ValueKey('SchedulePage'),
            appState: appState,
          )),
          if (appState.selectedDayForScheduleList != null)
            MaterialPage(
                child: ScheduleListViewForDay(
              targetDate: appState.selectedDayForScheduleList,
              handleOpenAddPage: () {
                appState.isOpenAddSchedulePage = true;
              },
              handleChangeScheduleDetails: (Schedule schedule) {
                appState.selectedSchedule = schedule;
              },
            )),
          if (appState.selectedDayForScheduleList != null &&
              appState.isOpenAddSchedulePage)
            MaterialPage(
                child: AddSchedulePage(
              targetDate: appState.selectedDayForScheduleList,
              addSchedule: (Schedule newSchedule, String targetId) async {
                await dbService.addSchedule(newSchedule, targetId);
              },
            )),
          if (appState.selectedSchedule != null)
            MaterialPage(
                child: ScheduleDetails(
              schedule: appState.selectedSchedule,
              deleteSchedule: (Schedule targetSchedule) async {
                await dbService.deleteSchedule(targetSchedule);
              },
              handleCloseDetailsPage: () {
                appState.selectedSchedule = null;
              },
            ))
        ];
      },
      getRoutePath: (appState) {
        print('getRoutePath');
        if (appState.selectedDayForScheduleList != null) {
          if (appState.isOpenAddSchedulePage) {
            return ScheduleAddPath(appState.selectedDayForScheduleList);
          } else if (appState.selectedSchedule != null) {
            // todo: change schedulePath -> ScheduleDetailPath
            return SchedulePath(targetDate: appState.targetCalendarMonth);
          } else {
            return ScheduleListViewPath(
                day: appState.selectedDayForScheduleList);
          }
        } else {
          if (appState.selectedSchedule != null) {
            // todo: change schedulePath -> ScheduleDetailPath
            return SchedulePath(targetDate: appState.targetCalendarMonth);
          } else {
            return SchedulePath(targetDate: appState.targetCalendarMonth);
          }
        }
      },
      onPopPage: (appState) {
        if (appState.selectedDayForScheduleList != null) {
          if (appState.isOpenAddSchedulePage) {
            appState.isOpenAddSchedulePage = false;
            return;
          }
          if (appState.selectedSchedule != null) {
            appState.selectedSchedule = null;
          } else {
            appState.selectedDayForScheduleList = null;
          }
        } else {
          if (appState.selectedSchedule != null) {
            appState.selectedSchedule = null;
          }
        }
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
              handleChangeUserAccountName: (String name) async {
                await appState.updateUserDisplayName(name);
              },
              user: appState.user,
            )),
          if (appState.settingOrganizationId.isNotEmpty)
            MaterialPage(
                child: SettingOrganization(
                    id: appState.settingOrganizationId, appState: appState)),
          if (appState.isOpenAddOrganizationPage)
            MaterialPage(child: SettingAddOrganization(appState: appState)),
        ];
      },
      getRoutePath: (appState) {
        if (appState.isOpenAccountView) return UserSettingPath();
        if (appState.settingOrganizationId.isNotEmpty)
          return SettingOrganizationPath(appState.settingOrganizationId);
        if (appState.isOpenAddOrganizationPage)
          return SettingAddOrganizationPath();
        return SettingPath();
      },
      onPopPage: (appState) {
        if (appState.isOpenAccountView) appState.isOpenAccountView = false;
        if (appState.settingOrganizationId.isNotEmpty)
          appState.settingOrganizationId = '';
        if (appState.isOpenAddOrganizationPage)
          appState.isOpenAddOrganizationPage = false;
      }),
];

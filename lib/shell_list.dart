import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_state.dart';
import 'package:flutter_application_1/route_path.dart';
import 'package:flutter_application_1/shell_pages/home/home.dart';
import 'package:flutter_application_1/shell_pages/schedule/schedule.dart';
import 'package:flutter_application_1/shell_pages/schedule/schedule_add.dart';
import 'package:flutter_application_1/shell_pages/schedule/schedule_details.dart';
import 'package:flutter_application_1/shell_pages/schedule/schedule_home_page.dart';
import 'package:flutter_application_1/shell_pages/schedule/schedule_list_view_for_day.dart';
import 'package:flutter_application_1/shell_pages/search/organization_details.dart';
import 'package:flutter_application_1/shell_pages/search/organization_info.dart';
import 'package:flutter_application_1/shell_pages/search/search_page.dart';
import 'package:flutter_application_1/shell_pages/settings/create_organization.dart';
import 'package:flutter_application_1/shell_pages/settings/setting_organization.dart';
import 'package:flutter_application_1/shell_pages/settings/settings_page.dart';
import 'package:flutter_application_1/shell_pages/settings/user_account_view.dart';
import 'package:flutter_application_1/shell_pages/todo/todo_home_page.dart';
import 'package:flutter_application_1/user_settings/user_theme.dart';

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
              child: ScheduleHomePage(
            key: ValueKey('ScheduleHomePage'),
            appState: appState,
            participatingOrganizationIdList: appState
                .participatingOrganizationList
                .map((e) => e.id)
                .toList(),
            personalEventColor: appState.personalEventColor,
            organizationEventColor: appState.organizationEventColor,
          )),
          if (appState.selectedDayForScheduleList != null)
            MaterialPage(
                key: ValueKey('ScheduleListViewPage'),
                child: ScheduleListViewForDay(
                  targetDate: appState.selectedDayForScheduleList,
                  scheduleList: appState
                      .getScheduleForDay(appState.selectedDayForScheduleList),
                  handleOpenAddPage: () {
                    appState.isOpenAddSchedulePage = true;
                  },
                  handleChangeScheduleDetails: (Schedule schedule) {
                    appState.selectedSchedule = schedule;
                  },
                )),
          if (appState.isOpenAddSchedulePage)
            MaterialPage(
                key: ValueKey('AddSchedulePage'),
                child: AddSchedulePage(
                  targetDate: appState.selectedDayForScheduleList,
                  organizationInfoList: appState.participatingOrganizationList,
                  addSchedule: (Schedule newSchedule, bool isPersonal) async {
                    await appState.addSchedule(newSchedule, isPersonal);
                  },
                  handleCloseAddPage: () {
                    appState.isOpenAddSchedulePage = false;
                  },
                )),
          if (appState.selectedSchedule != null)
            MaterialPage(
                key: ValueKey('ScheduleDetailsPage'),
                child: ScheduleDetails(
                  schedule: appState.selectedSchedule,
                  deleteSchedule: (Schedule targetSchedule) async {
                    await appState.deleteSchedule(targetSchedule,
                        appState.user.uid == targetSchedule.createdBy);
                  },
                  handleCloseDetailsPage: () {
                    appState.selectedSchedule = null;
                  },
                ))
        ];
      },
      getRoutePath: (appState) {
        if (appState.selectedDayForScheduleList != null) {
          if (appState.isOpenAddSchedulePage) {
            return ScheduleAddPath(appState.selectedDayForScheduleList);
          } else if (appState.selectedSchedule != null) {
            return ScheduleDetailPath(
                day: appState.selectedSchedule.start,
                groupName:
                    appState.selectedSchedule.isPublic ? 'public' : 'private',
                organizationId: appState.selectedSchedule.createdBy,
                scheduleId: appState.selectedSchedule.id);
          } else {
            return ScheduleListViewPath(
                day: appState.selectedDayForScheduleList);
          }
        } else {
          if (appState.selectedSchedule != null) {
            return ScheduleDetailPath(
                day: appState.selectedSchedule.start,
                groupName:
                    appState.selectedSchedule.isPublic ? 'public' : 'private',
                organizationId: appState.selectedSchedule.createdBy,
                scheduleId: appState.selectedSchedule.id);
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
              child: TodoHomePage(
            participatingOrganizationList:
                appState.participatingOrganizationList,
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
                    handleCloseDetailPage: () {
                      appState.targetOrganizationId = '';
                    },
                    handleJoinOrganization: (OrganizationInfo info) async {
                      await appState.joinOrganization(info);
                    },
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
                handleChangeSelectedSettingOrganizationId: (String value) {
                  appState.selectedSettingOrganizationId = value;
                },
                handleOpenAccountView: () {
                  appState.isOpenAccountView = true;
                },
                handleOpenCreateNewOrganization: () {
                  appState.isOpenAddOrganizationPage = true;
                },
                logOut: () async {
                  await appState.logOut();
                },
                userThemeSettings: appState.userThemeSettings,
                updateUserTheme: (UserThemeSettings userTheme) async {
                  appState.updateUserTheme(userTheme);
                },
                participatingOrganizationInfoList:
                    appState.participatingOrganizationList,
              )),
          if (appState.isOpenAccountView)
            MaterialPage(
                child: UserAccountView(
              handleChangeUserAccountName: (String name) async {
                await appState.updateUserDisplayName(name);
              },
              user: appState.user,
            )),
          if (appState.selectedSettingOrganizationId.isNotEmpty)
            MaterialPage(
                child: SettingOrganization(
                    id: appState.selectedSettingOrganizationId,
                    appState: appState)),
          if (appState.isOpenAddOrganizationPage)
            MaterialPage(child: CreateOrganization(appState: appState)),
        ];
      },
      getRoutePath: (appState) {
        if (appState.isOpenAccountView) return UserSettingPath();
        if (appState.selectedSettingOrganizationId.isNotEmpty)
          return SettingOrganizationPath(
              appState.selectedSettingOrganizationId);
        if (appState.isOpenAddOrganizationPage)
          return SettingAddOrganizationPath();
        return SettingPath();
      },
      onPopPage: (appState) {
        if (appState.isOpenAccountView) appState.isOpenAccountView = false;
        if (appState.selectedSettingOrganizationId.isNotEmpty)
          appState.selectedSettingOrganizationId = '';
        if (appState.isOpenAddOrganizationPage)
          appState.isOpenAddOrganizationPage = false;
      }),
];

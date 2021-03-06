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
import 'package:flutter_application_1/shell_pages/todo/task.dart';
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
            key: ValueKey('HomePage'),
            getScheduleForDay: () async {
              await appState.loadSchedulesForMonth(DateTime.now());
              return appState.getScheduleForDay(DateTime.now());
            },
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
            getEventsForDay: (DateTime day) {
              return appState.getScheduleForDay(day);
            },
            handleChangeDayForScheduleListView: (DateTime target) {
              appState.selectedDayForScheduleList = target;
            },
            handleChangeSelectedSchedule: (Schedule schedule) {
              appState.selectedSchedule = schedule;
            },
            handleChangeTargetCalendarMonth: (DateTime targetMonth) {
              appState.targetCalendarMonth = targetMonth;
            },
            loadSchedulesForMonth: (DateTime targetMonth) async {
              await appState.loadSchedulesForMonth(targetMonth);
            },
            userId: appState.user.uid,
            targetCalendarMonth: appState.targetCalendarMonth,
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
              child: TodoPage(
            handleChangeTab: (String v) {
              appState.todoTargetTabIndexId = v;
            },
            targetIndexId: appState.todoTargetTabIndexId,
            initTodoCollection: appState.initTodoCollection,
            key: ValueKey('TodoPage'),
            participatingOrganizationInfoList:
                appState.participatingOrganizationList,
            addGroup: (String newGroupName,
                [String targetOrganizationId]) async {
              await appState.addGroup(newGroupName, targetOrganizationId);
            },
            deleteGroup: (String targetGroupId,
                [String targetOrganizationId]) async {
              await appState.deleteGroup(targetGroupId, targetOrganizationId);
            },
            addTask: (Task newTask, String targetGroupId,
                [String targetOrganizationId]) async {
              await appState.addTask(
                  newTask, targetGroupId, targetOrganizationId);
            },
            deleteTask: (Task targetTask, String targetGroupId,
                [String targetOrganizationId]) async {
              await appState.deleteTask(
                  targetTask, targetGroupId, targetOrganizationId);
            },
            loadTasks: ([String targetOrganizationId]) async {
              await appState.loadTasks(targetOrganizationId);
            },
            getTaskGroupList: ([String tragetOrganizationId]) {
              return appState.getTaskGroupList(tragetOrganizationId);
            },
          )),
        ];
      },
      getRoutePath: (appState) {
        return TodoPath(targetId: appState.todoTargetTabIndexId);
      },
      onPopPage: (appState) {
        appState.todoTargetTabIndexId = '';
      }),
  ShellState(
      name: 'Search',
      icon: const Icon(Icons.search),
      getPages: (appState) {
        return [
          MaterialPage(
              child: SearchPage(
            key: ValueKey('search'),
            updateSearchingParam: (String newParam) {
              appState.searchingParam = newParam;
            },
            handleChangeSearchingOrganizationId: (String targetId) {
              appState.searchingOrganizationId = targetId;
            },
            searchingParam: appState.searchingParam,
          )),
          if (appState.searchingOrganizationId.isNotEmpty)
            MaterialPage(
                child: OrganizationDetailPage(
                    participatingOrganizationInfoList:
                        appState.participatingOrganizationList,
                    handleCloseDetailPage: () {
                      appState.searchingOrganizationId = '';
                    },
                    handleJoinOrganization: (OrganizationInfo info) async {
                      await appState.joinOrganization(info);
                    },
                    organizationId: appState.searchingOrganizationId)),
        ];
      },
      getRoutePath: (appState) {
        if (appState.searchingOrganizationId.isEmpty)
          return SearchPath(searchingParam: appState.searchingParam);
        return OrganizationDetailPath(appState.searchingOrganizationId);
      },
      onPopPage: (appState) {
        appState.searchingParam = '';
        appState.searchingOrganizationId = '';
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
                  appState.isOpenCreateOrganizationPage = true;
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
              selectedOrganizationId: appState.selectedSettingOrganizationId,
              handleCloseSettingOrganization: () {
                appState.selectedSettingOrganizationId = '';
              },
              leaveOrganization: (String targetId) async {
                appState.leaveOrganization(targetId);
              },
              participatingOrganizationInfoList:
                  appState.participatingOrganizationList,
            )),
          if (appState.isOpenCreateOrganizationPage)
            MaterialPage(
                child: CreateOrganization(
              joinOrganization: (OrganizationInfo newOrganization) {
                appState.participatingOrganizationList.add(newOrganization);
              },
              handleCloseCreateOrganizationPage: () {
                appState.isOpenCreateOrganizationPage = false;
              },
            )),
        ];
      },
      getRoutePath: (appState) {
        if (appState.isOpenAccountView) return UserSettingPath();
        if (appState.selectedSettingOrganizationId.isNotEmpty)
          return SettingOrganizationPath(
              appState.selectedSettingOrganizationId);
        if (appState.isOpenCreateOrganizationPage)
          return SettingAddOrganizationPath();
        return SettingPath();
      },
      onPopPage: (appState) {
        if (appState.isOpenAccountView) appState.isOpenAccountView = false;
        if (appState.selectedSettingOrganizationId.isNotEmpty)
          appState.selectedSettingOrganizationId = '';
        if (appState.isOpenCreateOrganizationPage)
          appState.isOpenCreateOrganizationPage = false;
      }),
];

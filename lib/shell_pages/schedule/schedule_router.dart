import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_state.dart';
import 'package:flutter_application_1/route_path.dart';
import 'package:flutter_application_1/shell_pages/schedule/schedule.dart';
import 'package:flutter_application_1/shell_pages/schedule/schedule_add.dart';
import 'package:flutter_application_1/shell_pages/schedule/schedule_details.dart';
import 'package:flutter_application_1/shell_pages/schedule/schedule_list_view_for_day.dart';
import 'package:flutter_application_1/shell_pages/schedule/schedule_home_page.dart';
import 'package:flutter_application_1/shell_pages/schedule/schedule_app_state.dart';

class ScheduleRouter extends StatefulWidget {
  ScheduleRouter(this._appState);
  final AppState _appState;
  _ScheduleRouterState createState() => _ScheduleRouterState();
}

class _ScheduleRouterState extends State<ScheduleRouter> {
  ScheduleRouterDelegate _scheduleRouterDelegate;
  ChildBackButtonDispatcher _childBackButtonDispatcher;
  @override
  void initState() {
    super.initState();
    _scheduleRouterDelegate = ScheduleRouterDelegate(widget._appState);
  }

  @override
  Widget build(BuildContext context) {
    _childBackButtonDispatcher.takePriority();
    return Scaffold(
      body: Router(
        routerDelegate: _scheduleRouterDelegate,
        backButtonDispatcher: _childBackButtonDispatcher,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant ScheduleRouter oldWidget) {
    super.didUpdateWidget(oldWidget);
    _scheduleRouterDelegate.appState = widget._appState;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _childBackButtonDispatcher = Router.of(context)
        .backButtonDispatcher
        .createChildBackButtonDispatcher();
  }
}

class ScheduleRouterDelegate extends RouterDelegate<RoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RoutePath> {
  ScheduleRouterDelegate(this.appState)
      : _scheduleAppState = ScheduleAppState() {
    _scheduleAppState.addListener(notifyListeners);
  }

  AppState appState;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  ScheduleAppState _scheduleAppState = ScheduleAppState();
  set scheduleAppState(ScheduleAppState scheduleAppState) {
    this._scheduleAppState = scheduleAppState;
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: this.navigatorKey,
      pages: [
        MaterialPage(
            child: ScheduleHomePage(
          key: ValueKey('ScheduleHomePage'),
          appState: appState,
          scheduleAppState: _scheduleAppState,
        )),
        if (appState.selectedDayForScheduleList != null)
          MaterialPage(
              key: ValueKey('ScheduleListViewPage'),
              child: ScheduleListViewForDay(
                targetDate: appState.selectedDayForScheduleList,
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
                addSchedule: (Schedule newSchedule, bool isPersonal) async {
                  await _scheduleAppState.addSchedule(newSchedule, isPersonal);
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
                  if (appState.user.uid == targetSchedule.createdBy)
                    await _scheduleAppState.deleteSchedule(
                        targetSchedule, true);
                  else
                    await _scheduleAppState.deleteSchedule(
                        targetSchedule, false);
                },
                handleCloseDetailsPage: () {
                  appState.selectedSchedule = null;
                },
              ))
      ],
      onPopPage: (route, result) {
        if (appState.selectedDayForScheduleList != null) {
          if (appState.isOpenAddSchedulePage) {
            appState.isOpenAddSchedulePage = false;
          } else if (appState.selectedSchedule != null) {
            appState.selectedSchedule = null;
          } else {
            appState.selectedDayForScheduleList = null;
          }
        } else {
          if (appState.selectedSchedule != null) {
            appState.selectedSchedule = null;
          }
        }
        notifyListeners();
        return route.didPop(result);
      },
    );
  }

  @override
  Future<void> setNewRoutePath(RoutePath configuration) async {
    assert(false);
  }
}

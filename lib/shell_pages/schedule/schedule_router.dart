import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_state.dart';
import 'package:flutter_application_1/route_path.dart';
import 'package:flutter_application_1/shell_pages/schedule/schedule_add.dart';
import 'package:flutter_application_1/shell_pages/schedule/schedule_details.dart';
import 'package:flutter_application_1/shell_pages/schedule/schedule_list_view_for_day.dart';
import 'package:flutter_application_1/shell_pages/schedule/schedule_page.dart';

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
  Widget build(BuildContext context) {}

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
      : _schedulePageState = SchedulePageState() {
    _schedulePageState.addListener(notifyListeners);
  }
  AppState appState;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  SchedulePageState _schedulePageState = SchedulePageState();
  set schedulePageState(SchedulePageState schedulePageState) {
    this._schedulePageState = schedulePageState;
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: this.navigatorKey,
      pages: [
        MaterialPage(
            child: SchedulePage(
                key: ValueKey('scheduleHome'), appState: appState)),
        if (appState.selectedDayForScheduleList != null)
          MaterialPage(child: ScheduleListViewForDay()),
        if (appState.isOpenAddSchedulePage)
          MaterialPage(child: AddSchedulePage()),
        if (appState.selectedSchedule != null)
          MaterialPage(child: ScheduleDetails())
      ],
      onPopPage: (route, result) {
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

class SchedulePageState extends ChangeNotifier {
  // hogheoge
}

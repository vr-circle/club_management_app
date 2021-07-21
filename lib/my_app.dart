import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_shell.dart';
import 'package:flutter_application_1/app_state.dart';
import 'package:flutter_application_1/auth/login_page.dart';
import 'package:flutter_application_1/auth/signup_page.dart';
import 'package:flutter_application_1/route_path.dart';
import 'package:flutter_application_1/shell_list.dart';
import 'package:flutter_application_1/store/store_service.dart';

class MyRouteInformationParser extends RouteInformationParser<RoutePath> {
  MyRouteInformationParser(this._appState);
  final AppState _appState;
  @override
  Future<RoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    print('parseRouteInformation in MyRouteInformationParser');
    final uri = Uri.parse(routeInformation.location);
    if (_appState.user == null &&
        routeInformation.location == SignUpPath.location) {
      return SignUpPath();
    } else if (_appState.user == null &&
        routeInformation.location == LoginPath.location) {
      // print('return LoginPath');
      return LoginPath();
    } else if (_appState.user == null) {
      return LoginPath();
    }
    if (uri.pathSegments.isEmpty) {
      return HomePath();
    }
    // print('/' + uri.pathSegments.first + ' : ' + routeInformation.location);
    switch ('/' + uri.pathSegments.first) {
      case HomePath.location:
        return HomePath();
      case SchedulePath.location:
        print('SchedulePath.location');
        // /schedule/view?year=2020&month=1&day=1/add
        // /schedule/detail?id=xxxxxxxxx&public=true&day=20200101
        if (uri.queryParameters.containsKey('year') &&
            uri.queryParameters.containsKey('month')) {
          try {
            final int _year = int.parse(uri.queryParameters['year']);
            final int _month = int.parse(uri.queryParameters['month']);
            if (uri.queryParameters.containsKey('day')) {
              final int _day = int.parse(uri.queryParameters['day']);
              if (uri.pathSegments.length == 3 &&
                  uri.pathSegments[2] == 'add') {
                return ScheduleAddPath(DateTime(_year, _month, _day));
              }
              return ScheduleListViewPath(day: DateTime(_year, _month, _day));
            }
            return SchedulePath(targetDate: DateTime(_year, _month));
          } catch (e) {
            print(e);
            return SchedulePath(targetDate: DateTime.now());
          }
        } else if (uri.queryParameters.containsKey('id')) {
          // todo : getSchedule from queryParam
          // if data is not exit, redirect for SchedulePath
          return SchedulePath(targetDate: DateTime.now());
          // return ScheduleDetailPath();
        }
        print('return SchedulePath(targetDate: DateTime.now());');
        return SchedulePath(targetDate: DateTime.now());
      case TodoPath.location:
        if (uri.pathSegments.length == 2) {
          return TodoPath(targetId: uri.pathSegments[1]);
        }
        return TodoPath(targetId: '');
      case SearchPath.location:
        return SearchPath(searchingParam: uri.queryParameters['keyword'] ?? '');
      case OrganizationDetailPath.location:
        return OrganizationDetailPath(uri.queryParameters['id'] ?? '');
      case SettingPath.location:
        if (uri.pathSegments.length == 2 && uri.pathSegments[1] == 'user') {
          return UserSettingPath();
        }
        if (uri.pathSegments.length == 3 &&
            uri.pathSegments[1] == 'organization') {
          if (uri.pathSegments[2] == 'add') {
            return SettingAddOrganizationPath();
          }
          return SettingOrganizationPath(uri.pathSegments[2]);
        }
        return SettingPath();
      default:
        return null;
    }
  }

  @override
  RouteInformation restoreRouteInformation(RoutePath path) {
    print('restoreRouteInformation');
    if (path is LoginPath) {
      return RouteInformation(location: '${LoginPath.location}');
    }
    if (path is SignUpPath) {
      return RouteInformation(location: '${SignUpPath.location}');
    }
    if (path is HomePath) {
      return RouteInformation(location: '${HomePath.location}');
    }
    if (path is SchedulePath) {
      print('path is SchedulePath');
      print(path.targetDate);
      return RouteInformation(
          location:
              '${SchedulePath.location}/view?year=${path.targetDate.year}&month=${path.targetDate.month}');
    }
    if (path is ScheduleListViewPath) {
      return RouteInformation(
          location:
              '${SchedulePath.location}/view?year=${path.day.year}&month=${path.day.month}&day=${path.day.day}');
    }
    if (path is ScheduleAddPath) {
      return RouteInformation(
          location:
              '${SchedulePath.location}/view?year=${path.day.year}&month=${path.day.month}&day=${path.day.day}/add');
    }
    if (path is ScheduleDetailPath) {
      return RouteInformation(
          location: '${SchedulePath.location}/detail/${path.targetId}');
    }
    if (path is TodoPath) {
      if (path.targetId.isEmpty) {
        return RouteInformation(location: '${TodoPath.location}');
      }
      return RouteInformation(
          location: '${TodoPath.location}/${path.targetId}');
    }
    if (path is SearchPath) {
      if (path.searchingParam.isEmpty) {
        return RouteInformation(location: '${SearchPath.location}');
      }
      return RouteInformation(
          location: '${SearchPath.location}?keyword=${path.searchingParam}');
    }
    if (path is OrganizationDetailPath) {
      if (path.id.isEmpty)
        return RouteInformation(location: '${OrganizationDetailPath.location}');
      return RouteInformation(
          location: '${OrganizationDetailPath.location}?id=${path.id}');
    }
    if (path is SettingPath) {
      return RouteInformation(location: '${SettingPath.location}');
    }
    if (path is SettingOrganizationPath) {
      return RouteInformation(
          location:
              '${SettingPath.location}${SettingOrganizationPath.location}/${path.id}');
    }
    if (path is SettingAddOrganizationPath) {
      return RouteInformation(
          location: '${SettingAddOrganizationPath.lcoation}');
    }
    if (path is UserSettingPath) {
      return RouteInformation(location: '${UserSettingPath.location}');
    }
    return null;
  }
}

class MyRouterDelegate extends RouterDelegate<RoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RoutePath> {
  MyRouterDelegate(this.appState) : navigatorKey = GlobalKey<NavigatorState>() {
    appState.addListener(notifyListeners);
  }
  final GlobalKey<NavigatorState> navigatorKey;
  final AppState appState;

  RoutePath get currentConfiguration {
    print('currentConfiguration');
    if (appState.loggedInState == LoggedInState.loggedOut &&
        appState.isOpenSignUpPage == false) {
      return LoginPath();
    } else if (appState.loggedInState == LoggedInState.loggedOut &&
        appState.isOpenSignUpPage) {
      return SignUpPath();
    }
    return shellList[appState.bottomNavigationIndex].getRoutePath(appState);
  }

  @override
  Widget build(BuildContext context) {
    print('build in MyRouterDelegate');
    return Navigator(
      key: navigatorKey,
      pages: [
        if (appState.loggedInState == LoggedInState.loggedOut)
          MaterialPage(
              child: LoginPage(
            handleChangeOpeningSignUpPage: (value) {
              appState.isOpenSignUpPage = value;
            },
            handleLogin: (email, password) async {
              await appState.logIn(email, password);
            },
          )),
        if (appState.loggedInState == LoggedInState.loggedOut &&
            appState.isOpenSignUpPage)
          MaterialPage(
              child: SignUpPage(
            appState: appState,
          )),
        if (appState.loggedInState == LoggedInState.loading)
          MaterialPage(
              child: const Scaffold(
            body: const Center(child: const CircularProgressIndicator()),
          )),
        if (appState.loggedInState == LoggedInState.loggedIn)
          MaterialPage(child: AppShell(appState))
      ],
      onPopPage: (route, result) {
        print('popPage');
        if (appState.isOpenSignUpPage) {
          print('popPage: false -> isOpenSignUpPage');
          appState.isOpenSignUpPage = false;
          notifyListeners();
        }
        if (!route.didPop(result)) {
          return false;
        }
        notifyListeners();
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(RoutePath path) async {
    print('setNewRoutePath: new path is ${path.runtimeType}');
    if (path is LoginPath) {
      appState.isOpenSignUpPage = false;
      return;
    } else if (path is SignUpPath) {
      appState.isOpenSignUpPage = true;
      return;
    } else if (path is HomePath) {
      appState.bottomNavigationIndex = HomePath.index;
    } else if (path is SchedulePath) {
      appState.bottomNavigationIndex = SchedulePath.index;
      appState.targetCalendarMonth = path.targetDate;
      appState.selectedDayForScheduleList = null;
      appState.isOpenAddSchedulePage = false;
      appState.selectedSchedule = null;
    } else if (path is ScheduleListViewPath) {
      appState.bottomNavigationIndex = SchedulePath.index;
      appState.selectedDayForScheduleList = path.day;
      appState.isOpenAddSchedulePage = false;
      appState.selectedSchedule = null;
    } else if (path is ScheduleDetailPath) {
      appState.bottomNavigationIndex = SchedulePath.index;
      // todo: create Schedule from path info
      final data = await dbService.getSchedulesForDay(DateTime.now(), false);
      appState.selectedSchedule = data[0] ?? null;
    } else if (path is ScheduleAddPath) {
      appState.bottomNavigationIndex = SchedulePath.index;
      appState.selectedDayForScheduleList = path.day;
      appState.isOpenAddSchedulePage = true;
      appState.selectedSchedule = null;
    } else if (path is TodoPath) {
      appState.bottomNavigationIndex = TodoPath.index;
      appState.targetTodoTabId = path.targetId;
    } else if (path is SearchPath) {
      appState.bottomNavigationIndex = SearchPath.index;
      appState.targetOrganizationId = '';
    } else if (path is OrganizationDetailPath) {
      appState.targetOrganizationId = path.id;
    } else if (path is SettingPath) {
      appState.bottomNavigationIndex = SettingPath.index;
      appState.isOpenAccountView = false;
      appState.settingOrganizationId = '';
      appState.isOpenAddOrganizationPage = false;
    } else if (path is SettingOrganizationPath) {
      appState.bottomNavigationIndex = SettingPath.index;
      appState.isOpenAccountView = false;
      appState.settingOrganizationId = path.id;
    } else if (path is SettingAddOrganizationPath) {
      appState.bottomNavigationIndex = SettingPath.index;
      appState.isOpenAccountView = false;
      appState.isOpenAddOrganizationPage = true;
      appState.settingOrganizationId = '';
    } else if (path is UserSettingPath) {
      appState.isOpenAccountView = true;
    }
  }
}

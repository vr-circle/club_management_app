import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_shell.dart';
import 'package:flutter_application_1/app_state.dart';
import 'package:flutter_application_1/auth/login_page.dart';
import 'package:flutter_application_1/route_path.dart';
import 'package:flutter_application_1/shell_list.dart';

class MyRouteInformationParser extends RouteInformationParser<RoutePath> {
  MyRouteInformationParser(this._appState);
  final AppState _appState;
  @override
  Future<RoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    print('parseRouteInformation in MyRouteInformationParser');
    final uri = Uri.parse(routeInformation.location);
    if (_appState.user == null) {
      print('return LoginPath');
      return LoginPath();
    } else if (uri.pathSegments.isEmpty) {
      return HomePath();
    }
    print('/' + uri.pathSegments.first + ' : ' + routeInformation.location);
    switch ('/' + uri.pathSegments.first) {
      case HomePath.location:
        return HomePath();
      case SchedulePath.location:
        return SchedulePath();
      case TodoPath.location:
        print('TodoPath');
        if (uri.pathSegments.length == 2) {
          print('uri.pathSegments[1] == ${uri.pathSegments[1]}');
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
    if (path is HomePath) {
      return RouteInformation(location: '${HomePath.location}');
    }
    if (path is SchedulePath) {
      return RouteInformation(location: '${SchedulePath.location}');
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
    if (appState.loggedInState == LoggedInState.loggedOut) {
      return LoginPath();
    }
    return shellList[appState.bottomNavigationIndex].getRoutePath(appState);
  }

  @override
  Widget build(BuildContext context) {
    print('build in MyRouterDelegate');
    print(appState.loggedInState);
    return Navigator(
      key: navigatorKey,
      pages: [
        if (appState.loggedInState == LoggedInState.loggedOut)
          MaterialPage(child: LoginPage(
            handleLogin: (email, password) async {
              await appState.logIn(email, password);
            },
          ))
        else if (appState.loggedInState == LoggedInState.loading)
          MaterialPage(
              child: const Scaffold(
            body: const Center(child: const CircularProgressIndicator()),
          ))
        else
          MaterialPage(child: AppShell(appState))
      ],
      onPopPage: (route, result) {
        print('onPopPage');
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
      return;
    } else if (path is HomePath) {
      appState.bottomNavigationIndex = HomePath.index;
    } else if (path is SchedulePath) {
      appState.bottomNavigationIndex = SchedulePath.index;
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
    } else if (path is SettingOrganizationPath) {
      appState.settingOrganizationId = path.id;
    } else if (path is UserSettingPath) {
      appState.isOpenAccountView = true;
    }
  }
}

import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'auth/auth_service.dart';
import 'auth/sign_up_page.dart';
import 'auth/verification_page.dart';
import 'auth/login_page.dart';
import 'home/home.dart';
import 'search/search.dart';
import 'todo/todo.dart';
import 'schedule/schedule.dart';
import 'user_settings/settings.dart';

void main() {
  initializeDateFormatting()
      .then((value) => runApp(ProviderScope(child: MyApp())));
}

class MyRouteAppState {
  MyRouteAppState({this.routeInformationParser, this.routerDelegate});
  RouteInformationParser routeInformationParser;
  RouterDelegate routerDelegate;
}

class MyRouteAppStateNotifier extends StateNotifier<MyRouteAppState> {
  MyRouteAppStateNotifier()
      : super(MyRouteAppState(
            routerDelegate: MyRouterDelegate(),
            routeInformationParser: MyRouteInformationParser()));
}

final myAppStateProvider =
    StateNotifierProvider((ref) => MyRouteAppStateNotifier());

class MyApp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final myAppState = useProvider(myAppStateProvider);
    return MaterialApp.router(
        theme: useProvider(darkModeProvider)
            ? ThemeData.dark()
            : ThemeData.light(),
        routeInformationParser: myAppState.routeInformationParser,
        routerDelegate: myAppState.routerDelegate);
  }
}

class MyAppState extends ChangeNotifier {
  MyAppState()
      : _selectedIndex = 0,
        _authFlowStatus = AuthFlowStatus.login;
  int _selectedIndex;
  AuthFlowStatus _authFlowStatus;
  int get selectedIndex => _selectedIndex;
  set selectedIndex(int idx) {
    _selectedIndex = idx;
    notifyListeners();
  }

  AuthFlowStatus get authFlowStatus => _authFlowStatus;
  set authFlowStatus(AuthFlowStatus s) {
    _authFlowStatus = s;
    notifyListeners();
  }
}

abstract class RoutePath {}

class LoginPath extends RoutePath {}

// class HomePath extends RoutePath {}

class SchedulePath extends RoutePath {}

class TodoPath extends RoutePath {}

class SettingsPath extends RoutePath {}

class MyRouteInformationParser extends RouteInformationParser<RoutePath> {
  @override
  Future<RoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location);

    if (uri.pathSegments.isNotEmpty) {
      if (uri.pathSegments.first == 'login') {
        return LoginPath();
      }
      // if (uri.pathSegments.first == 'home') {
      //   return HomePath();
      // }
      if (uri.pathSegments.first == 'schedule') {
        return SchedulePath();
      }
      if (uri.pathSegments.first == 'todo') {
        return TodoPath();
      }
      if (uri.pathSegments.first == 'settings') {
        return SettingsPath();
      }
    }
    // return HomePath();
    return null;
  }

  @override
  RouteInformation restoreRouteInformation(RoutePath path) {
    if (path is LoginPath) {
      return RouteInformation(location: '/login');
    }
    // if (path is HomePath) {
    //   return RouteInformation(location: '/home');
    // }
    if (path is SchedulePath) {
      return RouteInformation(location: '/schedule');
    }
    if (path is TodoPath) {
      return RouteInformation(location: '/todo');
    }
    if (path is SettingsPath) {
      return RouteInformation(location: '/settings');
    }
    return null;
  }
}

class MyRouterDelegate extends RouterDelegate<RoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;
  MyAppState appState = MyAppState();

  MyRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
    appState.addListener(notifyListeners);
  }

  RoutePath get currentConfiguration {
    // if (appState.selectedIndex == 0) {
    //   // hoem
    //   return HomePath();
    // } else
    if (appState.selectedIndex == 0) {
      // schedule
      return SchedulePath();
    } else if (appState.selectedIndex == 1) {
      // todo
      return TodoPath();
    } else {
      // settings
      return SettingsPath(); // UnknownPath?
    }
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        // if (appState.authFlowStatus == AuthFlowStatus.login)
        //   FadeAnimationPage(child: LoginPage(), key: ValueKey('LoginPage'))
        // else
        MaterialPage(child: AppShell(appState: appState)),
      ],
      onPopPage: (route, result) {
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
    // if (path is HomePath) {
    //   appState.selectedIndex = 0;
    // } else
    if (path is SchedulePath) {
      appState.selectedIndex = 0;
    } else if (path is TodoPath) {
      appState.selectedIndex = 1;
    } else if (path is SettingsPath) {
      appState.selectedIndex = 2;
    }
  }
}

class AppShell extends StatefulWidget {
  final MyAppState appState;

  AppShell({
    @required this.appState,
  });

  @override
  _AppShellState createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  InnerRouterDelegate _routerDelegate;
  ChildBackButtonDispatcher _backButtonDispatcher;

  void initState() {
    super.initState();
    _routerDelegate = InnerRouterDelegate(widget.appState);
  }

  @override
  void didUpdateWidget(covariant AppShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    _routerDelegate.appState = widget.appState;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Defer back button dispatching to the child router
    _backButtonDispatcher = Router.of(context)
        .backButtonDispatcher
        .createChildBackButtonDispatcher();
  }

  @override
  Widget build(BuildContext context) {
    var appState = widget.appState;

    // Claim priority, If there are parallel sub router, you will need
    // to pick which one should take priority;
    _backButtonDispatcher.takePriority();

    return Scaffold(
      appBar: AppBar(
        title: Text('Club Management App'),
      ),
      body: Router(
        routerDelegate: _routerDelegate,
        backButtonDispatcher: _backButtonDispatcher,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          // BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.schedule), label: 'Schedule'),
          BottomNavigationBarItem(
              icon: Icon(Icons.task_rounded), label: 'ToDo'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
        currentIndex: appState.selectedIndex,
        onTap: (newIndex) {
          appState.selectedIndex = newIndex;
        },
      ),
    );
  }
}

class InnerRouterDelegate extends RouterDelegate<RoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RoutePath> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  MyAppState get appState => _appState;
  MyAppState _appState;
  set appState(MyAppState value) {
    if (value == _appState) {
      return;
    }
    _appState = value;
    notifyListeners();
  }

  InnerRouterDelegate(this._appState);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        // if (appState.selectedIndex == 0)
        //   FadeAnimationPage(child: HomePage(), key: ValueKey('HomePage'))
        // else
        if (appState.selectedIndex == 0)
          FadeAnimationPage(
              child: SchedulePage(), key: ValueKey('SchedulePage'))
        else if (appState.selectedIndex == 1)
          FadeAnimationPage(child: TodoPage(), key: ValueKey('TodoPage'))
        else
          FadeAnimationPage(
            child: SettingsPage(),
            key: ValueKey('SettingsPage'),
          ),
      ],
      onPopPage: (route, result) {
        notifyListeners();
        return route.didPop(result);
      },
    );
  }

  @override
  Future<void> setNewRoutePath(RoutePath path) async {
    assert(false);
  }
}

class FadeAnimationPage extends Page {
  final Widget child;

  FadeAnimationPage({Key key, this.child}) : super(key: key);

  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (context, animation, animation2) {
        var curveTween = CurveTween(curve: Curves.easeIn);
        return FadeTransition(
          opacity: animation.drive(curveTween),
          child: child,
        );
      },
    );
  }
}

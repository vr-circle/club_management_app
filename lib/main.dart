// import 'dart:html';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/auth_service.dart';
import 'package:flutter_application_1/store/store_service.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';

import 'auth/login_page.dart';
import 'todo/todo.dart';
import 'schedule/schedule_page.dart';
import 'user_settings/settings.dart';

Future<void> main() async {
  await Firebase.initializeApp();
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
    final myRouteAppState = useProvider(myAppStateProvider);
    return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: useProvider(darkModeProvider)
            ? ThemeData.dark()
            : ThemeData.light(),
        routeInformationParser: myRouteAppState.routeInformationParser,
        routerDelegate: myRouteAppState.routerDelegate);
  }
}

class MyAppState extends ChangeNotifier {
  MyAppState() : _selectedIndex = 0;
  int _selectedIndex;
  int get selectedIndex => _selectedIndex;
  set selectedIndex(int idx) {
    _selectedIndex = idx;
    notifyListeners();
  }

  AuthService _authService = AuthService();
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _authService.signInWithEmailAndPassword(email, password);
    notifyListeners();
  }

  Future<void> signOut() async {
    await _authService.signOut();
    notifyListeners();
  }

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    await _authService.signUpWithEmailAndPassword(email, password);
    notifyListeners();
  }

  User getCurrentUser() {
    return _authService.getCurrentUser();
  }
}

abstract class RoutePath {}

class LoginPath extends RoutePath {}

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
    if (appState.getCurrentUser() == null) {
      return LoginPath();
    }

    if (appState.selectedIndex == 0) {
      return SchedulePath();
    } else if (appState.selectedIndex == 1) {
      return TodoPath();
    } else {
      return SettingsPath(); // UnknownPath?
    }
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        if (appState.getCurrentUser() == null)
          FadeAnimationPage(
              child: LoginPage(appState), key: ValueKey('LoginPage'))
        else
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
    storeService = StoreService(userId: widget.appState.getCurrentUser().uid);
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
    final Size size = MediaQuery.of(context).size;

    // Claim priority, If there are parallel sub router, you will need
    // to pick which one should take priority;
    _backButtonDispatcher.takePriority();

    if (size.width > 500) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Club Management App'),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.person),
            )
          ],
        ),
        body: Router(
          routerDelegate: _routerDelegate,
          backButtonDispatcher: _backButtonDispatcher,
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(child: Text('DrawerMenu')),
              ListTile(
                leading: Icon(Icons.schedule),
                title: Text('Schedule'),
                onTap: () {
                  appState.selectedIndex = 0;
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.task_rounded),
                title: Text('ToDo'),
                onTap: () {
                  appState.selectedIndex = 1;
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  appState.selectedIndex = 2;
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Club Management App'),
        actions: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Icon(Icons.people),
          )
        ],
      ),
      body: Router(
        routerDelegate: _routerDelegate,
        backButtonDispatcher: _backButtonDispatcher,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
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
        if (appState.selectedIndex == 0)
          FadeAnimationPage(
              child: SchedulePage(), key: ValueKey('SchedulePage'))
        else if (appState.selectedIndex == 1)
          FadeAnimationPage(child: TodoPage(), key: ValueKey('TodoPage'))
        else
          FadeAnimationPage(
            child: SettingsPage(appState),
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

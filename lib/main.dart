// import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/store/store_service.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';

import 'auth/login_page.dart';
import 'user_settings/settings.dart';
import 'route_path.dart';
import 'app_state.dart';
import 'pages/fade_animation_page.dart';

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

class MyRouteInformationParser extends RouteInformationParser<RoutePath> {
  @override
  Future<RoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location);

    if (uri.pathSegments.isNotEmpty) {
      if (uri.pathSegments.first == 'login') {
        return LoginPath();
      }
      if (uri.pathSegments.first == 'home') {
        return HomePath();
      }
      if (uri.pathSegments.first == 'schedule') {
        print(uri.pathSegments);
        if (uri.pathSegments.length == 2) {
          try {
            print(uri.pathSegments[1]);
            var x = DateFormat('yyyy-MM-dd').parseStrict(uri.pathSegments[1]);
            print('return schedule list view path');
            return ScheduleListViewPath(x);
          } catch (e) {
            print(e);
          }
        } else if (uri.pathSegments.length == 3) {
          print(3);
          try {
            var x = DateFormat('yyyy-MM-dd').parseStrict(uri.pathSegments[1]);
            var scheduleId = uri.pathSegments[2];
            print('return schedule details path');
            return ScheduleDetailPath(x, scheduleId);
          } catch (e) {
            print(e);
          }
        }
        return SchedulePath();
      }
      if (uri.pathSegments.first == 'todo') {
        return TodoPath();
      }
      if (uri.pathSegments.first == 'search') {
        return SearchPath();
      }
      if (uri.pathSegments.first == 'settings') {
        if (uri.pathSegments.length >= 2) {
          if (uri.pathSegments[1] == 'user') {
            return UserSettingsPath();
          }
        }
        return SettingsPath();
      }
    }
    // if not true in any case
    return HomePath();
  }

  @override
  RouteInformation restoreRouteInformation(RoutePath path) {
    // login
    if (path is LoginPath) {
      return RouteInformation(location: '/login');
    }

    // home
    if (path is HomePath) {
      return RouteInformation(location: '/home');
    }

    // schedule
    if (path is SchedulePath) {
      return RouteInformation(location: '/schedule');
    }
    if (path is ScheduleDetailPath) {
      return RouteInformation(
          location:
              '/schedule/${DateFormat("yyyy-MM-dd").format(path.day)}/${path.id}');
    }
    if (path is ScheduleListViewPath) {
      var p = DateFormat('yyyy-MM-dd').format(path.day);
      return RouteInformation(location: '/schedule/$p');
    }

    // todo
    if (path is TodoPath) {
      return RouteInformation(location: '/todo');
    }

    // search
    if (path is SearchPath) {
      return RouteInformation(location: '/search');
    }

    // settings
    if (path is SettingsPath) {
      return RouteInformation(location: '/settings');
    }
    if (path is UserSettingsPath) {
      return RouteInformation(location: '/settings/user');
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
    return navigationList[appState.selectedIndex].getRoutePath(appState);
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
    if (path is HomePath) {
      appState.selectedIndex = 0;
      return;
    }
    if (path is SchedulePath) {
      appState.selectedIndex = 1;
      appState.selectedDay = null;
      appState.selectedSchedule = null;
      return;
    } else if (path is ScheduleListViewPath) {
      appState.selectedIndex = 1;
      appState.selectedSchedule = null;
      appState.setSelectedDay(path.day);
      return;
    } else if (path is ScheduleDetailPath) {
      appState.selectedIndex = 1;
      appState.setSelectedScheduleById(path.day, path.id);
      return;
    }
    if (path is TodoPath) {
      appState.selectedIndex = 2;
      return;
    }
    if (path is SearchPath) {
      appState.selectedIndex = 3;
      return;
    }
    if (path is SettingsPath) {
      appState.selectedIndex = 4;
      appState.isSelectedUserSettings = false;
    } else if (path is UserSettingsPath) {
      appState.selectedIndex = 4;
      appState.isSelectedUserSettings = true;
      return;
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
    storeService = StoreService(userId: widget.appState.getCurrentUser().uid);
    _routerDelegate = InnerRouterDelegate(widget.appState);
    super.initState();
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

    _backButtonDispatcher.takePriority();

    if (size.width > 600) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Club Management App'),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: IconButton(
                icon: Icon(Icons.person),
                onPressed: () {
                  appState.isSelectedUserSettings = true;
                  appState.selectedIndex = 4;
                },
              ),
            )
          ],
        ),
        body: Router(
          routerDelegate: _routerDelegate,
          backButtonDispatcher: _backButtonDispatcher,
        ),
        drawer: Drawer(
            child: Column(
          children: [
            DrawerHeader(child: Text('DrawerMenu')),
            Container(
              child: Column(
                  children: navigationList
                      .asMap()
                      .entries
                      .map((e) => ListTile(
                            title: Text(e.value.name),
                            leading: e.value.icon,
                            onTap: () {
                              appState.selectedIndex = e.key;
                              Navigator.pop(context);
                            },
                          ))
                      .toList()),
            )
          ],
        )),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Club Management App'),
        actions: [
          Padding(
            padding: EdgeInsets.all(8),
            child: IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                appState.isSelectedUserSettings = true;
                appState.selectedIndex = 4;
              },
            ),
          )
        ],
      ),
      body: Router(
        routerDelegate: _routerDelegate,
        backButtonDispatcher: _backButtonDispatcher,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        items: navigationList
            .map((e) => BottomNavigationBarItem(icon: e.icon, label: e.name))
            .toList(),
        currentIndex: appState.selectedIndex,
        onTap: (newIndex) {
          if (appState.selectedIndex == newIndex) {
            navigationList[appState.selectedIndex].initAppState(appState);
          }
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
      pages: [...navigationList[appState.selectedIndex].getPages(appState)],
      onPopPage: (route, result) {
        navigationList[appState.selectedIndex].onPopPage(appState);
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

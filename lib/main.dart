import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/user_settings/settings.dart';
import 'package:flutter_application_1/store/store_service.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'package:url_strategy/url_strategy.dart';

import 'auth/login_page.dart';
import 'route_path.dart';
import 'app_state.dart';
import 'animation_pages/fade_animation_page.dart';

Future<void> main() async {
  setPathUrlStrategy(); // remove # in url
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
        if (uri.pathSegments.length == 2) {
          try {
            var x = DateFormat('yyyy-MM-dd').parseStrict(uri.pathSegments[1]);
            return ScheduleListViewPath(x);
          } catch (e) {
            print(e);
          }
        } else if (uri.pathSegments.length == 3) {
          try {
            var x = DateFormat('yyyy-MM-dd').parseStrict(uri.pathSegments[1]);
            var scheduleId = uri.pathSegments[2];
            return ScheduleDetailPath(x, scheduleId);
          } catch (e) {
            print(e);
          }
        }
        return SchedulePath();
      }
      if (uri.pathSegments.first == 'todo') {
        if (uri.pathSegments.length == 2) {
          try {
            return TodoPath(int.parse(uri.pathSegments[1]));
          } catch (e) {
            print(e);
          }
        } else if (uri.pathSegments.length == 3 &&
            uri.pathSegments[2] == 'add') {
          try {
            return TodoAddPath(int.parse(uri.pathSegments[1]));
          } catch (e) {
            print(e);
          }
        }
        return TodoPath(0);
      }
      if (uri.pathSegments.first == 'groupview') {
        return GroupViewPath();
      }
      if (uri.pathSegments.first == 'search') {
        print(uri.queryParameters['keywords']);
        return SearchPath([]);
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
      // get target tab name from tab index.
      return RouteInformation(location: '/todo/${path.targetTabIndex}');
    }
    if (path is TodoAddPath) {
      return RouteInformation(location: '/todo/${path.targetTabIndex}/add');
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
      print("user account is null");
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
      appState.selectedIndex = HomePath.index;
      return;
    }

    if (path is SchedulePath) {
      appState.selectedIndex = SchedulePath.index;
      appState.selectedDay = null;
      appState.selectedSchedule = null;
      return;
    } else if (path is ScheduleListViewPath) {
      appState.selectedIndex = SchedulePath.index;
      appState.selectedSchedule = null;
      appState.setSelectedDay(path.day);
      return;
    } else if (path is ScheduleDetailPath) {
      appState.selectedIndex = SchedulePath.index;
      appState.setSelectedScheduleById(path.day, path.id);
      return;
    }

    if (path is TodoPath) {
      appState.selectedIndex = TodoPath.index;
      appState.selectedTabInTodo = path.targetTabIndex;
      return;
    } else if (path is TodoAddPath) {
      appState.selectedIndex = TodoPath.index;
      appState.selectedTabInTodo = path.targetTabIndex;
    }

    if (path is GroupViewPath) {
      appState.selectedIndex = GroupViewPath.index;
    }

    if (path is SearchPath) {
      // appState.searchingParam = null;
      return;
    }
    if (path is SettingsPath) {
      appState.selectedIndex = SettingsPath.index;
      appState.isSelectedUserSettings = false;
    } else if (path is UserSettingsPath) {
      appState.selectedIndex = SettingsPath.index;
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
          title: Text('CMA'),
          actions: [
            Container(
                width: MediaQuery.of(context).size.width / 3,
                child: TextField(
                  onSubmitted: (value) {
                    // navigate for search page (param = value)
                  },
                  decoration: InputDecoration(
                      icon: Icon(Icons.search),
                      labelText: 'Search clubs by name or categories'),
                )),
            SizedBox(
              width: MediaQuery.of(context).size.width / 4,
            ),
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: IconButton(
                icon: Icon(Icons.person),
                onPressed: () {
                  appState.isSelectedUserSettings = true;
                  appState.selectedIndex = SettingsPath.index;
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
        title: const Text('CMA'),
        actions: [
          Padding(
            padding: EdgeInsets.all(8),
            child: IconButton(
                onPressed: () {
                  appState.isSearchingMode = true;
                },
                icon: Icon(Icons.search)),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                appState.isSelectedUserSettings = true;
                appState.selectedIndex = SettingsPath.index;
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

import 'dart:html';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/auth_service.dart';
import 'package:flutter_application_1/schedule/schedule.dart';
import 'package:flutter_application_1/schedule/schedule_collection.dart';
import 'package:flutter_application_1/schedule/schedule_details.dart';
import 'package:flutter_application_1/schedule/schedule_list_on_day.dart';
import 'package:flutter_application_1/search/search.dart';
import 'package:flutter_application_1/store/store_service.dart';
import 'package:flutter_application_1/user_settings/user_account_view.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';

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
  MyAppState()
      : _selectedIndex = 1,
        _selectedDay = null,
        _selectedSchedule = null,
        _selectedTabInTodo = 0,
        _isSelectedUserSettings = false;
  int _selectedIndex;
  DateTime _selectedDay;
  Schedule _selectedSchedule;
  int _selectedTabInTodo;
  bool _isSelectedUserSettings;

  bool get isSelectedUserSettings => _isSelectedUserSettings;
  set isSelectedUserSettings(bool value) {
    _isSelectedUserSettings = value;
    notifyListeners();
  }

  int get selectedIndex => _selectedIndex;
  set selectedIndex(int idx) {
    _selectedIndex = idx;
    notifyListeners();
  }

  DateTime get selectedDay => _selectedDay;
  set selectedDay(DateTime day) {
    _selectedDay = day;
    notifyListeners();
  }

  Schedule get selectedSchedule => _selectedSchedule;
  set selectedSchedule(Schedule schedule) {
    _selectedSchedule = schedule;
    notifyListeners();
  }

  int get selectedTabInTodo => _selectedTabInTodo;
  set selectedTabInTodo(int idx) {
    _selectedTabInTodo = idx;
    notifyListeners();
  }

  // ---------------- todo ----------------

  // ---------------- schedule ----------------
  ScheduleCollection scheduleCollection = new ScheduleCollection();

  void setSelectedDay(DateTime day) {
    if (day == null) return;
    selectedDay = day;
    notifyListeners();
  }

  void setSelectedScheduleById(DateTime day, String id) {
    final List<Schedule> targetSchedule = scheduleCollection.schedules[day]
        .where((element) => element.id == id)
        .toList();
    if (targetSchedule.isEmpty) {
      return;
    }
    selectedSchedule = targetSchedule.first;
    notifyListeners();
  }

  Future<void> addSchedule(Schedule schedule, String target) async {
    await storeService.addSchedule(schedule, target);
    scheduleCollection.addSchedule(schedule, target);
    notifyListeners();
  }

  Future<void> deleteSchedule(Schedule targetSchedule) async {
    await storeService.deleteSchedule(targetSchedule);
    scheduleCollection.deleteSchedule(targetSchedule);
    notifyListeners();
  }

  Future<Map<DateTime, List<Schedule>>> getSchedule(
      List<String> targets) async {
    return (await storeService.getSchedule(targets));
  }

  List<Schedule> getScheduleList(DateTime day) {
    return scheduleCollection.getScheduleList(day);
  }

  // ---------------- auth ----------------
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

// 0 -> location -> name -> path

class NavigationState {
  String name;
  String location;
  Icon icon;
  RoutePath Function(MyAppState appState) getRoutePath;
  NavigationState(
      {@required this.name,
      @required this.icon,
      @required this.location,
      @required this.getRoutePath});
}

final List<NavigationState> navigationList = [
  NavigationState(
      name: 'Home',
      icon: Icon(Icons.home),
      location: '/home',
      getRoutePath: (appState) {
        return HomePath();
      }),
  NavigationState(
      name: 'Schedule',
      icon: Icon(Icons.calendar_today),
      location: '/schedule',
      getRoutePath: (appState) {
        if (appState.selectedDay != null) {
          if (appState.selectedSchedule != null) {
            return ScheduleDetailPath(
                appState.selectedDay, appState.selectedSchedule.id);
          } else {
            return ScheduleListViewPath(appState.selectedDay);
          }
        }
        return SchedulePath();
      }),
  NavigationState(
      name: 'Todo',
      icon: Icon(Icons.task_outlined),
      location: '/todo',
      getRoutePath: (appState) {
        return HomePath();
      }),
  NavigationState(
      name: 'Search',
      icon: Icon(Icons.search),
      location: '/search',
      getRoutePath: (appState) {
        return SearchPath();
      }),
  NavigationState(
      name: 'Settings',
      icon: Icon(Icons.settings),
      location: '/settings',
      getRoutePath: (appState) {
        if (appState.isSelectedUserSettings) {
          return UserSettingsPath();
        }
        return SettingsPath();
      }),
];

abstract class RoutePath {}

class LoginPath extends RoutePath {}

class HomePath extends RoutePath {}

class SchedulePath extends RoutePath {}

class ScheduleDetailPath extends RoutePath {
  final String id;
  final DateTime day;
  ScheduleDetailPath(this.day, this.id);
}

class ScheduleListViewPath extends RoutePath {
  final DateTime day;
  ScheduleListViewPath(this.day);
}

class TodoPath extends RoutePath {}

class SearchPath extends RoutePath {}

class SettingsPath extends RoutePath {}

class UserSettingsPath extends RoutePath {}

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
        if (uri.pathSegments.length == 2) {
          try {
            var x = DateFormat('yyyyMMdd').parseStrict(uri.pathSegments[1]);
            return ScheduleListViewPath(x);
          } catch (e) {
            print(e);
          }
          return SchedulePath();
        } else if (uri.pathSegments.length == 3) {
          // does this need?
          try {
            var x = DateFormat('yyyyMMdd').parseStrict(uri.pathSegments[1]);
            var scheduleId = uri.pathSegments[2];
            return ScheduleDetailPath(x, scheduleId);
          } catch (e) {
            print(e);
          }
          return SchedulePath();
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
    return SchedulePath();
  }

  @override
  RouteInformation restoreRouteInformation(RoutePath path) {
    if (path is LoginPath) {
      return RouteInformation(location: '/login');
    }
    if (path is HomePath) {
      return RouteInformation(location: '/home');
    }
    if (path is SchedulePath) {
      return RouteInformation(location: '/schedule');
    }
    if (path is ScheduleDetailPath) {
      return RouteInformation(
          location:
              '/schedule/${DateFormat("yyyyMMdd").format(path.day)}/${path.id}');
    }
    if (path is ScheduleListViewPath) {
      var p = DateFormat('yyyyMMdd').format(path.day);
      return RouteInformation(location: '/schedule/$p');
    }

    if (path is TodoPath) {
      return RouteInformation(location: '/todo');
    }

    if (path is SearchPath) {
      return RouteInformation(location: '/search');
    }

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
      // /login
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
    if (path is SchedulePath) {
      appState.selectedIndex = 0;
      appState.selectedDay = null;
      appState.selectedSchedule = null;
    } else if (path is ScheduleListViewPath) {
      appState.setSelectedDay(path.day);
    } else if (path is ScheduleDetailPath) {
      appState.setSelectedScheduleById(path.day, path.id);
    } else if (path is TodoPath) {
      appState.selectedIndex = 1;
    } else if (path is SearchPath) {
      appState.selectedIndex = 2;
    } else if (path is SettingsPath) {
      appState.selectedIndex = 3;
      appState.isSelectedUserSettings = false;
    } else if (path is UserSettingsPath) {
      appState.isSelectedUserSettings = true;
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

    if (size.width > 500) {
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
                  appState.selectedIndex = 3;
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
                appState.selectedIndex = 3;
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
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.schedule), label: 'Schedule'),
          BottomNavigationBarItem(
              icon: Icon(Icons.task_rounded), label: 'ToDo'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
        currentIndex: appState.selectedIndex,
        onTap: (newIndex) {
          if (appState.selectedIndex == newIndex) {
            switch (appState.selectedIndex) {
              case 0: // schedule
                appState.selectedDay = null;
                appState.selectedSchedule = null;
                break;
              case 1: // todo
                break;
              case 2: // search
                break;
              case 3: // settings
                appState.isSelectedUserSettings = false;
                break;
            }
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
      pages: [
        if (appState.selectedIndex == 0) ...[
          FadeAnimationPage(
              child: SchedulePage(
                handleOpenList: _handleOpenScheduleList,
                scheduleCollection: appState.scheduleCollection,
              ),
              key: ValueKey('SchedulePage')),
          if (appState.selectedDay != null)
            MaterialPage(
                child: ScheduleListOnDay(
                    handleOpenScheduleDetails: _handleOpenScheduleDetails,
                    targetDate: appState.selectedDay,
                    addSchedule: appState.addSchedule,
                    deleteSchedule: appState.deleteSchedule,
                    schedules: appState.getScheduleList(appState.selectedDay))),
          if (appState.selectedSchedule != null)
            MaterialPage(
                child: ScheduleDetails(
              schedule: appState.selectedSchedule,
              deleteSchedule: appState.deleteSchedule,
            )),
        ] else if (appState.selectedIndex == 1)
          FadeAnimationPage(child: TodoPage(), key: ValueKey('TodoPage'))
        else if (appState.selectedIndex == 2)
          FadeAnimationPage(child: SearchPage(), key: ValueKey('SearchPage'))
        else ...[
          FadeAnimationPage(
            child: SettingsPage(
                handleOpenUserSettings: this._handleOpenUserSettings,
                signOut: appState.signOut),
            key: ValueKey('SettingsPage'),
          ),
          if (appState.isSelectedUserSettings)
            MaterialPage(
                key: ValueKey('UserSettingPage'),
                child: UserAccountView(
                  user: appState.getCurrentUser(),
                ))
        ]
      ],
      onPopPage: (route, result) {
        switch (appState.selectedIndex) {
          case 0:
            if (appState.selectedDay != null) {
              if (appState.selectedSchedule != null) {
                appState.selectedSchedule = null;
              } else {
                appState.selectedDay = null;
              }
            } else {
              appState.selectedDay = null;
              appState.selectedSchedule = null;
            }
            break;
          case 1:
            break;
          case 2:
            break;
          case 3:
            appState.isSelectedUserSettings = false;
            break;
        }
        notifyListeners();
        return route.didPop(result);
      },
    );
  }

  @override
  Future<void> setNewRoutePath(RoutePath path) async {
    assert(false);
  }

  void _handleOpenScheduleList(DateTime day) {
    appState.selectedDay = day;
    notifyListeners();
  }

  void _handleOpenUserSettings() {
    appState.isSelectedUserSettings = true;
    notifyListeners();
  }

  void _handleOpenScheduleDetails(Schedule schedule) {
    appState.selectedSchedule = schedule;
    notifyListeners();
  }
}

class FadeAnimationPage extends Page {
  final Widget child;

  FadeAnimationPage({Key key, this.child}) : super(key: key);

  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (context, animation, animation2) {
        var curveTween = CurveTween(curve: Curves.easeInOut);
        return FadeTransition(
          opacity: animation.drive(curveTween),
          child: child,
        );
      },
    );
  }
}

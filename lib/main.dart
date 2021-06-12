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
  runApp(ProviderScope(child: MyApp()));
}

class MyRouteAppState{
  MyRouteAppState({this.routeInformationParser,this.routerDelegate});
  RouteInformationParser routeInformationParser;
  RouterDelegate routerDelegate;
}
class MyRouteAppStateNotifier extends StateNotifier<MyRouteAppState>{
  MyRouteAppStateNotifier() : super(MyRouteAppState(routerDelegate: MyRouterDelegate(),routeInformationParser: MyRouteInformationParser()));
}

final myAppStateProvider = StateNotifierProvider((ref) => MyRouteAppStateNotifier());

class MyApp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final myAppState = useProvider(myAppStateProvider);
    return MaterialApp.router(
      routeInformationParser: myAppState.routeInformationParser,
      routerDelegate: myAppState.routerDelegate
    );
  }
}

class MyAppState extends StateNotifier<int>{
  MyAppState() : super(0);
  int get selectedIndex => this.state;
  set selectedIndex(int idx){
    this.state = idx;
  }
}
final appStateProvider = StateNotifierProvider<MyAppState,int>((ref) => MyAppState());

abstract class RoutePath {}

class HomePath extends RoutePath {}

class SchedulePath extends RoutePath {}

class TodoPath extends RoutePath {}

class SettingsPath extends RoutePath {}

class MyRouteInformationParser extends RouteInformationParser<RoutePath> {
  @override
  Future<RoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location);

    if (uri.pathSegments.length == 0) {
      return HomePath();
    }
    return HomePath();
  }

  @override
  RouteInformation restoreRouteInformation(RoutePath path) {
    if (path is HomePath) {
      return RouteInformation(location: '/home');
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

  MyRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  final appState = useProvider(appStateProvider.notifier);

  RoutePath get currentConfiguration {
    if (appState.selectedIndex == 0) {
      // hoem
      return HomePath();
    } else if (appState.selectedIndex == 1) {
      // schedule
      return SchedulePath();
    } else if (appState.selectedIndex == 2) {
      // todo
      return TodoPath();
    }else {
      // settings
      return SettingsPath(); // UnknownPath?
    } 
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(child: AppShell()),
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
    } else if (path is SchedulePath) {
      appState.selectedIndex = 1;
    } else if (path is TodoPath) {
      appState.selectedIndex = 2;
    } else if (path is SettingsPath) {
      appState.selectedIndex = 3;
    }
  }
}

class AppShell extends HookWidget {
  InnerRouterDelegate _routerDelegate;
  @override
  Widget build(BuildContext context) {
    var appState = useProvider();
    return Scaffold(
      appBar: AppBar(),
    body: Router(
      routerDelegate: _routerDelegate,
      backButtonDispatcher: ,
    ),
    bottomNavigationBar: BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.schedule),label: 'Schedule'),
        BottomNavigationBarItem(icon: Icon(Icons.task),label: 'ToDo'),
        BottomNavigationBarItem(icon: Icon(Icons.settings),label: 'Settings'),
      ],
      currentIndex: appState.selectedIndex,
      onTap: (newIndex){
        appState.selectedIndex = newIndex;
      },
    ),
    );
  }
}

class InnerRouterDelegate extends RouterDelegate<RoutePath> with ChangeNotifier, PopNavigatorRouterDelegateMixin<RoutePath> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  InnerRouterDelegate(this._appState);

  @override
  Widget build(BuildContext context){
    return Navigator(
      key: navigatorKey,
      pages: [
        if (appState.selectedIndex == 0)
          FadeAnimationPage(
            child:HomePage(),
            key: ValueKey('HomePage')
          ),
        else if(appState.selectedIndex == 1)
        FadeAnimationPage(
          child: SettingsPage()
        ),
        else 
        FadeAnimationPage(
          child:
        )
      ],
      onPopPage: (route,result){
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
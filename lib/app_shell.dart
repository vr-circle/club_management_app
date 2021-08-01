import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_state.dart';
import 'package:flutter_application_1/route_path.dart';
import 'package:flutter_application_1/shell_list.dart';
import 'package:flutter_application_1/store/store_service.dart';

class AppShell extends StatefulWidget {
  AppShell(this._appState);
  final AppState _appState;
  @override
  _AppShellState createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  InnerRouterDelegate _innerRouterDelegate;
  ChildBackButtonDispatcher _childBackButtonDispatcher;
  Future<bool> _future;
  @override
  void initState() {
    super.initState();
    dbService = FireStoreService(user: widget._appState.user);
    _future = widget._appState.initUserSettings();
    _innerRouterDelegate = InnerRouterDelegate(widget._appState);
  }

  @override
  void didUpdateWidget(covariant AppShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    _innerRouterDelegate.appState = widget._appState;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _childBackButtonDispatcher = Router.of(context)
        .backButtonDispatcher
        .createChildBackButtonDispatcher();
  }

  @override
  Widget build(BuildContext context) {
    // final appState = widget._appState;
    _childBackButtonDispatcher.takePriority();
    return FutureBuilder(
        future: _future,
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: const CircularProgressIndicator(),
            );
          }
          return Scaffold(
            body: Router(
              routerDelegate: _innerRouterDelegate,
              backButtonDispatcher: _childBackButtonDispatcher,
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              selectedFontSize: 12,
              items: shellList
                  .map((e) =>
                      BottomNavigationBarItem(icon: e.icon, label: e.name))
                  .toList(),
              currentIndex: widget._appState.bottomNavigationIndex,
              onTap: (newIndex) {
                widget._appState.bottomNavigationIndex = newIndex;
              },
            ),
          );
        });
  }
}

class InnerRouterDelegate extends RouterDelegate<RoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RoutePath> {
  InnerRouterDelegate(this._appState);

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  AppState _appState;
  set appState(AppState appState) {
    if (_appState == appState) {
      return;
    }
    _appState = appState;
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: this.navigatorKey,
      pages:
          shellList[this._appState.bottomNavigationIndex].getPages(_appState),
      onPopPage: (route, result) {
        shellList[this._appState.bottomNavigationIndex].onPopPage(_appState);
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

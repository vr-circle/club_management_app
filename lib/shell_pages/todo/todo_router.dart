// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/app_state.dart';
// import 'package:flutter_application_1/route_path.dart';
// import 'package:flutter_application_1/shell_pages/todo/todo_app_state.dart';
// import 'package:flutter_application_1/shell_pages/todo/todo_home_page.dart';

// class TodoRouter extends StatefulWidget {
//   TodoRouter(this._appState);
//   final AppState _appState;
//   _TodoRouterState createState() => _TodoRouterState();
// }

// class _TodoRouterState extends State<TodoRouter> {
//   _TodoRouterState();
//   TodoRouterDelegate _todoRouterDelegate;
//   ChildBackButtonDispatcher _childBackButtonDispatcher;
//   @override
//   void initState() {
//     super.initState();
//     _todoRouterDelegate = TodoRouterDelegate(widget._appState);
//   }

//   @override
//   Widget build(BuildContext context) {
//     _childBackButtonDispatcher.takePriority();
//     return Scaffold(
//       body: Router(
//         routerDelegate: _todoRouterDelegate,
//         backButtonDispatcher: _childBackButtonDispatcher,
//       ),
//     );
//   }
// }

// class TodoRouterDelegate extends RouterDelegate<RoutePath>
//     with ChangeNotifier, PopNavigatorRouterDelegateMixin<RoutePath> {
//   TodoRouterDelegate(this.appState)
//       : navigatorKey = GlobalKey<NavigatorState>(),
//         _todoAppState = TodoAppState() {
//     _todoAppState.addListener(notifyListeners);
//   }
//   final GlobalKey<NavigatorState> navigatorKey;
//   final AppState appState;
//   final TodoAppState _todoAppState;
//   @override
//   Widget build(BuildContext context) {
//     return Navigator(
//       key: navigatorKey,
//       pages: [
//         MaterialPage(
//             child: TodoHomePage(
//           appState: appState,
//           todoAppState: _todoAppState,
//         )),
//       ],
//       onPopPage: (route, result) {
//         appState.targetTodoTabId = '';
//         notifyListeners();
//         return route.didPop(result);
//       },
//     );
//   }

//   @override
//   Future<void> setNewRoutePath(RoutePath configuration) async {
//     assert(false);
//   }
// }

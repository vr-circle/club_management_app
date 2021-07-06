import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_state.dart';
import 'package:flutter_application_1/pages/todo/todo_collection.dart';
import 'package:flutter_application_1/route_path.dart';

class TodoPage extends StatefulWidget {
  TodoPage({Key key, @required this.appState}) : super(key: key);
  final MyAppState appState;
  TodoPageState createState() => TodoPageState();
}

class TodoPageState extends State<TodoPage>
    with SingleTickerProviderStateMixin {
  TodoRouterDelegate _routerDelegate;
  ChildBackButtonDispatcher _backButtonDispatcher;

  Future<List<String>> futureTabs;
  List<String> tabs;

  Future<List<String>> getTabs() async {
    await Future.delayed(Duration(seconds: 1));
    tabs = ['private', 'circle'];
    return tabs;
  }

  @override
  void initState() {
    _routerDelegate = TodoRouterDelegate(widget.appState);
    futureTabs = getTabs();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TodoPage oldWidget) {
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
    return FutureBuilder(
      future: futureTabs,
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return DefaultTabController(
            length: tabs.length,
            child: Scaffold(
                appBar: AppBar(
                  flexibleSpace: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TabBar(
                          tabs: this
                              .tabs
                              .map((e) => Tab(
                                    text: e,
                                  ))
                              .toList())
                    ],
                  ),
                ),
                body: Router(
                  routerDelegate: _routerDelegate,
                  backButtonDispatcher: _backButtonDispatcher,
                )));
      },
    );
  }
}

class TodoRouterDelegate extends RouterDelegate<RoutePath>
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

  TodoRouterDelegate(this._appState);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
          child: TabBarView(children: [
            Container(
              child: Center(
                child: Text('private'),
              ),
            ),
            Container(
              child: Center(
                child: Text('circle'),
              ),
            )
          ]),
        )
      ],
      onPopPage: (route, result) {
        // navigationList[appState.selectedIndex].onPopPage(appState);
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

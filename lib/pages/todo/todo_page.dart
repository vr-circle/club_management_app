import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_state.dart';
import 'package:flutter_application_1/pages/todo/todo_collection.dart';

class TodoPage extends StatefulWidget {
  TodoPage({Key key, @required this.appState}) : super(key: key);
  final MyAppState appState;
  TodoPageState createState() => TodoPageState();
}

class TodoPageState extends State<TodoPage> {
  Future<Map<String, TodoCollection>> futureTabs;
  Map<String, TodoCollection> tabs;

  Future<Map<String, TodoCollection>> getTabs() async {
    await Future.delayed(Duration(seconds: 2));
    tabs = {'Private': TodoCollection(), 'ClubA': TodoCollection()};
    return tabs;
  }

  @override
  void initState() {
    futureTabs = getTabs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureTabs,
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, TodoCollection>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          return TodoTabController(tabs: tabs, appState: widget.appState);
        });
  }
}

class TodoTabController extends StatefulWidget {
  TodoTabController({Key key, @required this.tabs, @required this.appState})
      : super(key: key);
  MyAppState appState;
  Map<String, TodoCollection> tabs;
  @override
  TodoTabControllerState createState() => TodoTabControllerState();
}

class TodoTabControllerState extends State<TodoTabController>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
        length: widget.tabs.length,
        vsync: this,
        initialIndex: widget.appState.selectedTabInTodo);
    _tabController.addListener(_handleTabSelection);
    super.initState();
  }

  @override
  void dispose() {
    this._tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      return;
    }
    widget.appState.selectedTabInTodo = _tabController.index;
    print(widget.appState.selectedTabInTodo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TabBar(
                controller: _tabController,
                tabs: widget.tabs.entries
                    .map((e) => Tab(
                          text: e.key,
                        ))
                    .toList())
          ],
        ),
      ),
      body: Builder(builder: (context) {
        return TabBarView(
          controller: _tabController,
          children: widget.tabs.entries
              .map((e) => Center(
                    child: Text(e.key),
                  ))
              .toList(),
        );
      }),
    );
  }
}

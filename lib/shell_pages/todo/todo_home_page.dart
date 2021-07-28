import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_state.dart';
import 'package:flutter_application_1/shell_pages/search/organization_info.dart';
import 'package:flutter_application_1/shell_pages/todo/todo_app_state.dart';
import 'package:flutter_application_1/shell_pages/todo/todo_collection.dart';

class TodoHomePage extends StatefulWidget {
  TodoHomePage(
      {Key key,
      @required this.appState,
      @required this.participatingOrganizationList})
      : super(key: key);
  final AppState appState;
  final List<OrganizationInfo> participatingOrganizationList;
  _TodoHomePageState createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage>
    with TickerProviderStateMixin {
  TabController _tabController;
  TodoAppState _todoAppState;
  Future<bool> _future;

  @override
  void initState() {
    _todoAppState = TodoAppState();
    _todoAppState.addListener(() {
      setState(() {});
    });
    _future = _initTabInfo();
    super.initState();
  }

  Future<bool> _initTabInfo() async {
    await _todoAppState.initTabInfo(widget.participatingOrganizationList);
    return true;
  }

  void _handleChangeTab() {
    if (_tabController.indexIsChanging == false) {
      _todoAppState.handleChangeTabIndex(widget.appState, _tabController.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Row(
          children: [
            const FlutterLogo(),
            const Text('CMA'),
          ],
        )),
        body: FutureBuilder(
            future: _future,
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(
                  child: const CircularProgressIndicator(),
                );
              }
              if (_tabController != null) _tabController.dispose();
              _tabController = TabController(
                  length: _todoAppState.tabLength,
                  vsync: this,
                  initialIndex: _todoAppState
                      .getTabIndex(widget.appState.targetTodoTabId));
              _tabController.addListener(_handleChangeTab);
              return Scaffold(
                  appBar: AppBar(
                    flexibleSpace: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TabBar(
                          controller: _tabController,
                          tabs: _todoAppState.getTabList(),
                        )
                      ],
                    ),
                  ),
                  body: TabBarView(
                      controller: _tabController,
                      children: _todoAppState
                          .getTodoCollectionList()
                          .map((e) => TodoTabBarView(
                                todoCollection: e,
                              ))
                          .toList()));
            }));
  }
}

class TodoTabBarView extends StatefulWidget {
  TodoTabBarView({@required this.todoCollection});
  final TodoCollection todoCollection;
  _TodoTabBarViewState createState() => _TodoTabBarViewState();
}

class _TodoTabBarViewState extends State<TodoTabBarView> {
  @override
  void initState() {
    widget.todoCollection.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    widget.todoCollection.removeListener(() {
      setState(() {});
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: widget.todoCollection.getSortedTaskMapWidget()),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.library_add),
        onPressed: () async {
          String newName;
          await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Add group'),
                  content: TextField(
                    onChanged: (value) {
                      newName = value;
                    },
                  ),
                  actions: [
                    TextButton(
                        onPressed: () async {
                          await widget.todoCollection.addGroup(newName);
                          Navigator.pop(context);
                        },
                        child: const Text('Add')),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel')),
                  ],
                );
              });
        },
      ),
    );
  }
}

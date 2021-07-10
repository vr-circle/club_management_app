import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_state.dart';
import 'package:flutter_application_1/pages/todo/task.dart';
import 'package:flutter_application_1/pages/todo/task_list.dart';
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
    await Future.delayed(Duration(seconds: 1));
    final tmp = TodoCollection();
    final tmpa = TodoCollection();
    tabs = {'Private': tmp, 'ClubA': tmpa};
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
  final MyAppState appState;
  final Map<String, TodoCollection> tabs;
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
        body: TabBarView(
            controller: _tabController,
            children: widget.tabs.entries
                .map((e) => TaskListTab(e.key, e.value))
                .toList()));
  }
}

class TaskListTab extends StatefulWidget {
  TaskListTab(this.targetClubId, this.todoCollection);
  final String targetClubId;
  final TodoCollection todoCollection;
  TaskListTabState createState() => TaskListTabState();
}

class TaskListTabState extends State<TaskListTab> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.todoCollection.initTasks(),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, List<Task>>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                print('add!');
              },
            ),
            body: ListView(
              children: widget.todoCollection.taskMap.entries.map((e) {
                return TaskExpansionTile(
                  groupName: e.key,
                  taskList: e.value,
                );
              }).toList(),
            ),
          );
        });
  }
}

class TaskExpansionTile extends StatefulWidget {
  TaskExpansionTile({Key key, this.groupName, this.taskList}) : super(key: key);
  final String groupName;
  final List<Task> taskList;
  TaskExpansionTileState createState() => TaskExpansionTileState();
}

class TaskExpansionTileState extends State<TaskExpansionTile> {
  TaskList taskList;
  @override
  void initState() {
    // this.taskList = TaskList(widget.taskList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this.taskList = TaskList(widget.taskList);
    return ExpansionTile(
        leading: Icon(Icons.menu_book),
        onExpansionChanged: (value) {
          // scroll?
        },
        title: Text(widget.groupName),
        children: this.taskList.buildTaskListTile(() {
          setState(() {});
        }));
  }
}

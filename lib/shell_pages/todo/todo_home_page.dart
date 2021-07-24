import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_state.dart';
import 'package:flutter_application_1/shell_pages/todo/task.dart';
import 'package:flutter_application_1/shell_pages/todo/todo_app_state.dart';
import 'package:flutter_application_1/shell_pages/todo/todo_collection.dart';
import 'package:flutter_application_1/store/store_service.dart';
import 'package:tuple/tuple.dart';

class TodoHomePage extends StatefulWidget {
  TodoHomePage({Key key, @required this.appState, @required this.idAndNameList})
      : super(key: key);
  final AppState appState;
  final List<Tuple2<String, String>> idAndNameList;
  _TodoHomePageState createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  TodoAppState todoAppState;
  Future<List<String>> _future;

  @override
  void initState() {
    todoAppState = TodoAppState(widget.idAndNameList);
    todoAppState.addListener(() {
      setState(() {});
    });
    _tabController =
        TabController(length: widget.idAndNameList.length, vsync: this);
    super.initState();
  }

  Future<List<String>> initTabInfo()async{
    await todoAppState.initTabInfo();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot){
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TabBar(
                  controller: _tabController,
                  tabs: widget.tabs
                      .map((e) => Tab(
                            text: e.name,
                          ))
                      .toList())
            ],
          ),
        ),
        body: TabBarView(
            controller: _tabController,
            children: widget.tabs.map((e) => TaskListTab(e.id)).toList()));
    });
  }
}

class TodoTabView extends StatefulWidget {
  TodoTabView({@required this.todoCollection});
  final TodoCollection todoCollection;
  @override
  _TodoTabViewState createState() => _TodoTabViewState();
}

class _TodoTabViewState extends State<TodoTabView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(builder: (BuildContext context, AsyncSnapshot<void> snapshot){
      if(snapshot.connectionState != ConnectionState.done){
        return const Center(child: const CircularProgressIndicator(),);
      }
      return Scaffold(
        body: ListView(
            children: widget.todoCollection
                .getSortedKey()
                .map((e) => TaskExpansionTile(
                    groupName: e,
                    taskList: widget.todoCollection.taskMap[e],
                    deleteGroup: () async {
                    }))
                .toList()),
      );
    });
  }
}

class TaskExpansionTile extends StatefulWidget {
  TaskExpansionTile({
    Key key,
    @required this.organizationId,
    @required this.groupName,
    @required this.taskList,
    @required this.deleteGroup,
  }) : super(key: key);
  final String organizationId;
  final String groupName;
  final List<Task> taskList;
  final Future<void> Function() deleteGroup;
  TaskExpansionTileState createState() => TaskExpansionTileState();
}

class TaskExpansionTileState extends State<TaskExpansionTile> {
  bool isOpenExpansion;
  TaskList taskList;
  @override
  void initState() {
    isOpenExpansion = false;
    taskList = TaskList(widget.taskList);
    super.initState();
  }

  Future<void> addTask(Task task) async {
    await dbService.addTask(task, widget.groupName, widget.organizationId);
    setState(() {
      taskList.addTask(task);
    });
  }

  Future<void> deleteTask(Task targetTask) async {
    await dbService.deleteTask(
        targetTask, widget.groupName, widget.organizationId);
    setState(() {
      taskList.deleteTask(targetTask);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

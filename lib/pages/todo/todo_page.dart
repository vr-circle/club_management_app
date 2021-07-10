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
  Future<Map<String, String>> futureTabs;
  Map<String, String> tabs;

  Future<Map<String, String>> getTabs() async {
    await Future.delayed(Duration(seconds: 1));
    tabs = {'privateID': 'private', 'clubAID': 'clubA', 'clubBID': 'ClubB'};
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
            AsyncSnapshot<Map<String, String>> snapshot) {
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
  final Map<String, String> tabs;
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
                            text: e.value, // name
                          ))
                      .toList())
            ],
          ),
        ),
        body: TabBarView(
            controller: _tabController,
            children:
                widget.tabs.entries.map((e) => TaskListTab(e.key)).toList()));
  }
}

class TaskListTab extends StatefulWidget {
  TaskListTab(this.targetId);
  final String targetId;
  TaskListTabState createState() => TaskListTabState();
}

class TaskListTabState extends State<TaskListTab> {
  final TodoCollection todoCollection = TodoCollection();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('rebuild');
    return FutureBuilder(
        future: todoCollection.initTasks(widget.targetId),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, List<Task>>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add_to_photos_outlined),
              onPressed: () async {
                TextEditingController controller = TextEditingController();
                await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SimpleDialog(
                        title: Text('Add Group'),
                        children: [
                          Padding(
                              padding: EdgeInsets.all(8),
                              child: TextField(
                                controller: controller,
                                decoration:
                                    InputDecoration(labelText: 'New Group'),
                              )),
                          TextButton(
                              onPressed: () async {
                                await todoCollection.addGroup(controller.text);
                                setState(() {});
                                Navigator.pop(context);
                              },
                              child: Text('Add')),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel')),
                        ],
                      );
                    });
              },
            ),
            body: ListView(
              children: todoCollection.taskMap.entries.map((e) {
                return TaskExpansionTile(
                  groupName: e.key,
                  taskList: TaskList(e.value),
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
  final TaskList taskList;
  TaskExpansionTileState createState() => TaskExpansionTileState();
}

class TaskExpansionTileState extends State<TaskExpansionTile> {
  bool isOpenExpansion;
  @override
  void initState() {
    isOpenExpansion = false;
    super.initState();
  }

  void addTask(Task task) {
    setState(() {
      widget.taskList.addTask(task);
    });
  }

  void deleteTask(Task task) {
    setState(() {
      widget.taskList.deleteTask(task);
    });
  }

  void toggleDone(Task task) {
    setState(() {
      widget.taskList.toggleDone(task);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        trailing: IconButton(
          icon: Icon(Icons.add),
          onPressed: () async {
            TextEditingController controller = TextEditingController();
            await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    title: Text(''),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: TextField(
                          controller: controller,
                          decoration: InputDecoration(
                            labelText: 'Enter new task title',
                          ),
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            addTask(Task(title: controller.text));
                            Navigator.pop(context);
                          },
                          child: Text('add')),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('cancel')),
                    ],
                  );
                });
          },
        ),
        initiallyExpanded: isOpenExpansion,
        leading: isOpenExpansion ? Icon(Icons.folder_open) : Icon(Icons.folder),
        onExpansionChanged: (value) {
          setState(() {
            isOpenExpansion = value;
          });
        },
        title: Text(widget.groupName),
        children: widget.taskList.taskList.map((Task task) {
          return TaskListTile(
              task: task,
              deleteTask: () {
                deleteTask(task);
              },
              addTask: () {
                addTask(task);
              },
              toggleDone: () {
                toggleDone(task);
              });
        }).toList());
  }
}

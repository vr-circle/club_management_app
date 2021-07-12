import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_state.dart';
import 'package:flutter_application_1/shell_pages/todo/task.dart';
import 'package:flutter_application_1/shell_pages/todo/task_list.dart';
import 'package:flutter_application_1/shell_pages/todo/todo_collection.dart';
import 'package:flutter_application_1/store/store_service.dart';

class TabInfo {
  String name;
  String id;
  TabInfo({@required this.id, @required this.name});
}

class TodoPage extends StatefulWidget {
  TodoPage({Key key, @required this.appState}) : super(key: key);
  final MyAppState appState;
  TodoPageState createState() => TodoPageState();
}

class TodoPageState extends State<TodoPage> {
  Future<List<TabInfo>> futureTabs;
  List<TabInfo> tabs = [];

  Future<List<TabInfo>> getTabs() async {
    tabs.add(TabInfo(id: 'private', name: 'private'));
    final clubIdList = await dbService.getParticipatingOrganizationIdList();
    await Future.forEach(clubIdList, (id) async {
      final _clubInfo = await dbService.getOrganizationInfo(id);
      if (_clubInfo != null) {
        tabs.add(TabInfo(id: id, name: _clubInfo.name));
      }
    });
    return tabs;
  }

  @override
  void initState() {
    tabs = [];
    futureTabs = getTabs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureTabs,
        builder: (BuildContext context, AsyncSnapshot<List<TabInfo>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: const CircularProgressIndicator());
          }
          return TodoTabController(tabs: tabs, appState: widget.appState);
        });
  }
}

class TodoTabController extends StatefulWidget {
  TodoTabController({Key key, @required this.tabs, @required this.appState})
      : super(key: key);
  final MyAppState appState;
  final List<TabInfo> tabs;
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
  }
}

class TaskListTab extends StatefulWidget {
  TaskListTab(this.organizationId);
  final String organizationId;
  TaskListTabState createState() => TaskListTabState();
}

class TaskListTabState extends State<TaskListTab> {
  final TodoCollection todoCollection = TodoCollection();

  @override
  void initState() {
    super.initState();
  }

  Future<void> addGroup(String name) async {
    await todoCollection.addGroup(name, widget.organizationId);
    setState(() {});
  }

  Future<void> deleteGroup(String groupName) async {
    await todoCollection.deleteGroup(groupName, widget.organizationId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: todoCollection.initTasks(widget.organizationId),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, List<Task>>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: const CircularProgressIndicator(),
            );
          }
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add_to_photos_outlined),
              onPressed: () async {
                TextEditingController controller = TextEditingController();
                await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Add Group'),
                        content: Padding(
                            padding: const EdgeInsets.all(8),
                            child: TextField(
                              controller: controller,
                              decoration:
                                  const InputDecoration(labelText: 'New Group'),
                            )),
                        actions: [
                          TextButton(
                              onPressed: () async {
                                await todoCollection.addGroup(
                                    controller.text, widget.organizationId);
                                setState(() {});
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
            body: ListView(
              children: todoCollection.taskMap.entries.map((e) {
                return TaskExpansionTile(
                  organizationId: widget.organizationId,
                  groupName: e.key,
                  taskList: e.value,
                  deleteGroup: () async {
                    await deleteGroup(e.key);
                  },
                );
              }).toList(),
            ),
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onLongPress: () async {
          await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(widget.groupName),
                  content: Text('Do you want to remove ${widget.groupName}?'),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () async {
                          await widget.deleteGroup();
                          Navigator.pop(context);
                        },
                        child: const Text('Delete')),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel')),
                  ],
                );
              });
        },
        child: ExpansionTile(
            trailing: IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                TextEditingController controller = TextEditingController();
                await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Add task in ${widget.groupName}'),
                        content: Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextField(
                            controller: controller,
                            decoration: const InputDecoration(
                              labelText: 'Enter new task title',
                              icon: const Icon(Icons.task),
                            ),
                            onSubmitted: (value) async {
                              await addTask(Task(title: value));
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () async {
                                await addTask(Task(title: controller.text));
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
            initiallyExpanded: isOpenExpansion,
            leading:
                isOpenExpansion ? Icon(Icons.folder_open) : Icon(Icons.folder),
            onExpansionChanged: (value) {
              setState(() {
                isOpenExpansion = value;
              });
            },
            title: Text(widget.groupName),
            children: taskList.getListTiles(this.deleteTask)));
  }
}

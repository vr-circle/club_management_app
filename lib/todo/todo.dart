import 'package:flutter/material.dart';
import 'package:flutter_application_1/store/store_service.dart';
import 'package:flutter_application_1/todo/task.dart';
import 'package:flutter_application_1/todo/task_list.dart';

import 'todo_tab_page.dart';

class TodoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BuildDefaultTabController();
  }
}

class BuildDefaultTabController extends StatefulWidget {
  @override
  BuildDefaultTabControllerState createState() =>
      BuildDefaultTabControllerState();
}

class BuildDefaultTabControllerState extends State<BuildDefaultTabController> {
  Future<Map<String, TaskList>> _futureTaskMap;
  Map<String, TaskList> _taskMap;

  Future<Map<String, TaskList>> getTaskMap() async {
    final Map<String, TaskList> data = await storeService.getTaskMap();
    _taskMap = data;
    return data;
  }

  Future<void> _addTask(Task task, String target) async {
    await storeService.addTask(task, target);
    setState(() {
      _taskMap[target].addTask(task.title);
    });
  }

  Future<void> _deleteTask(Task task, String target) async {
    await storeService.deleteTask(task, target);
    setState(() {
      _taskMap[target].deleteTask(task);
    });
  }

  @override
  void initState() {
    _futureTaskMap = getTaskMap();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureTaskMap,
      builder: (BuildContext context,
          AsyncSnapshot<Map<String, TaskList>> snapshot) {
        return DefaultTabController(
          length: _taskMap.length,
          child: Scaffold(
            appBar: AppBar(
              flexibleSpace: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TabBar(
                    tabs: this
                        ._taskMap
                        .keys
                        .toList()
                        .map((e) => Tab(
                              text: e,
                            ))
                        .toList(),
                  )
                ],
              ),
            ),
            body: TabBarView(
              children: this
                  ._taskMap
                  .values
                  .toList()
                  .map((e) => TodoTabPage(tasks: e))
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}

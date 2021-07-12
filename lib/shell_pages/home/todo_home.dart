import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/route_path.dart';
import 'package:flutter_application_1/shell_pages/todo/task.dart';
import 'package:flutter_application_1/store/store_service.dart';

class TodoHomeView extends StatelessWidget {
  TodoHomeView({Key key, this.handleChangeSelectedIndex}) : super(key: key);
  final void Function(int index) handleChangeSelectedIndex;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ListTile(
          title: Text('Todo List'),
        ),
        TodoPartsListView(),
        TextButton(
            onPressed: () {
              handleChangeSelectedIndex(TodoPath.index);
            },
            child: const Text('More')),
      ],
    );
  }
}

class TodoPartsListView extends StatefulWidget {
  TodoPartsListView({Key key, this.handleChangeSelectedIndex})
      : super(key: key);
  final void Function(int index) handleChangeSelectedIndex;
  TodoPartsListViewState createState() => TodoPartsListViewState();
}

class TodoPartsListViewState extends State<TodoPartsListView> {
  Future<List<Task>> futureTmp;
  List<Task> taskList = [];
  Future<List<Task>> getTaskList() async {
    final Map<String, List<Task>> data = await dbService.getTaskList('private');
    final res = [];
    data.forEach((key, value) {
      res.addAll(value);
    });
    taskList = res;
    return taskList;
  }

  @override
  void initState() {
    taskList = [];
    futureTmp = getTaskList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureTmp,
        builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: const CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            print(snapshot.error);
          }
          print(taskList);
          return ListView.builder(
              shrinkWrap: true,
              itemCount: min(taskList.length, 3),
              itemBuilder: (BuildContext context, int index) {
                return Card(
                    child: ListTile(
                  title: Text(taskList[index].title),
                ));
              });
        });
  }
}

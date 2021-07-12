import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/todo/task.dart';
import 'package:flutter_application_1/store/store_service.dart';

class TodoAddTaskPage extends StatefulWidget {
  TodoAddTaskPage(
      {Key key, @required this.listName, @required this.handleCloseAppPage})
      : super(key: key);
  final String listName;
  final void Function() handleCloseAppPage;
  TodoAddTaskPageState createState() => TodoAddTaskPageState();
}

class TodoAddTaskPageState extends State<TodoAddTaskPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add task')),
      body: Center(
        child: TextField(
          decoration: InputDecoration(labelText: 'Enter new task'),
          onSubmitted: (value) async {
            await dbService.setTask(Task(title: value), widget.listName);
          },
        ),
      ),
    );
  }
}

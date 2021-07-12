import 'package:flutter/material.dart';

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
      body: Center(),
    );
  }
}

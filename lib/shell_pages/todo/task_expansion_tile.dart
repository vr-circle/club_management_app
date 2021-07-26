import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/shell_pages/todo/task.dart';
import 'package:flutter_application_1/shell_pages/todo/task_list.dart';

class TaskExpansionTile extends StatefulWidget {
  TaskExpansionTile({
    Key key,
    @required this.groupName,
    @required this.taskList,
    @required this.addTask,
    @required this.deleteTask,
    @required this.deleteGroup,
  }) : super(key: key);
  final Future<void> Function(Task newTask) addTask;
  final Future<void> Function(Task targetTask) deleteTask;
  final Future<void> Function(String targetGroupName) deleteGroup;
  final String groupName;
  final TaskList taskList;
  _TaskExpansionTileState createState() => _TaskExpansionTileState();
}

class _TaskExpansionTileState extends State<TaskExpansionTile> {
  bool _isOpenExpansion;

  @override
  void initState() {
    _isOpenExpansion = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      onExpansionChanged: (value) {
        setState(() {
          _isOpenExpansion = value;
        });
      },
      title: Text(widget.groupName),
      children: widget.taskList.getTaskTileList(widget.deleteTask),
      trailing: IconButton(
        icon: const Icon(Icons.add),
        onPressed: () {
          print('Open adding task');
        },
      ),
    );
  }
}

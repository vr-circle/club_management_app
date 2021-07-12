import 'package:flutter/material.dart';
import 'task.dart';

class TaskListTile extends StatelessWidget {
  TaskListTile({
    Key key,
    @required this.task,
    @required this.deleteTask,
  }) : super(key: key);
  final Task task;
  final Future<void> Function(Task task) deleteTask;
  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      onLongPress: () {},
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () async {
          await deleteTask(task);
        },
      ),
      title: Text(this.task.title),
    ));
  }
}

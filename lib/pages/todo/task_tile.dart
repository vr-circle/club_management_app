import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/todo/task.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({this.task, this.checkboxCallback, this.longPressCallback});

  final Task task;
  final Function(bool) checkboxCallback;
  final Function() longPressCallback;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      child: GestureDetector(
        onLongPress: longPressCallback,
        child: CheckboxListTile(
          title: Text(
            task.title,
          ),
          value: task.isDone,
          onChanged: checkboxCallback,
        ),
      ),
    );
  }
}

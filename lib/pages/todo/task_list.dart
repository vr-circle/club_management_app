import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/todo/task.dart';

// handle delete, add and toggle

class TaskList {
  List<Task> taskList;
  TaskList(List<Task> initTaskList) {
    taskList = initTaskList;
  }

  List<Widget> buildTaskListTile(void Function() setState) {
    return taskList.map((e) {
      return TaskListTile(
        key: ValueKey(e.id),
        task: e,
        handleDelete: () {
          this.deleteTask(e);
          setState();
        },
      );
    }).toList();
  }

  void addTask(Task task) {
    taskList.add(task);
  }

  void deleteTask(Task task) {
    taskList = taskList.where((element) => element.id != task.id);
  }

  void toggleTask(Task task) {
    task.toggleDone();
  }
}

class TaskListTile extends StatelessWidget {
  TaskListTile({Key key, @required this.task, @required this.handleDelete})
      : super(key: key);
  final Task task;
  void Function() handleDelete;
  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      onTap: () {},
      onLongPress: () async {
        var res = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(task.title),
                // content: Text(''),
                actions: [
                  TextButton(
                      onPressed: () {
                        handleDelete();
                        Navigator.of(context).pop();
                      },
                      child: Text('delete')),
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('cancel')),
                ],
              );
            });
      },
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {},
      ),
      title: Text(task.title),
    ));
  }
}

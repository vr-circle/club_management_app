import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/shell_pages/todo/task.dart';
import 'package:flutter_application_1/shell_pages/todo/task_group.dart';

class TaskExpansionTile extends StatefulWidget {
  TaskExpansionTile({
    Key key,
    @required this.groupName,
    @required this.taskGroup,
    @required this.addTask,
    @required this.deleteTask,
    @required this.deleteGroup,
  }) : super(key: key);
  final String groupName;
  final TaskGroup taskGroup;
  final Future<void> Function(Task newTask) addTask;
  final Future<void> Function(Task targetTask) deleteTask;
  final Future<void> Function() deleteGroup;
  _TaskExpansionTileState createState() => _TaskExpansionTileState();
}

class _TaskExpansionTileState extends State<TaskExpansionTile> {
  bool _isOpenExpansion = false;

  @override
  void initState() {
    _isOpenExpansion = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onLongPress: () async {
          await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Delete ${widget.groupName}?'),
                  actions: [
                    TextButton(
                        onPressed: () async {
                          await widget.deleteGroup();
                          Navigator.pop(context);
                        },
                        child: const Text('Delete')),
                    TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel')),
                  ],
                );
              });
        },
        child: ExpansionTile(
          initiallyExpanded: _isOpenExpansion,
          onExpansionChanged: (value) {
            setState(() {
              _isOpenExpansion = value;
            });
          },
          title: Text(widget.groupName),
          children: widget.taskGroup
              .getSortedTaskList()
              .map((e) => Card(
                    child: ListTile(
                      title: Text(e.title),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          await widget.deleteTask(e);
                        },
                      ),
                    ),
                  ))
              .toList(),
          trailing: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              String newTaskName = '';
              await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Add task'),
                      content: TextField(
                        onChanged: (value) {
                          newTaskName = value;
                        },
                      ),
                      actions: [
                        TextButton(
                            onPressed: () async {
                              await widget.addTask(Task(title: newTaskName));
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
        ));
  }
}

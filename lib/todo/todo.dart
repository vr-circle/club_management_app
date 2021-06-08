import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'task_list.dart';

// todo: devide by category(private,club,other club) with tabbar

class TodoPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final taskList = useProvider(taskListProvider);
    return Scaffold(
      body: Consumer(builder: (context, watch, child) {
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            final task = taskList[index];
            return TaskTile(
              taskTitle: task.title,
              isChecked: task.isDone,
              checkboxCallback: (bool value) {
                taskList.toggleDone(task.id);
              },
              longPressCallback: () {
                // taskList.deleteTask(task);
              },
            );
          },
          itemCount: taskList.length,
        );
      }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return ToDoAddPage();
          }));
        },
      ),
    );
  }
}

class TaskTile extends HookWidget {
  const TaskTile(
      {this.isChecked,
      this.taskTitle,
      this.checkboxCallback,
      this.longPressCallback});

  final bool isChecked;
  final String taskTitle;
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
            taskTitle,
          ),
          value: isChecked,
          onChanged: checkboxCallback,
        ),
      ),
    );
  }
}

class ToDoAddPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    String _newTaskTitle = '';
    final _textEditingController = TextEditingController();
    return Scaffold(
        appBar: AppBar(
          title: Text('タスクの追加'),
        ),
        body: Container(
            padding: EdgeInsets.all(32),
            child: Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Consumer(builder: (context, watch, child) {
                  return TextField(
                    controller: _textEditingController,
                    onChanged: (newText) {
                      _newTaskTitle = newText;
                    },
                    onSubmitted: (newText) {
                      if (_newTaskTitle.isEmpty) {
                        return;
                      }
                      watch(taskListProvider.notifier).addTask(_newTaskTitle);
                      Navigator.of(context).pop();
                    },
                  );
                }),
                const SizedBox(
                  height: 8,
                ),
                Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Consumer(builder: (context, watch, child) {
                      return TextButton(
                          onPressed: () {
                            watch(taskListProvider.notifier)
                                .addTask(_newTaskTitle);
                            Navigator.of(context).pop();
                          },
                          child: Text('Add'));
                    }),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'キャンセル',
                          style: TextStyle(color: Colors.red),
                        )),
                  ],
                )),
              ]),
            )));
  }
}

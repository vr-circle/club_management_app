import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'task_list.dart';

class TodoPage extends HookWidget {
  static const String route = '/todo';
  @override
  Widget build(BuildContext context) {
    return BuildDefaultTabController();
  }
}

class BuildDefaultTabController extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _tabInfo = <String>[
      'private',
    ];
    return DefaultTabController(
        length: _tabInfo.length,
        child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TabBar(
                    isScrollable: true,
                    tabs: _tabInfo
                        .map((e) => Tab(
                              text: e,
                            ))
                        .toList())
              ],
            ),
            elevation: 0,
          ),
          body: TabBarView(children: [
            TodoPrivatePage(),
          ]),
        ));
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

class TabPage extends HookWidget {
  const TabPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('$title')),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}

class TodoPrivatePage extends HookWidget {
  TodoPrivatePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _taskListProvider = useProvider(taskListProvider.notifier);
    final taskList = useProvider(taskListProvider);
    return Scaffold(
      body: Consumer(
        builder: (context, watch, child) {
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              final task = taskList[index];
              return TaskTile(
                taskTitle: task.title,
                isChecked: task.isDone,
                checkboxCallback: (bool value) {
                  _taskListProvider.toggleDone(task.id);
                },
                longPressCallback: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return SimpleDialog(
                          title: Text(task.title),
                          children: [
                            SimpleDialogOption(
                              child: Text('削除'),
                              onPressed: () {
                                // delete task by id
                                Navigator.pop(context);
                              },
                            ),
                            SimpleDialogOption(
                              child: Text('キャンセル'),
                              onPressed: () => Navigator.pop(context),
                            )
                          ],
                        );
                      });
                },
              );
            },
            itemCount: taskList.length,
          );
        },
      ),
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

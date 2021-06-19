import 'package:flutter/material.dart';
import 'package:flutter_application_1/store/store_service.dart';
import 'package:flutter_application_1/todo/task.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ToDoAddPage extends StatelessWidget {
  ToDoAddPage(this.isPrivate, this.addTask);
  final Function(String title) addTask;
  final bool isPrivate;
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
                    onSubmitted: (newText) async {
                      if (_newTaskTitle.isEmpty) {
                        return;
                      }
                      addTask(_newTaskTitle);
                      storeService.addTask(
                          Task(title: _newTaskTitle), isPrivate);
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
                            if (_newTaskTitle.isEmpty) {
                              return;
                            }
                            addTask(_newTaskTitle);
                            storeService.addTask(
                                Task(title: _newTaskTitle), isPrivate);
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

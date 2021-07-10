import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/todo/task.dart';
import 'package:flutter_application_1/store/store_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ToDoAddPage extends StatelessWidget {
  ToDoAddPage(this.targetId, this.addTask);
  final Future<void> Function(Task task) addTask;
  final String targetId;
  @override
  Widget build(BuildContext context) {
    String _newTaskTitle = '';
    final _textEditingController = TextEditingController();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add a task'),
        ),
        body: Container(
            padding: const EdgeInsets.all(32),
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
                      addTask(Task(title: _newTaskTitle));
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
                          onPressed: () async {
                            if (_newTaskTitle.isEmpty) {
                              return;
                            }
                            addTask(Task(title: _newTaskTitle));
                            await storeService.addTask(
                                Task(title: _newTaskTitle), targetId);
                            Navigator.pop(context);
                          },
                          child: const Text('Add'));
                    }),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Cancel',
                          style: const TextStyle(color: Colors.red),
                        )),
                  ],
                )),
              ]),
            )));
  }
}

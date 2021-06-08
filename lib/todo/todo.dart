import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// final todoProvider = ChangeNotifierProvider((ref) => )

class TodoPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Card(
            child: ListTile(
              title: Text("hogehoge"),
            ),
          ),
          Card(
            child: ListTile(
              title: Text("hogehoge"),
            ),
          ),
          Card(
            child: ListTile(
              title: Text("hogehoge"),
            ),
          ),
          Card(
            child: ListTile(
              title: Text("hogehoge"),
            ),
          ),
          Card(
            child: ListTile(
              title: Text("hogehoge"),
            ),
          ),
        ],
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
    return Scaffold(
        appBar: AppBar(
          title: Text('タスクの追加'),
        ),
        body: Container(
            padding: EdgeInsets.all(32),
            child: Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextField(),
                const SizedBox(
                  height: 8,
                ),
                Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          '追加',
                          style: TextStyle(color: Colors.lightBlue),
                        )),
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

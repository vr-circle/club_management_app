import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/home/todo_parts.dart';
import 'package:flutter_application_1/route_path.dart';

class TodoHomeView extends StatelessWidget {
  TodoHomeView({Key key, this.handleChangeSelectedIndex}) : super(key: key);
  final void Function(int index) handleChangeSelectedIndex;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ListTile(
          title: Text('Todo List'),
        ),
        TodoPartsListView(),
        TextButton(
            onPressed: () {
              handleChangeSelectedIndex(TodoPath.index);
            },
            child: const Text('More')),
      ],
    );
  }
}

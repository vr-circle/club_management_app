import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Todo extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DropdownButton(
        items: [
          DropdownMenuItem(
              value: "hogehoge",
              child: Text(
                "hogehoge",
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}

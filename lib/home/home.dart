import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Home extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ListTile(
            title: Text("本日のイベント"),
          ),
          Card(
            child: Text("hogehoge"),
          ),
          Card(
            child: Text("hogehoge"),
          ),
        ],
      ),
    );
  }
}

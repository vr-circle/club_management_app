import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final darkModeProvider =
    StateNotifierProvider<DarkModeState, bool>((refs) => DarkModeState());

class DarkModeState extends StateNotifier<bool> {
  DarkModeState() : super(true);

  void changeSwitch(bool e) => this.state = e;
}

class Settings extends HookWidget {
  final bool isDarkMode = useProvider(darkModeProvider);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      ListTile(
        leading: Icon(Icons.dark_mode),
        title: Text("dark mode"),
        trailing: Switch(
          value: isDarkMode,
          onChanged: context.read(darkModeProvider.notifier).changeSwitch,
        ),
      ),
      ListTile(
        leading: Icon(Icons.people),
        title: Text("hogehoge"),
      ),
      ListTile(
        leading: Icon(Icons.people),
        title: Text("hogehoge"),
      ),
      ListTile(
        leading: Icon(Icons.people),
        title: Text("hogehoge"),
      ),
    ]));
  }
}

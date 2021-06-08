import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final darkModeProvider =
    StateNotifierProvider<DarkModeState, bool>((refs) => DarkModeState());

class DarkModeState extends StateNotifier<bool> {
  DarkModeState() : super(true);

  void changeSwitch(bool e) => this.state = e;
}

final expandedSettingNotifierProvider =
    StateNotifierProvider<ExpandedState, bool>((refs) => ExpandedState());

class ExpandedState extends StateNotifier<bool> {
  ExpandedState() : super(false);

  void toggleExpand(bool e) => this.state = e;
}

class SettingsPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = useProvider(darkModeProvider);
    return Scaffold(
      body: Column(children: [
        Consumer(builder: (context, watch, child) {
          return ListTile(
            leading: Icon(Icons.dark_mode),
            title: Text('ダークテーマ'),
            onTap: () {
              watch(darkModeProvider.notifier).changeSwitch(!isDarkMode);
            },
            trailing: Switch(
              value: isDarkMode,
              onChanged: (value) {
                watch(darkModeProvider.notifier).changeSwitch(value);
              },
            ),
          );
        }),
        ListTile(
            title: Text('通知'),
            leading: Icon(Icons.notifications),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return SettingNotification();
              }));
            }),
        ListTile(title: Text("hogehoge")),
        ListTile(title: Text("hogehoge")),
      ]),
    );
  }
}

class SettingNotification extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('通知設定'),
      ),
      body: Container(
          child: Column(
        children: [
          ListTile(
            title: Text('hogehoge'),
            trailing: Switch(
              value: true,
              onChanged: (value) {},
            ),
          ),
        ],
      )),
    );
  }
}

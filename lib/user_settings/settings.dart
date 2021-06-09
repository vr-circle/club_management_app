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
        body: SingleChildScrollView(
      child: Column(children: [
        const ListTile(
          title: Text("アカウント"),
        ),
        const ListTile(
          leading: Icon(Icons.account_box),
          title: Text("アカウントの管理"),
        ),
        const ListTile(
            leading: Icon(Icons.logout),
            title: Text(
              "サインアウト",
              style: TextStyle(color: Colors.red),
            )),
        Divider(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        const ListTile(
          title: Text("全般"),
        ),
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
        Divider(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        ListTile(
          title: Text('通知'),
        ),
        ListTile(
          leading: Icon(Icons.task),
          title: Text('タスクの通知'),
          trailing: Switch(
            value: false,
            onChanged: (value) {},
          ),
          subtitle: Text("未実装"),
        ),
        ListTile(
          leading: Icon(Icons.schedule),
          title: Text('スケジュールの通知'),
          trailing: Switch(
            value: false,
            onChanged: (value) {},
          ),
          subtitle: Text("未実装"),
        ),
        Divider(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        ListTile(title: Text("情報")),
        ListTile(
          leading: Icon(Icons.info),
          title: Text("バージョン"),
          subtitle: Text("1.0.0"),
        ),
      ]),
    ));
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

import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../auth/auth_service.dart';

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
  SettingsPage(this.appState);
  MyAppState appState;
  static const String route = '/settings';
  @override
  Widget build(BuildContext context) {
    final isDarkMode = useProvider(darkModeProvider);
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(children: [
        const ListTile(
          title: Text("アカウント"),
        ),
        ListTile(
          leading: Icon(Icons.account_box),
          title: Text("アカウントの管理"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return UserAccountView(appState: appState);
            }));
          },
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text(
            'ログアウト',
            style: TextStyle(color: Colors.red),
          ),
          onTap: () async {
            // logout
            appState.authService.signOut();
          },
        ),
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
        ListTile(title: Text("情報")),
        ListTile(
          leading: Icon(Icons.info),
          title: Text("バージョン"),
          subtitle: Text("0.0.1"),
        ),
      ]),
    ));
  }
}

class UserAccountView extends HookWidget {
  UserAccountView({this.appState});
  MyAppState appState;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('アカウント情報'),
      ),
      body: Center(
        child: Column(
          children: [
            ListTile(
              title: Text('名前'),
              trailing: Text(
                  appState.authService.getCurrentUser().displayName == null
                      ? '(表示名は設定されていません)'
                      : appState.authService.getCurrentUser().displayName),
            ),
            ListTile(
              title: Text('Email'),
              trailing: Text(appState.authService.getCurrentUser().email),
            ),
          ],
        ),
      ),
    );
  }
}

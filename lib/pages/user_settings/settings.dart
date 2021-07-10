import 'package:flutter/material.dart';
import 'package:flutter_application_1/store/store_service.dart';
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
  SettingsPage({this.signOut, this.handleOpenUserSettings});
  final Future<void> Function() signOut;
  final void Function() handleOpenUserSettings;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = useProvider(darkModeProvider);
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(children: [
        const ListTile(
          title: const Text('Account'),
        ),
        ListTile(
          leading: const Icon(Icons.account_box),
          title: const Text('Account management'),
          onTap: () {
            handleOpenUserSettings();
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text(
            'SignOut',
            style: const TextStyle(color: Colors.red),
          ),
          onTap: () async {
            await signOut();
          },
        ),
        Divider(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        const ListTile(
          title: Text('General'),
        ),
        Consumer(builder: (context, watch, child) {
          return ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Dark mode'),
            onTap: () async {
              watch(darkModeProvider.notifier).changeSwitch(!isDarkMode);
              await storeService.setUserTheme(!isDarkMode ? 'dark' : 'normal');
            },
            trailing: Switch(
              value: isDarkMode,
              onChanged: (value) async {
                watch(darkModeProvider.notifier).changeSwitch(value);
                await storeService
                    .setUserTheme(!isDarkMode ? 'dark' : 'normal');
              },
            ),
          );
        }),
        Divider(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        const ListTile(title: const Text('Information')),
        const ListTile(
          leading: const Icon(Icons.info),
          title: const Text('Version'),
          subtitle: const Text('beta'),
        ),
      ]),
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'home/home.dart';
import 'circle/circle.dart';
import 'todo/todo.dart';
import 'schedule/schedule.dart';
import 'user_settings/settings.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends HookWidget {
  static const String _title = 'Circle Management App';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: _title,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        home: MyPages(),
        debugShowCheckedModeBanner: false);
  }
}

final pageIndexProvider =
    StateNotifierProvider<PageIndex, int>((refs) => PageIndex());

class PageIndex extends StateNotifier<int> {
  PageIndex() : super(0);

  void updateIndex(int index) {
    this.state = index;
  }
}

class MyPages extends HookWidget {
  static List<Widget> _pageList = [
    Home(),
    Circle(),
    Schedule(),
    Todo(),
    Settings()
  ];

  @override
  Widget build(BuildContext context) {
    final int _selectedIndex = useProvider(pageIndexProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text('circle management app'),
          actions: <Widget>[Icon(Icons.person)],
        ),
        body: _pageList[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.circle), label: 'Circle'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.schedule), label: 'Schedule'),
              BottomNavigationBarItem(icon: Icon(Icons.task), label: 'ToDo'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.library_add_check), label: 'Settings'),
            ],
            currentIndex: _selectedIndex,
            onTap: context.read(pageIndexProvider.notifier).updateIndex));
  }
}

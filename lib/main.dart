import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'auth/auth_service.dart';
import 'auth/sign_up_page.dart';
import 'auth/verification_page.dart';
import 'auth/login_page.dart';
import 'home/home.dart';
import 'search/search.dart';
import 'todo/todo.dart';
import 'schedule/schedule.dart';
import 'user_settings/settings.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(ProviderScope(child: MyApp())));
}

class UserStatus {
  String username;
  AuthFlowStatus authStatus;
}

final homeGlobalKeyProvider = StateNotifierProvider((_) => GlobalKeyState());
final scheduleGlobalKeyProvider =
    StateNotifierProvider((_) => GlobalKeyState());
final todoGlobalKeyProvider = StateNotifierProvider((_) => GlobalKeyState());
final settingsGlobalKeyProvider =
    StateNotifierProvider((_) => GlobalKeyState());

class GlobalKeyState extends StateNotifier {
  GlobalKeyState() : super(GlobalKey<NavigatorState>());
}

final pageIndexProvider =
    StateNotifierProvider<PageIndex, int>((refs) => PageIndex());

class PageIndex extends StateNotifier<int> {
  PageIndex() : super(0);

  void updateIndex(int index) {
    this.state = index;
  }
}

class MyApp extends HookWidget {
  static const String _appTitle = "Club Management App";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _appTitle,
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (context) => MyTopPage(),
        PagesController.route: (context) => PagesController(),
        HomePage.route: (context) => HomePage(),
        SchedulePage.route: (context) => SchedulePage(),
        TodoPage.route: (context) => TodoPage(),
        SettingsPage.route: (context) => SettingsPage(),
      },
    );
  }
}

class MyTopPage extends HookWidget {
  static const String route = '/';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('hogehoge'),
      ),
      body: Center(
        child: TextButton(
            onPressed: () {
              Navigator.pushNamed(context, HomePage.route);
            },
            child: Text('aaaaaaaaaaaa')),
      ),
    );
  }
}

class PagesController extends HookWidget {
  static const String route = 'lead';
  static const String _title = 'Club Management App';
  static List<Widget> _pageList = [
    HomePage(),
    SchedulePage(),
    TodoPage(),
    // SearchPage(),
    SettingsPage()
  ];

  @override
  Widget build(BuildContext context) {
    final int _selectedIndex = useProvider(pageIndexProvider);
    final _homeScreen = useProvider(homeGlobalKeyProvider);
    final _scheduleScreen = useProvider(scheduleGlobalKeyProvider);
    final _todoScreen = useProvider(todoGlobalKeyProvider);
    final _settingsScreen = useProvider(settingsGlobalKeyProvider);
    var url = window.location.href;
    return Consumer(builder: (context, watch, _) {
      return MaterialApp(
          title: _title,
          theme: watch(darkModeProvider) ? ThemeData.dark() : ThemeData.light(),
          initialRoute: '/lead/',
          routes: <String, WidgetBuilder>{
            HomePage.route: (context) => HomePage(),
            SchedulePage.route: (context) => SchedulePage(),
            TodoPage.route: (context) => TodoPage(),
            SettingsPage.route: (context) => SettingsPage(),
          },
          home: Scaffold(
            appBar: AppBar(
              title: Text(url.toString()),
              actions: <Widget>[Icon(Icons.person)],
            ),
            body: Center(child: Text("hogehoge")
                //     child: [
                //   Navigator(
                //     key: _homeScreen,
                //     onGenerateRoute: (route) => MaterialPageRoute(
                //         settings: route, builder: (context) => HomePage()),
                //   ),
                //   Navigator(
                //     key: _scheduleScreen,
                //     onGenerateRoute: (route) => MaterialPageRoute(
                //         settings: route, builder: (context) => SchedulePage()),
                //   ),
                //   Navigator(
                //     key: _todoScreen,
                //     onGenerateRoute: (route) => MaterialPageRoute(
                //         settings: route, builder: (context) => TodoPage()),
                //   ),
                //   Navigator(
                //     key: _settingsScreen,
                //     onGenerateRoute: (route) => MaterialPageRoute(
                //         settings: route, builder: (context) => SettingsPage()),
                //   ),
                // ][_selectedIndex]
                ),
            bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home), label: 'Home'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.calendar_today), label: 'Calendar'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.task), label: 'ToDo'),
                  // BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Club'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.settings), label: 'Settings'),
                ],
                currentIndex: _selectedIndex,
                onTap: (index) {
                  print(index == 0);
                  context.read(pageIndexProvider.notifier).updateIndex(index);
                  switch (index) {
                    case 0:
                      print('hogepage');
                      Navigator.pushNamed(context, HomePage.route);
                      break;
                    case 1:
                      Navigator.of(context).pushNamed(SchedulePage.route);
                      break;
                    case 2:
                      Navigator.of(context).pushNamed(TodoPage.route);
                      break;
                    case 3:
                      Navigator.of(context).pushNamed(SettingsPage.route);
                      break;
                  }
                }),
          ));
    });
  }
}

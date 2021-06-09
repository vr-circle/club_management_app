import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth_service.dart';
import 'package:flutter_application_1/sign_up_page.dart';
import 'package:flutter_application_1/verification_page.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'login_page.dart';
import 'home/home.dart';
import 'search/search.dart';
import 'todo/todo.dart';
import 'schedule/schedule.dart';
import 'user_settings/settings.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(ProviderScope(child: MyApp())));
}

class ClubManagementApp extends HookWidget {
  static const String _title = 'Circle Management App';
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        return MaterialApp(
            title: _title,
            theme:
                watch(darkModeProvider) ? ThemeData.dark() : ThemeData.light(),
            home: MyPages(),
            debugShowCheckedModeBanner: false);
      },
    );
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
    // HomePage(),
    SchedulePage(),
    TodoPage(),
    // SearchPage(),
    SettingsPage()
  ];

  @override
  Widget build(BuildContext context) {
    final int _selectedIndex = useProvider(pageIndexProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Club management app'),
          actions: <Widget>[Icon(Icons.person)],
        ),
        body: _pageList[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              // BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today), label: 'Calendar'),
              BottomNavigationBarItem(icon: Icon(Icons.task), label: 'ToDo'),
              // BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Club'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: 'Settings'),
            ],
            currentIndex: _selectedIndex,
            onTap: context.read(pageIndexProvider.notifier).updateIndex));
  }
}

// 1
class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _authService = AuthService();
  @override
  void initState() {
    super.initState();
    _authService.showLogin();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Gallery App',
      theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity),
      // 2
      home: StreamBuilder<AuthState>(
          // 2
          stream: _authService.authStateController.stream,
          builder: (context, snapshot) {
            // 3
            if (snapshot.hasData) {
              return Navigator(
                pages: [
                  // 4
                  // Show Login Page
                  if (snapshot.data.authFlowStatus == AuthFlowStatus.login)
                    MaterialPage(
                      child: LoginPage(
                        shouldShowSignPage: _authService.showSignUp,
                        didProvideCredentials:
                            _authService.loginWithCredentials,
                      ),
                    ),

                  // 5
                  // Show Sign Up Page
                  if (snapshot.data.authFlowStatus == AuthFlowStatus.signUp)
                    MaterialPage(
                        child: SignUpPage(
                      shouldShowLogin: _authService.showLogin,
                      didProvideCredentials: _authService.signUpWithCredentials,
                    )),
                  if (snapshot.data.authFlowStatus ==
                      AuthFlowStatus.verification)
                    MaterialPage(
                        child: VerificationPage(
                      didProvideVerificationCode: _authService.verifyCode,
                    )),

                  if (snapshot.data.authFlowStatus == AuthFlowStatus.session)
                    MaterialPage(child: ClubManagementApp())
                ],
                onPopPage: (route, result) => route.didPop(result),
              );
            } else {
              // 6
              return Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

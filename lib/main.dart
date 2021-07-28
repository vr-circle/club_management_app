import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_application_1/app_state.dart';
import 'package:flutter_application_1/my_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  setPathUrlStrategy();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppState _appState;
  MyRouteInformationParser _routeInformationParser;
  MyRouterDelegate _routerDelegate;

  @override
  void initState() {
    _appState = AppState();
    _routeInformationParser = MyRouteInformationParser(_appState);
    _routerDelegate = MyRouterDelegate(_appState);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _appState.authStateChange()(),
      builder: (context, AsyncSnapshot<User> snapshot) {
        if (snapshot.connectionState != ConnectionState.active) {
          return const Center(
              child: const FlutterLogo(
            size: 32,
          ));
        } else if (snapshot.hasError) {
          return const Center(child: const Text('Error'));
        }
        _appState.user = snapshot.data;
        return MaterialApp.router(
          title: 'OMA',
          debugShowCheckedModeBanner: false,
          theme: _appState.generalTheme ??
                  SchedulerBinding.instance.window.platformBrightness ==
                      Brightness.dark
              ? ThemeData.dark()
              : ThemeData.light(),
          routeInformationParser: _routeInformationParser,
          routerDelegate: _routerDelegate,
        );
      },
    );
  }
}

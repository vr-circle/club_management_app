import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_state.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, @required this.appState}) : super(key: key);
  final AppState appState;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const FlutterLogo(),
              const Text('CMA'),
            ],
          ),
        ),
        body: const Center(
          child: const Text('Dummy'),
        ));
  }
}

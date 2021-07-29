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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Dummy'),
      ),
    );
  }
}

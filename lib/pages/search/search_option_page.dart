import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_state.dart';
import 'package:flutter_application_1/route_path.dart';

class SearchOptionPage extends StatefulWidget {
  SearchOptionPage({Key key, @required this.appState}) : super(key: key);
  final MyAppState appState;
  @override
  SearchOptionPageState createState() => SearchOptionPageState();
}

class SearchOptionPageState extends State<SearchOptionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextField(
          decoration: const InputDecoration(labelText: 'Search by name'),
        ),
      ),
      body: const Center(
          child: const Text('This is place to set option pannels.')),
      bottomNavigationBar: BottomAppBar(
        child: TextButton(
          child: Text('search'),
          onPressed: () {
            widget.appState.selectedIndex = GroupViewPath.index;
            widget.appState.searchingParams = 'sample';
          },
        ),
      ),
    );
  }
}

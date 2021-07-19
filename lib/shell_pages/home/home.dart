import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_state.dart';
import 'package:flutter_application_1/route_path.dart';
import 'package:flutter_application_1/store/store_service.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, @required this.appState}) : super(key: key);
  final AppState appState;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> participatingOrganizationIdList;
  Future<List<String>> _getOrganizationIdList() async {
    await Future.delayed(Duration(seconds: 1));
    return await dbService.getParticipatingOrganizationIdList();
  }

  @override
  void initState() {
    super.initState();
  }

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
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.search)),
            // IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),
            IconButton(onPressed: () {}, icon: Icon(Icons.person)),
          ],
        ),
        body: FutureBuilder(
          future: _getOrganizationIdList(),
          builder:
              (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: const CircularProgressIndicator(),
              );
            }
            if (snapshot.data.isEmpty) {
              return Center(
                child: TextButton(
                  child: const Text('Join organizations'),
                  onPressed: () {
                    widget.appState.bottomNavigationIndex = SearchPath.index;
                  },
                ),
              );
            }
            return const Center(
              child: const Text('Dummy'),
            );
          },
        ));
  }
}

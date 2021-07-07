import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_state.dart';
import 'package:flutter_application_1/route_path.dart';

// class HomePage extends StatefulWidget

class HomePage extends StatelessWidget {
  HomePage({Key key, @required this.appState}) : super(key: key);
  final MyAppState appState;
  static const String route = '/homepage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
      // schedule list
      ListTile(
        title: Text('Schedule in today'),
      ),
      ListView.builder(
          shrinkWrap: true,
          itemCount: 3,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(title: Text('title'), trailing: Text('details'));
          }),
      TextButton(
          onPressed: () {
            appState.selectedIndex = SchedulePath.index;
          },
          child: Text('more')),
      SizedBox(
        height: 20,
      ),
      // todo list
      ListTile(
        title: Text('Todo List'),
      ),
      ListView.builder(
          shrinkWrap: true,
          itemCount: 3,
          itemBuilder: (BuildContext context, int index) {
            return Card(
                child:
                    ListTile(title: Text('title'), trailing: Text('details')));
          }),
      TextButton(
          onPressed: () {
            appState.selectedIndex = TodoPath.index;
          },
          child: Text('more')),
      // // Club List
      // Container(
      //     child: Padding(
      //   padding: EdgeInsets.all(8),
      //   child:
      //       Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      //     Expanded(
      //       child: SizedBox(
      //         height: 200,
      //         child: ListView.builder(
      //             scrollDirection: Axis.horizontal,
      //             itemCount: 5,
      //             itemBuilder: (BuildContext context, int index) {
      //               return SizedBox(
      //                 width: 200,
      //                 child: GestureDetector(
      //                     onTap: () {
      //                       appState.selectedIndex = GroupViewPath.index;
      //                       appState.selectedSearchingClubId = '';
      //                     },
      //                     child: Card(
      //                       child: Text('hogehoge'),
      //                     )),
      //               );
      //             }),
      //       ),
      //     )
      //   ]),
      // )),
    ])));
  }
}

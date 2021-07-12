import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_state.dart';
import 'package:flutter_application_1/pages/home/schedule_parts.dart';
import 'package:flutter_application_1/pages/home/todo_home.dart';
import 'package:flutter_application_1/pages/search/organization_info.dart';
import 'package:flutter_application_1/route_path.dart';

class HomePage extends StatelessWidget {
  HomePage({Key key, @required this.handleChangeSelectedIndex})
      : super(key: key);
  final void Function(int index) handleChangeSelectedIndex;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        TodoHomeView(
          handleChangeSelectedIndex: handleChangeSelectedIndex,
        ),
        const SizedBox(
          height: 12,
        ),
        SchedulePartsListView(
          handleChangeSelectedIndex: handleChangeSelectedIndex,
        ),
        // Divider(
        //   color: Colors.white,
        // ),
        // OrganizationPartsListView(
        //   appState: appState,
        // ),
      ],
    ));
  }
}

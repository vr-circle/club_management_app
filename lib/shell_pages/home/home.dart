import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({Key key, @required this.handleChangeSelectedIndex})
      : super(key: key);
  final void Function(int index) handleChangeSelectedIndex;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Text('dummy'),
      // children: [
      //   TodoHomeView(
      //     handleChangeSelectedIndex: handleChangeSelectedIndex,
      //   ),
      //   const SizedBox(
      //     height: 12,
      //   ),
      //   ScheduleHomeView(
      //     handleChangeSelectedIndex: handleChangeSelectedIndex,
      //   ),
      // ],
    ));
  }
}

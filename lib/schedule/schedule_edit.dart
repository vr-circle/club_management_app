import 'package:flutter/material.dart';

import 'schedule.dart';

class ScheduleEditPage extends StatelessWidget {
  ScheduleEditPage(this._targetSchedule);
  final Schedule _targetSchedule;
  TextEditingController _endTimeTextEditingController;
  TextEditingController _startTimeTextEditingController;
  String newTitle = '';
  String newPlace = '';
  String newDetails = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_targetSchedule.title),
        ),
        body: Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  decoration: InputDecoration(
                      icon: Icon(Icons.title), labelText: 'タイトル'),
                  onChanged: (value) {
                    newTitle = value;
                  },
                ),
                TextField(
                  decoration:
                      InputDecoration(icon: Icon(Icons.place), labelText: '場所'),
                  onChanged: (value) {
                    newPlace = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(
                      icon: Icon(Icons.timer), labelText: '開始時刻'),
                  onTap: () async {
                    // var newDate = await _selectTime(context);
                    // endTextFiledController.text =
                    //     DateFormat('yyyy/MM/dd HH:mm').format(newDate);
                    // this.newSchedule.end = newDate;
                  },
                  controller: this._startTimeTextEditingController,
                  enableInteractiveSelection: false,
                  focusNode: FocusNode(),
                  readOnly: true,
                ),
                TextField(
                  decoration: InputDecoration(
                      icon: Icon(Icons.timer), labelText: '終了時刻'),
                  onTap: () async {
                    // var newDate = await _selectTime(context);
                    // endTextFiledController.text =
                    //     DateFormat('yyyy/MM/dd HH:mm').format(newDate);
                    // this.newSchedule.end = newDate;
                  },
                  controller: this._endTimeTextEditingController,
                  enableInteractiveSelection: false,
                  focusNode: FocusNode(),
                  readOnly: true,
                ),
                TextField(
                  decoration: InputDecoration(
                      icon: Icon(Icons.content_copy), labelText: '内容'),
                  onChanged: (value) {
                    newDetails = value;
                  },
                ),
              ],
            )));
  }
}

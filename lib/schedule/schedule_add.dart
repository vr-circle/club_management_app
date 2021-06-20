import 'package:flutter/material.dart';
import 'schedule.dart';
import 'package:flutter_application_1/store/store_service.dart';
import 'package:intl/intl.dart';

class ScheduleAddPage extends StatefulWidget {
  ScheduleAddPage(
      {Key key, this.addSchedule, this.targetDate, DateTime initSchedule})
      : super(key: key);
  final Future<void> Function(Schedule schedule, String target) addSchedule;
  final DateTime targetDate;
  @override
  _ScheduleAddPageState createState() => _ScheduleAddPageState();
}

class _ScheduleAddPageState extends State<ScheduleAddPage> {
  final _format = new DateFormat('yyyy/MM/dd(E)', 'ja_JP');

  TextEditingController startTextFiledController;
  TextEditingController endTextFiledController;
  List<String> targetUsers;
  String _selectedTargetUsers;

  @override
  void initState() {
    super.initState();
    this.startTextFiledController = new TextEditingController(
        text: DateFormat('yyyy/MM/dd HH:mm').format(widget.targetDate));
    this.endTextFiledController = new TextEditingController(
        text: DateFormat('yyyy/MM/dd HH:mm')
            .format(widget.targetDate.add(Duration(days: 1))));
    this.targetUsers = [
      'private',
      'circle'
    ]; // todo: generate list from user setting
    this._selectedTargetUsers = 'private';
  }

  Schedule newSchedule = new Schedule(
    title: '',
    place: '',
    start: DateTime.now(),
    end: DateTime.now(),
    details: '',
  );

  Future<DateTime> _selectTime(BuildContext context) async {
    TimeOfDay newSelectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (newSelectedTime != null) {
      DateTime newDate = DateTime(
        widget.targetDate.year,
        widget.targetDate.month,
        widget.targetDate.day,
        newSelectedTime.hour,
        newSelectedTime.minute,
      );
      return newDate;
    } else {
      return widget.targetDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_format.format(widget.targetDate)),
      ),
      body: Padding(
          padding: EdgeInsets.all(32),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('対象'),
                    DropdownButton(
                      value: _selectedTargetUsers,
                      items: this
                          .targetUsers
                          .map((e) => DropdownMenuItem(
                                child: Text(e),
                                value: e,
                              ))
                          .toList(),
                      onChanged: (newValue) {
                        setState(() {
                          this._selectedTargetUsers = newValue;
                        });
                      },
                    ),
                  ],
                ),
                TextField(
                  decoration: InputDecoration(
                      icon: Icon(Icons.title), labelText: 'タイトル'),
                  onChanged: (value) {
                    this.newSchedule.title = value;
                  },
                ),
                TextField(
                  decoration:
                      InputDecoration(icon: Icon(Icons.place), labelText: '場所'),
                  onChanged: (value) {
                    this.newSchedule.place = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(
                      icon: Icon(Icons.timer), labelText: '開始時刻'),
                  onTap: () async {
                    var newDate = await _selectTime(context);
                    startTextFiledController.text =
                        DateFormat('yyyy/MM/dd HH:mm').format(newDate);
                    this.newSchedule.start = newDate;
                  },
                  controller: this.startTextFiledController,
                  enableInteractiveSelection: false,
                  focusNode: FocusNode(),
                  readOnly: true,
                ),
                TextField(
                  decoration: InputDecoration(
                      icon: Icon(Icons.timer), labelText: '終了時刻'),
                  onTap: () async {
                    var newDate = await _selectTime(context);
                    endTextFiledController.text =
                        DateFormat('yyyy/MM/dd HH:mm').format(newDate);
                    this.newSchedule.end = newDate;
                  },
                  controller: this.endTextFiledController,
                  enableInteractiveSelection: false,
                  focusNode: FocusNode(),
                  readOnly: true,
                ),
                TextField(
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    icon: Icon(Icons.content_copy),
                    labelText: '内容',
                  ),
                  onChanged: (value) {
                    this.newSchedule.details = value;
                  },
                ),
              ],
            ),
          )),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 50,
                child: Center(
                  child: TextButton(
                      onPressed: () async {
                        final format = DateFormat('yyyy/MM/dd HH:mm');
                        newSchedule.start =
                            format.parseStrict(startTextFiledController.text);
                        newSchedule.end =
                            format.parseStrict(endTextFiledController.text);
                        widget.addSchedule(
                            this.newSchedule, this._selectedTargetUsers);
                        Navigator.of(context).pop();
                      },
                      child: const Text("追加")),
                )),
            SizedBox(
                height: 50,
                child: Center(
                  child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("キャンセル")),
                )),
          ],
        ),
      ),
    );
  }
}

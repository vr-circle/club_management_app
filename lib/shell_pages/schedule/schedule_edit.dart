import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'schedule.dart';

class ScheduleEditPage extends StatefulWidget {
  ScheduleEditPage({@required this.targetSchedule});
  final Schedule targetSchedule;

  @override
  _ScheduleEditPageState createState() => _ScheduleEditPageState();
}

class _ScheduleEditPageState extends State<ScheduleEditPage> {
  TextEditingController _titleTextEditingController;
  TextEditingController _placeTextEditingController;
  TextEditingController _detailsTextEditingController;
  TextEditingController _endTimeTextEditingController;
  TextEditingController _startTimeTextEditingController;
  Schedule _newSchedule;
  String _selectedTargetUser;

  @override
  void initState() {
    this._newSchedule = new Schedule(
      title: widget.targetSchedule.title,
      place: widget.targetSchedule.place,
      start: widget.targetSchedule.start,
      end: widget.targetSchedule.end,
      details: widget.targetSchedule.details,
    );
    this._titleTextEditingController =
        new TextEditingController(text: this._newSchedule.title);
    this._placeTextEditingController =
        new TextEditingController(text: this._newSchedule.place);
    this._detailsTextEditingController =
        new TextEditingController(text: this._newSchedule.details);
    this._endTimeTextEditingController = new TextEditingController(
        text: DateFormat('yyyy/MM/dd HH:mm').format(this._newSchedule.end));
    this._startTimeTextEditingController = new TextEditingController(
        text: DateFormat('yyyy/MM/dd HH:mm').format(this._newSchedule.start));
    this._selectedTargetUser = 'private';
    super.initState();
  }

  Future<DateTime> _selectTime(BuildContext context) async {
    TimeOfDay newSelectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (newSelectedTime != null) {
      DateTime newDate = DateTime(
        widget.targetSchedule.start.year,
        widget.targetSchedule.start.month,
        widget.targetSchedule.start.day,
        newSelectedTime.hour,
        newSelectedTime.minute,
      );
      return newDate;
    } else {
      return widget.targetSchedule.start;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            DateFormat('yyyy/MM/dd(E)').format(widget.targetSchedule.start)),
        actions: [
          TextButton(
            onPressed: () {
              final format = DateFormat('yyyy/MM/dd HH:mm');
              _newSchedule.start =
                  format.parseStrict(this._startTimeTextEditingController.text);
              _newSchedule.end =
                  format.parseStrict(this._endTimeTextEditingController.text);
              if (_newSchedule.title.isEmpty) {
                print('this is mandatory');
                Navigator.of(context).pop();
                return;
              }
              if (_newSchedule.place.isEmpty) {
                _newSchedule.place = '(Empty)';
              }
              if (_newSchedule.details.isEmpty) {
                _newSchedule.details = '(Empty)';
              }
              // widget.addSchedule(this.newSchedule, this._selectedTargetUsers);
              Navigator.of(context).pop();
            },
            child: const Text('Edit'),
          ),
        ],
      ),
      body: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('target'),
                  DropdownButton(
                    value: this._selectedTargetUser,
                    items: ['private', 'circle']
                        .map((e) => DropdownMenuItem(
                              child: Text(e),
                              value: e,
                            ))
                        .toList(),
                    onChanged: (newValue) {
                      setState(() {
                        this._selectedTargetUser = newValue;
                      });
                    },
                  ),
                ],
              ),
              TextField(
                controller: this._titleTextEditingController,
                decoration: const InputDecoration(
                    icon: const Icon(Icons.title), labelText: 'Title'),
              ),
              TextField(
                controller: this._placeTextEditingController,
                decoration: const InputDecoration(
                    icon: const Icon(Icons.place), labelText: 'Place'),
              ),
              TextField(
                decoration: const InputDecoration(
                    icon: const Icon(Icons.timer), labelText: 'Start time'),
                onTap: () async {
                  var newDate = await _selectTime(context);
                  this._startTimeTextEditingController.text =
                      DateFormat('yyyy/MM/dd HH:mm').format(newDate);
                  this._newSchedule.end = newDate;
                },
                controller: this._startTimeTextEditingController,
                enableInteractiveSelection: false,
                focusNode: FocusNode(),
                readOnly: true,
              ),
              TextField(
                decoration: const InputDecoration(
                    icon: const Icon(Icons.timer), labelText: 'End time'),
                onTap: () async {
                  var newDate = await _selectTime(context);
                  this._endTimeTextEditingController.text =
                      DateFormat('yyyy/MM/dd HH:mm').format(newDate);
                  this._newSchedule.end = newDate;
                },
                controller: this._endTimeTextEditingController,
                enableInteractiveSelection: false,
                focusNode: FocusNode(),
                readOnly: true,
              ),
              TextField(
                controller: this._detailsTextEditingController,
                decoration: const InputDecoration(
                    icon: const Icon(Icons.content_copy), labelText: 'Details'),
              ),
            ],
          )),
    );
  }
}

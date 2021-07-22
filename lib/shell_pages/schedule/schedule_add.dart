import 'package:flutter/material.dart';
import 'package:flutter_application_1/store/store_service.dart';
import 'package:tuple/tuple.dart';
import 'schedule.dart';
import 'package:intl/intl.dart';

class AddSchedulePage extends StatefulWidget {
  AddSchedulePage(
      {Key key, @required this.addSchedule, @required this.targetDate})
      : super(key: key);
  final Future<void> Function(Schedule schedule, bool isPersonal) addSchedule;
  final DateTime targetDate;
  @override
  _AddSchedulePageState createState() => _AddSchedulePageState();
}

class _AddSchedulePageState extends State<AddSchedulePage> {
  Future<List<Tuple2<String, String>>>
      _getParticipatingOrganizationIdAndNameList() async {
    List<Tuple2<String, String>> targetIdAndNameList = [];
    final _ids = await dbService.getParticipatingOrganizationIdList();
    targetIdAndNameList.add(Tuple2('private', 'private'));
    await Future.forEach(_ids, (id) async {
      final _name = (await dbService.getOrganizationInfo(id)).name;
      targetIdAndNameList.add(Tuple2(id, _name));
    });
    return targetIdAndNameList;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: _getParticipatingOrganizationIdAndNameList(),
      builder: (BuildContext context,
          AsyncSnapshot<List<Tuple2<String, String>>> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: const CircularProgressIndicator(),
          );
        }
        return AddScheduleField(
          targetIdAndName: snapshot.data,
          targetDate: widget.targetDate,
          addSchedule: widget.addSchedule,
        );
      },
    ));
  }
}

class AddScheduleField extends StatefulWidget {
  AddScheduleField(
      {Key key,
      @required this.targetIdAndName,
      @required this.targetDate,
      @required this.addSchedule})
      : super(key: key);
  final DateTime targetDate;
  final List<Tuple2<String, String>> targetIdAndName;
  final Future<void> Function(Schedule schedule, bool isPersonal) addSchedule;
  @override
  _AddScheduleFieldState createState() => _AddScheduleFieldState();
}

class _AddScheduleFieldState extends State<AddScheduleField> {
  final _format = new DateFormat('yyyy/MM/dd(E)');

  TextEditingController startTextFiledController;
  TextEditingController endTextFiledController;
  String _selectedTarget;
  bool _selectedIsPublic;

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

  Schedule newSchedule = new Schedule(
      title: '',
      place: '',
      start: DateTime.now(),
      end: DateTime.now(),
      details: '',
      createdBy: '',
      isPublic: false);

  @override
  void initState() {
    this.startTextFiledController = new TextEditingController(
        text: DateFormat('yyyy/MM/dd HH:mm').format(widget.targetDate));
    this.endTextFiledController = new TextEditingController(
        text: DateFormat('yyyy/MM/dd HH:mm')
            .format(widget.targetDate.add(Duration(days: 1))));
    this._selectedTarget = widget.targetIdAndName.first.item2;
    this._selectedIsPublic = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
                onPressed: () {
                  final format = DateFormat('yyyy/MM/dd HH:mm');
                  newSchedule.start =
                      format.parseStrict(startTextFiledController.text);
                  newSchedule.end =
                      format.parseStrict(endTextFiledController.text);
                  if (newSchedule.title.isEmpty) {
                    print('This is mandatory');
                    return;
                  }
                  if (newSchedule.place.isEmpty) {
                    newSchedule.place = '(Empty)';
                  }
                  if (newSchedule.details.isEmpty) {
                    newSchedule.details = '(Empty)';
                  }
                  newSchedule.isPublic = this._selectedIsPublic;
                  newSchedule.createdBy =
                      _selectedTarget == 'private' ? null : _selectedTarget;
                  widget.addSchedule(
                      this.newSchedule, _selectedTarget == 'private');
                  setState(() {});
                },
                child: const Text('Add'))
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(32),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _format.format(widget.targetDate),
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Target'),
                      const SizedBox(
                        height: 16,
                      ),
                      FormField(builder: (FormFieldState<String> state) {
                        return InputDecorator(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              hint: const Text('Select target'),
                              value: _selectedTarget,
                              isDense: true,
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedTarget = newValue;
                                });
                              },
                              items: widget.targetIdAndName
                                  .map((e) => DropdownMenuItem(
                                        child: Text(e.item2),
                                        value: e.item1,
                                      ))
                                  .toList(),
                            ),
                          ),
                        );
                      }),
                      Visibility(
                          visible: _selectedTarget != 'private',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 24,
                              ),
                              const Text('Publish setting'),
                              const SizedBox(
                                height: 16,
                              ),
                              FormField(builder: (FormFieldState<bool> state) {
                                return InputDecorator(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0))),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<bool>(
                                        hint: const Text(
                                            'Select publish setting'),
                                        value: _selectedIsPublic,
                                        isDense: true,
                                        onChanged: (newValue) {
                                          setState(() {
                                            _selectedIsPublic = newValue;
                                          });
                                        },
                                        items: [
                                          DropdownMenuItem(
                                              child: Text('private'),
                                              value: false),
                                          DropdownMenuItem(
                                            child: Text('public'),
                                            value: true,
                                          ),
                                        ]),
                                  ),
                                );
                              }),
                            ],
                          ))
                    ],
                  ),
                  TextField(
                    decoration: InputDecoration(
                        icon: const Icon(Icons.title), labelText: 'Title'),
                    onChanged: (value) {
                      this.newSchedule.title = value;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        icon: const Icon(Icons.place), labelText: 'Place'),
                    onChanged: (value) {
                      this.newSchedule.place = value;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        icon: const Icon(Icons.timer), labelText: 'Start time'),
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
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        icon: const Icon(Icons.timer), labelText: 'End time'),
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
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.content_copy),
                      labelText: 'Details',
                    ),
                    onChanged: (value) {
                      this.newSchedule.details = value;
                    },
                  ),
                ],
              ),
            )));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

final focusDayProvider =
    StateNotifierProvider<FocusDay, DateTime>((refs) => FocusDay());

class FocusDay extends StateNotifier<DateTime> {
  FocusDay() : super(DateTime.now());
  void updateFocusDay(day) {
    this.state = day;
  }
}

final selectedDayProvider = StateNotifierProvider((refs) => SelectedDay());

class SelectedDay extends StateNotifier<DateTime> {
  SelectedDay() : super(DateTime.now());
  void updateSelectedDay(day) {
    this.state = day;
  }
}

class SchedulePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _focusDay = useProvider(focusDayProvider);
    final _selectedDay = useProvider(selectedDayProvider);
    const CalendarFormat _calendarFormat = CalendarFormat.month;
    return Container(
        child: TableCalendar(
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
      ),
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2040, 12, 31),
      focusedDay: _focusDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDay, selectedDay)) {
          context
              .read(selectedDayProvider.notifier)
              .updateSelectedDay(selectedDay);
          context.read(focusDayProvider.notifier).updateFocusDay(focusedDay);
        }
        if (isSameDay(_focusDay, selectedDay)) {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return ScheduleListOnDay(targetDate: selectedDay);
          }));
        }
      },
    ));
  }
}

class ScheduleListOnDay extends HookWidget {
  ScheduleListOnDay({Key key, @required this.targetDate}) : super(key: key);
  final DateTime targetDate;
  var _format = new DateFormat('yyyy/MM/dd(E)', 'ja_JP');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_format.format(DateTime.now())),
        ),
        body: ListView(
          children: [
            Card(
              child: ListTile(
                title: Text("hoge"),
                onTap: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return ScheduleDetails();
                })),
              ),
            ),
            Card(
              child: ListTile(
                title: Text("hoge"),
                onTap: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return ScheduleDetails();
                })),
              ),
            ),
            Card(
              child: ListTile(
                title: Text("hoge"),
                onTap: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return ScheduleDetails();
                })),
              ),
            ),
            Card(
              child: ListTile(
                title: Text("hoge"),
                onTap: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return ScheduleDetails();
                })),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return ScheduleAddPage(
                        targetDate: targetDate,
                      );
                    }));
                  },
                  child:
                      SizedBox(height: 50, child: Center(child: Text("Add")))),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: SizedBox(
                      height: 50, child: Center(child: Text("Close")))),
            ],
          ),
        ));
  }
}

class ScheduleDetails extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("XXXX年OO月TT日"),
        ),
        body: Column(children: [
          // show details
          Expanded(child: Container(child: Text("hogehoge"))),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () {},
                    child: Text(
                      "削除",
                      style: TextStyle(color: Colors.red),
                    )),
                TextButton(onPressed: () {}, child: Text("編集")),
                TextButton(onPressed: () {}, child: Text("キャンセル")),
              ],
            ),
          )
        ]));
  }
}

class ScheduleAddPage extends HookWidget {
  final DateTime targetDate;
  final _format = new DateFormat('yyyy/MM/dd(E)', 'ja_JP');
  ScheduleAddPage({Key key, @required this.targetDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_format.format(targetDate)),
      ),
      body: Container(
        child: Column(
          children: [
            Column(
              children: [
                TextField(),
                TextField(),
                TextField(),
                TextField(),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("追加")),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("キャンセル")),
          ],
        ),
      ),
    );
  }
}

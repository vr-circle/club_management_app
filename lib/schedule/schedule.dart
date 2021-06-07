import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

final selectedDayProvider =
    StateNotifierProvider<SelectedDay, DateTime>((refs) => SelectedDay());

class SelectedDay extends StateNotifier<DateTime> {
  SelectedDay() : super(DateTime.now());
  void updateDay(selectedDay) {
    this.state = selectedDay;
  }
}

class Schedule extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final selectedDay = useProvider(selectedDayProvider);
    return Container(
        child: TableCalendar(
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: DateTime.now(),
      calendarBuilders: CalendarBuilders(dowBuilder: (context, day) {
        if (day.weekday == DateTime.sunday) {
          final text = DateFormat.E().format(day);
          return Center(
            child: Text(
              text,
              style: TextStyle(color: Colors.red),
            ),
          );
        } else if (day.weekday == DateTime.saturday) {
          final text = DateFormat.E().format(day);
          return Center(
            child: Text(
              text,
              style: TextStyle(color: Colors.blue),
            ),
          );
        } else {
          final text = DateFormat.E().format(day);
          return Center(
            child: Text(
              text,
            ),
          );
        }
      }),
    ));
  }
}

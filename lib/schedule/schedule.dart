import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
      locale: 'ja_JP',
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
          print("Show dialog");
        }
      },
    ));
  }
}

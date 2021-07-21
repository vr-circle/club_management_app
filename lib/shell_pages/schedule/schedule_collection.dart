import 'dart:collection';

import 'package:flutter_application_1/shell_pages/schedule/schedule.dart';
import 'package:flutter_application_1/store/store_service.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleCollection {
  ScheduleCollection() {
    this._schedules = LinkedHashMap(equals: isSameDay, hashCode: _getHashCode);
  }
  LinkedHashMap<DateTime, List<Schedule>> _schedules;
  LinkedHashMap<DateTime, List<Schedule>> get schedules => _schedules;

  int _getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  Future<void> getSchedulesForMonth(DateTime targetMonth, bool isAll) async {
    final _data = await dbService.getSchedulesForMonth(targetMonth, isAll);
    this._schedules = LinkedHashMap(equals: isSameDay, hashCode: _getHashCode)
      ..addAll(_data);
  }

  List<Schedule> getScheduleList(DateTime day) {
    return this._schedules[day] ?? [];
  }

  Future<void> addSchedule(Schedule schedule, target) async {
    if (_schedules.containsKey(schedule.start) == false) {
      _schedules[schedule.start] = [];
    }
    _schedules[schedule.start].add(schedule);
    await dbService.addSchedule(schedule, target);
  }

  void deleteSchedule(Schedule targetSchedule) {
    // await appState.storeService.deleteSchedule(targetSchedule);
    _schedules[targetSchedule.start] = _schedules[targetSchedule.start]
        .where((schedule) => schedule.title != targetSchedule.title)
        .toList();
  }
}

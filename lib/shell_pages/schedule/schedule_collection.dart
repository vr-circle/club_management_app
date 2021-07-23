import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/shell_pages/schedule/schedule.dart';
import 'package:flutter_application_1/store/store_service.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleCollection extends ChangeNotifier {
  ScheduleCollection() {
    this._schedules = LinkedHashMap(equals: isSameDay, hashCode: _getHashCode);
  }
  LinkedHashMap<DateTime, List<Schedule>> _schedules;
  // LinkedHashMap<DateTime, List<Schedule>> get schedules => _schedules;

  int _getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  Future<void> getSchedulesForMonth(DateTime targetMonth, bool isAll) async {
    final _data = await dbService.getSchedulesForMonth(targetMonth, isAll);
    this._schedules = LinkedHashMap(equals: isSameDay, hashCode: _getHashCode)
      ..addAll(_data);
  }

  List<Schedule> getScheduleForDay(DateTime day) {
    return this._schedules[day] ?? [];
  }

  Future<void> addSchedule(Schedule newSchedule, bool isPersonal) async {
    await dbService.addSchedule(newSchedule, isPersonal);
    _schedules[newSchedule.start].add(newSchedule);
  }

  Future<void> deleteSchedule(Schedule targetSchedule, bool isPersonal) async {
    await dbService.deleteSchedule(targetSchedule, isPersonal);
    _schedules[targetSchedule.start] = _schedules[targetSchedule.start]
        .where((schedule) => schedule.id != targetSchedule.id)
        .toList();
  }
}

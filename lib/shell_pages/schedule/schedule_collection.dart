import 'dart:collection';

import 'package:flutter_application_1/shell_pages/schedule/schedule.dart';
import 'package:flutter_application_1/store/store_service.dart';
import 'package:table_calendar/table_calendar.dart';

int _getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

class ScheduleCollection {
  ScheduleCollection()
      : this._schedules =
            LinkedHashMap(equals: isSameDay, hashCode: _getHashCode),
        this._loadTable = LinkedHashMap(
            equals: (DateTime a, DateTime b) =>
                a.year == b.year && a.month == b.month,
            hashCode: (DateTime key) => key.year + key.month * 10000);
  LinkedHashMap<DateTime, List<Schedule>> _schedules;

  LinkedHashMap<DateTime, bool> _loadTable;

  Future<void> loadSchedulesForMonth(DateTime targetMonth, bool isContainPublic,
      List<String> participatingOrganizationIdList) async {
    if (_loadTable[targetMonth] == false) {
      _loadTable[targetMonth] = true;
      final _data = await dbService.getSchedulesForMonth(
          targetMonth, isContainPublic, participatingOrganizationIdList);
      this._schedules.addAll(_data);
    }
  }

  List<Schedule> getSchedulesForDay(DateTime day) {
    return this._schedules[day] ?? [];
  }

  Future<List<Schedule>> loadScheduleForDay(DateTime day, bool isContainPublic,
      List<String> participatingOrganizationIdList) async {
    await loadSchedulesForMonth(
        day, isContainPublic, participatingOrganizationIdList);
    return this._schedules[day] ?? [];
  }

  Future<void> addSchedule(Schedule newSchedule, bool isPersonal) async {
    await dbService.addSchedule(newSchedule, isPersonal);
    if (_schedules.containsKey(newSchedule.start)) {
      _schedules[newSchedule.start].add(newSchedule);
      return;
    }
    _schedules[newSchedule.start] = [];
    _schedules[newSchedule.start].add(newSchedule);
  }

  Future<void> deleteSchedule(Schedule targetSchedule, bool isPersonal) async {
    await dbService.deleteSchedule(targetSchedule, isPersonal);
    if (_schedules.containsKey(targetSchedule.start)) {
      _schedules[targetSchedule.start] = _schedules[targetSchedule.start]
          .where((schedule) => schedule.id != targetSchedule.id)
          .toList();
      return;
    }
    _schedules[targetSchedule.start] = _schedules[targetSchedule.start]
        .where((schedule) => schedule.id != targetSchedule.id)
        .toList();
  }
}

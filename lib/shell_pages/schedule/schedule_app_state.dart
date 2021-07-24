import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/shell_pages/schedule/schedule.dart';
import 'package:flutter_application_1/shell_pages/schedule/schedule_collection.dart';

class ScheduleAppState extends ChangeNotifier {
  ScheduleAppState() : _scheduleCollection = ScheduleCollection();

  final ScheduleCollection _scheduleCollection;

  Future<void> getSchedulesForMonth(
      DateTime targetMonth, bool isContainPublic) async {
    await _scheduleCollection.getSchedulesForMonth(
        targetMonth, isContainPublic);
    notifyListeners();
  }

  List<Schedule> getScheduleForDay(DateTime day) {
    return this._scheduleCollection.getScheduleForDay(day);
  }

  Future<void> addSchedule(Schedule newSchedule, bool isPersonal) async {
    await _scheduleCollection.addSchedule(newSchedule, isPersonal);
    notifyListeners();
  }

  Future<void> deleteSchedule(Schedule targetSchedule, bool isPersonal) async {
    await _scheduleCollection.deleteSchedule(targetSchedule, isPersonal);
    notifyListeners();
  }
}

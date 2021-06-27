import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/auth_service.dart';
import 'package:flutter_application_1/schedule/schedule.dart';
import 'package:flutter_application_1/schedule/schedule_collection.dart';
import 'package:flutter_application_1/store/store_service.dart';

class MyAppState extends ChangeNotifier {
  MyAppState()
      : _selectedIndex = 1,
        _selectedDay = null,
        _selectedSchedule = null,
        _selectedTabInTodo = 0,
        _isSelectedUserSettings = false;
  int _selectedIndex;
  DateTime _selectedDay;
  Schedule _selectedSchedule;
  int _selectedTabInTodo;
  bool _isSelectedUserSettings;

  bool get isSelectedUserSettings => _isSelectedUserSettings;
  set isSelectedUserSettings(bool value) {
    _isSelectedUserSettings = value;
    notifyListeners();
  }

  int get selectedIndex => _selectedIndex;
  set selectedIndex(int idx) {
    _selectedIndex = idx;
    notifyListeners();
  }

  DateTime get selectedDay => _selectedDay;
  set selectedDay(DateTime day) {
    _selectedDay = day;
    notifyListeners();
  }

  Schedule get selectedSchedule => _selectedSchedule;
  set selectedSchedule(Schedule schedule) {
    _selectedSchedule = schedule;
    notifyListeners();
  }

  int get selectedTabInTodo => _selectedTabInTodo;
  set selectedTabInTodo(int idx) {
    _selectedTabInTodo = idx;
    notifyListeners();
  }

  // ---------------- todo ----------------

  // ---------------- schedule ----------------
  ScheduleCollection scheduleCollection = new ScheduleCollection();

  void setSelectedDay(DateTime day) {
    if (day == null) return;
    selectedDay = day;
    notifyListeners();
  }

  void setSelectedScheduleById(DateTime day, String id) {
    final List<Schedule> targetScheduleList = scheduleCollection
        .getScheduleList(day)
        .where((element) => element.id == id)
        .toList();
    print(targetScheduleList);
    if (targetScheduleList.isEmpty) {
      return;
    }
    setSelectedDay(day);
    selectedSchedule = targetScheduleList[0];
    // notifyListeners();
  }

  Future<void> addSchedule(Schedule schedule, String target) async {
    await storeService.addSchedule(schedule, target);
    scheduleCollection.addSchedule(schedule, target);
    notifyListeners();
  }

  Future<void> deleteSchedule(Schedule targetSchedule) async {
    await storeService.deleteSchedule(targetSchedule);
    scheduleCollection.deleteSchedule(targetSchedule);
    notifyListeners();
  }

  Future<Map<DateTime, List<Schedule>>> getSchedule(
      List<String> targets) async {
    return (await storeService.getSchedule(targets));
  }

  List<Schedule> getScheduleList(DateTime day) {
    return scheduleCollection.getScheduleList(day);
  }

  // ---------------- auth ----------------
  AuthService _authService = AuthService();
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _authService.signInWithEmailAndPassword(email, password);
    notifyListeners();
  }

  Future<void> signOut() async {
    await _authService.signOut();
    notifyListeners();
  }

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    await _authService.signUpWithEmailAndPassword(email, password);
    notifyListeners();
  }

  User getCurrentUser() {
    return _authService.getCurrentUser();
  }
}
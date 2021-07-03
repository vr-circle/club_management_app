import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/auth_service.dart';
import 'package:flutter_application_1/pages/schedule/schedule.dart';
import 'package:flutter_application_1/pages/schedule/schedule_collection.dart';
import 'package:flutter_application_1/pages/todo/task.dart';
import 'package:flutter_application_1/pages/todo/todo_collection.dart';
import 'package:flutter_application_1/store/store_service.dart';

class MyAppState extends ChangeNotifier {
  MyAppState()
      : _selectedIndex = 0,
        _selectedDay = null,
        _selectedSchedule = null,
        _selectedTabInTodo = 'private',
        _isSelectedUserSettings = false,
        _selectedSearchingClubId = null;
  int _selectedIndex;
  DateTime _selectedDay;
  DateTime _selectedCalendarPage;
  Schedule _selectedSchedule;
  String _selectedTabInTodo;
  bool _isSelectedUserSettings;
  String _selectedSearchingClubId;

  String get selectedSearchingClubId => _selectedSearchingClubId;
  set selectedSearchingClubId(String id) {
    _selectedSearchingClubId = id;
    notifyListeners();
  }

  DateTime get selectedCalendarPage => _selectedCalendarPage;
  set selectedCalendarPage(DateTime day) {
    _selectedCalendarPage = day;
    notifyListeners();
  }

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

  // ---------------- todo ----------------
  TodoCollection todoCollection;
  String get selectedTabInTodo => _selectedTabInTodo;
  set selectedTabInTodo(String target) {
    _selectedTabInTodo = target;
    notifyListeners();
  }

  void addTask(Task newTask, String target) {
    todoCollection.addTask(newTask, target);
    notifyListeners();
  }

  void deleteTask(Task targetTask, String targetGroupID) {
    todoCollection.deleteTask(targetTask, targetGroupID);
    notifyListeners();
  }

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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/auth_service.dart';
import 'package:flutter_application_1/pages/schedule/schedule.dart';
import 'package:flutter_application_1/pages/schedule/schedule_collection.dart';
import 'package:flutter_application_1/pages/search/club.dart';
import 'package:flutter_application_1/pages/todo/task.dart';
import 'package:flutter_application_1/pages/todo/todo_collection.dart';
import 'package:flutter_application_1/store/store_service.dart';

class MyAppState extends ChangeNotifier {
  MyAppState()
      : _selectedIndex = 0,
        _selectedDay = null,
        _selectedSchedule = null,
        _selectedTabInTodo = 0,
        _isSelectedUserSettings = false,
        _selectedSearchingClubId = '',
        _isSelectedSearching = false,
        _searchingParams = '';

  // app shell
  int _selectedIndex;

  // schedule
  DateTime _selectedDay;
  // DateTime _selectedCalendarPage;
  Schedule _selectedSchedule;
  bool isOpeningAddSchedulePage;

  // todo
  int _selectedTabInTodo;
  bool isOpeningAddTodoPage;

  // search
  String _searchingParams;
  bool _isSelectedSearching;
  String _selectedSearchingClubId;
  // bool _isSearchMode;

  // settings
  bool _isSelectedUserSettings;

  Future<List<ClubInfo>> getClubList() async {
    return (await dbService.getClubList());
  }

  String get searchingParams => _searchingParams;
  set searchingParams(String value) {
    _searchingParams = value;
    notifyListeners();
  }

  bool get isSelectedSearching => _isSelectedSearching;
  set isSelectedSearching(bool value) {
    _isSelectedSearching = value;
    notifyListeners();
  }

  String get selectedSearchingClubId => _selectedSearchingClubId;
  set selectedSearchingClubId(String id) {
    _selectedSearchingClubId = id;
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
  int get selectedTabInTodo => _selectedTabInTodo;
  set selectedTabInTodo(int target) {
    _selectedTabInTodo = target;
    notifyListeners();
  }

  // ---------------- schedule ----------------
  void setSelectedDay(DateTime day) {
    if (day == null) return;
    selectedDay = day;
    notifyListeners();
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
    final x = _authService.getCurrentUser();
    notifyListeners();
    return x;
  }
}

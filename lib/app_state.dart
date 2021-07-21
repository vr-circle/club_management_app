import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/auth_service.dart';
import 'package:flutter_application_1/auth/login_page.dart';
import 'package:flutter_application_1/route_path.dart';
import 'package:flutter_application_1/shell_pages/schedule/schedule.dart';

class AppState extends ChangeNotifier {
  AppState()
      :
        // auth
        _authService = AuthService(),
        _loggedinState = LoggedInState.loggedOut,
        _isOpenSignUpPage = false,
        // shell
        _bottomNavigationIndex = HomePath.index,
        // schedule
        _targetCalendarMonth = DateTime.now(),
        _selectedDayForScheduleList = null,
        _selectedSchedule = null,
        _isOpenAddSchedulePage = false,
        // todo
        _targetTodoTabId = '',
        _targetOrganizationId = '',
        // search
        _searchingParam = '',
        _isOpenAddOrganizationPage = false,
        // setting
        _isDarkMode = false,
        _isOpenAccountView = false,
        _settingOrganizationId = '';

  bool _isOpenSignUpPage;
  bool get isOpenSignUpPage => _isOpenSignUpPage;
  set isOpenSignUpPage(bool value) {
    _isOpenSignUpPage = value;
    notifyListeners();
  }

  int _bottomNavigationIndex;
  int get bottomNavigationIndex => _bottomNavigationIndex;
  set bottomNavigationIndex(int index) {
    _bottomNavigationIndex = index;
    notifyListeners();
  }

  // schedule
  DateTime _targetCalendarMonth;
  DateTime get targetCalendarMonth => _targetCalendarMonth;
  set targetCalendarMonth(DateTime day) {
    _targetCalendarMonth = day;
    notifyListeners();
  }

  DateTime _selectedDayForScheduleList;
  DateTime get selectedDayForScheduleList => _selectedDayForScheduleList;
  set selectedDayForScheduleList(DateTime day) {
    _selectedDayForScheduleList = day;
    notifyListeners();
  }

  Schedule _selectedSchedule;
  Schedule get selectedSchedule => _selectedSchedule;
  set selectedSchedule(Schedule newSchedule) {
    _selectedSchedule = newSchedule;
    notifyListeners();
  }

  bool _isOpenAddSchedulePage;
  bool get isOpenAddSchedulePage => _isOpenAddSchedulePage;
  set isOpenAddSchedulePage(bool value) {
    _isOpenAddSchedulePage = value;
    notifyListeners();
  }

  // todo
  String _targetTodoTabId;
  String get targetTodoTabId => _targetTodoTabId;
  set targetTodoTabId(String value) {
    _targetTodoTabId = value;
    notifyListeners();
  }

  // search
  String _searchingParam;
  String get searchingParam => _searchingParam;
  set searchingParam(String value) {
    _searchingParam = value;
    notifyListeners();
  }

  String _targetOrganizationId;
  String get targetOrganizationId => _targetOrganizationId;
  set targetOrganizationId(String value) {
    _targetOrganizationId = value;
    notifyListeners();
  }

  // settings
  bool _isDarkMode;
  bool get isDarkMode => _isDarkMode;
  set isDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  bool _isOpenAccountView;
  bool get isOpenAccountView => _isOpenAccountView;
  set isOpenAccountView(bool value) {
    _isOpenAccountView = value;
    notifyListeners();
  }

  String _settingOrganizationId;
  String get settingOrganizationId => _settingOrganizationId;
  set settingOrganizationId(String value) {
    _settingOrganizationId = value;
    notifyListeners();
  }

  bool _isOpenAddOrganizationPage;
  bool get isOpenAddOrganizationPage => _isOpenAddOrganizationPage;
  set isOpenAddOrganizationPage(bool value) {
    _isOpenAddOrganizationPage = value;
    notifyListeners();
  }

  Stream<User> Function() authStateChange() {
    return _authService.authStateChange();
  }

  void handleChangeLoggedInState(LoggedInState state) {
    this._loggedinState = state;
    notifyListeners();
  }

  User get user => _authService.user;
  set user(User user) {
    _authService.user = user;
    if (user != null) this._loggedinState = LoggedInState.loggedIn;
    notifyListeners();
  }

  AuthService _authService;
  LoggedInState _loggedinState;
  LoggedInState get loggedInState => _loggedinState;
  Future<void> logIn(String email, String password) async {
    _loggedinState = LoggedInState.loading;
    notifyListeners();
    await _authService.signInWithEmailAndPassword(email, password);
    _loggedinState = LoggedInState.loggedIn;
    notifyListeners();
  }

  Future<void> updateUserDisplayName(String name) async {
    await _authService.updateDisplayName(name);
    notifyListeners();
  }

  Future<void> signUpWithEmailAndPasswordAndName(
      String email, String password, String displayName) async {
    await _authService.signUpWithEmailAndPasswordAndName(
        email, password, displayName);
  }

  Future<void> logOut() async {
    _loggedinState = LoggedInState.loading;
    notifyListeners();
    await _authService.signOut();
    _loggedinState = LoggedInState.loggedOut;
    notifyListeners();
  }
}

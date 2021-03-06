import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/auth_service.dart';
import 'package:flutter_application_1/auth/login_page.dart';
import 'package:flutter_application_1/route_path.dart';
import 'package:flutter_application_1/shell_pages/schedule/schedule.dart';
import 'package:flutter_application_1/shell_pages/schedule/schedule_collection.dart';
import 'package:flutter_application_1/shell_pages/search/organization_info.dart';
import 'package:flutter_application_1/shell_pages/todo/task.dart';
import 'package:flutter_application_1/shell_pages/todo/task_group.dart';
import 'package:flutter_application_1/shell_pages/todo/todo_collection.dart';
import 'package:flutter_application_1/store/store_service.dart';
import 'package:flutter_application_1/user_settings/user_settings.dart';
import 'package:flutter_application_1/user_settings/user_theme.dart';

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
        _scheduleCollection = ScheduleCollection(),
        _targetCalendarMonth = DateTime.now(),
        _selectedDayForScheduleList = null,
        _selectedSchedule = null,
        _isOpenAddSchedulePage = false,
        _isContainPublicSchedule = false,
        // todo
        _todoCollection = TodoCollection(),
        _todoTargetTabIndexId = '',
        // search
        _searchingParam = '',
        _searchingOrganizationId = '',
        _isOpenCreateOrganizationPage = false,
        // setting
        _participatingOrganizationList = [],
        _isOpenAccountView = false,
        _selectedSettingOrganizationId = '',
        _userSettings = null;

  TodoCollection _todoCollection;

  String _todoTargetTabIndexId;
  String get todoTargetTabIndexId => _todoTargetTabIndexId;
  set todoTargetTabIndexId(String v) {
    _todoTargetTabIndexId = v;
    notifyListeners();
  }

  void initTodoCollection() {
    _todoCollection.initCollection(_participatingOrganizationList);
  }

  List<TaskGroup> getTaskGroupList([String id]) {
    return _todoCollection.getTaskGroupList(id);
  }

  Future<void> loadTasks([String targetOrganizationId]) async {
    await _todoCollection.loadTask(targetOrganizationId);
    notifyListeners();
  }

  Future<void> addTask(Task newTask, String targetGroupId,
      [String targetOrganizationId]) async {
    await _todoCollection.addTask(newTask, targetGroupId, targetOrganizationId);
    notifyListeners();
  }

  Future<void> deleteTask(Task targetTask, String targetGroupId,
      [String targetOrganizationId]) async {
    await _todoCollection.deleteTask(
        targetTask, targetGroupId, targetOrganizationId);
    notifyListeners();
  }

  Future<void> addGroup(String newGroupName,
      [String targetOrganizationId]) async {
    await _todoCollection.addGroup(newGroupName, targetOrganizationId);
    notifyListeners();
  }

  Future<void> deleteGroup(String targetGroupId,
      [String targetOrganizationId]) async {
    await _todoCollection.deleteGroup(targetGroupId, targetOrganizationId);
    notifyListeners();
  }

  UserSettings _userSettings;
  UserThemeSettings get userThemeSettings => _userSettings.userThemeSettings;
  ThemeData get generalTheme => _userSettings.userThemeSettings.generalTheme;
  Color get personalEventColor => _userSettings.personalEventColor;
  set userSettings(UserSettings userSettings) {
    _userSettings = userSettings;
    notifyListeners();
  }

  set personalEventColor(Color value) {
    _userSettings.userThemeSettings.personalEventColor = value;
    notifyListeners();
  }

  Color get organizationEventColor => _userSettings == null
      ? Colors.blue
      : _userSettings.organizationEventColor;
  set organizationEventColor(Color value) {
    _userSettings.userThemeSettings.organizationEventColor = value;
    notifyListeners();
  }

  Future<bool> initUserSettings() async {
    if (_userSettings != null) {
      return false;
    }
    _userSettings = await dbService.initializeUserSettings();
    final res = <OrganizationInfo>[];
    await Future.forEach(_userSettings.participatingOrganizationIdList,
        (id) async {
      res.add(await dbService.getOrganizationInfo(id, true));
    });
    _participatingOrganizationList = res;
    notifyListeners();
    return true;
  }

  Future<void> updateUserTheme(UserThemeSettings userTheme) async {
    dbService.updateUserTheme(userTheme);
    notifyListeners();
  }

  List<OrganizationInfo> _participatingOrganizationList;
  List<OrganizationInfo> get participatingOrganizationList =>
      _participatingOrganizationList;
  // Future<void> getParticipatingOrganizationInfoListFromDatabase() async {
  //   final ids = await dbService.getParticipatingOrganizationIdList();
  //   final res = <OrganizationInfo>[];
  //   await Future.forEach(ids, (id) async {
  //     res.add(await dbService.getOrganizationInfo(id));
  //   });
  //   _participatingOrganizationList = res;
  //   notifyListeners();
  // }

  Future<void> createOrganization(OrganizationInfo newOrganization) async {
    final organization = await dbService.createOrganization(newOrganization);
    _participatingOrganizationList.add(organization);
    notifyListeners();
  }

  Future<void> deleteOrganization(String targetOrganizationId) async {
    dbService.deleteOrganization(targetOrganizationId);
    _participatingOrganizationList = _participatingOrganizationList
        .where((element) => element.id != targetOrganizationId)
        .toList();
    notifyListeners();
  }

  Future<void> joinOrganization(OrganizationInfo info) async {
    await dbService.joinOrganization(info.id);
    if (_participatingOrganizationList
        .where((element) => element.id == info.id)
        .toList()
        .isEmpty) _participatingOrganizationList.add(info);
    notifyListeners();
  }

  Future<void> leaveOrganization(String id) async {
    final target = _participatingOrganizationList
        .where((element) => element.id == id)
        .toList()
        .first;
    // if (target.memberNum <= 1) {
    //   return;
    // }
    await dbService.leaveOrganization(target);
    _participatingOrganizationList =
        _participatingOrganizationList.where((info) => info.id != id).toList();
    notifyListeners();
  }

  bool _isContainPublicSchedule;
  bool get isContainPublicSchedule => _isContainPublicSchedule;
  set isContainPublicSchedule(bool value) {
    _isContainPublicSchedule = value;
    notifyListeners();
  }

  ScheduleCollection _scheduleCollection;
  Future<void> loadSchedulesForMonth(DateTime targetMonth) async {
    await _scheduleCollection.loadSchedulesForMonth(
        targetMonth,
        _isContainPublicSchedule,
        _userSettings.participatingOrganizationIdList);
    notifyListeners();
  }

  List<Schedule> getScheduleForDay(DateTime day) {
    return _scheduleCollection.getSchedulesForDay(day);
  }

  Future<void> addSchedule(Schedule newSchedule, bool isPersonal) async {
    await _scheduleCollection.addSchedule(newSchedule, isPersonal);
    notifyListeners();
  }

  Future<void> deleteSchedule(Schedule targetSchedule, bool isPersonal) async {
    await _scheduleCollection.deleteSchedule(targetSchedule, isPersonal);
    notifyListeners();
  }

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

  // search
  String _searchingParam;
  String get searchingParam => _searchingParam;
  set searchingParam(String value) {
    _searchingParam = value;
    notifyListeners();
  }

  String _searchingOrganizationId;
  String get searchingOrganizationId => _searchingOrganizationId;
  set searchingOrganizationId(String value) {
    _searchingOrganizationId = value;
    notifyListeners();
  }

  // settings
  bool _isOpenAccountView;
  bool get isOpenAccountView => _isOpenAccountView;
  set isOpenAccountView(bool value) {
    _isOpenAccountView = value;
    notifyListeners();
  }

  String _selectedSettingOrganizationId;
  String get selectedSettingOrganizationId => _selectedSettingOrganizationId;
  set selectedSettingOrganizationId(String value) {
    _selectedSettingOrganizationId = value;
    notifyListeners();
  }

  bool _isOpenCreateOrganizationPage;
  bool get isOpenCreateOrganizationPage => _isOpenCreateOrganizationPage;
  set isOpenCreateOrganizationPage(bool value) {
    _isOpenCreateOrganizationPage = value;
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
    try {
      await _authService.signInWithEmailAndPassword(email, password);
      _loggedinState = LoggedInState.loggedIn;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      // switch (e.code) {
      // case 'wrong-password':
      // break;
      //   default:
      //     break;
      // }
      _loggedinState = LoggedInState.loggedOut;
      notifyListeners();
    }
  }

  Future<void> updateUserDisplayName(String name) async {
    await _authService.updateDisplayName(name);
    notifyListeners();
  }

  Future<void> signUpWithEmailAndPasswordAndName(
      String email, String password, String displayName) async {
    _loggedinState = LoggedInState.loading;
    notifyListeners();
    user = await _authService.signUpWithEmailAndPasswordAndName(
        email, password, displayName);
    await initUserSettings();
    _loggedinState = LoggedInState.loggedIn;
    notifyListeners();
  }

  Future<void> logOut() async {
    _loggedinState = LoggedInState.loading;
    notifyListeners();
    await _authService.signOut();
    _loggedinState = LoggedInState.loggedOut;
    notifyListeners();
  }
}

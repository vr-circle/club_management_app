import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/auth_service.dart';
import 'package:flutter_application_1/auth/login_page.dart';
import 'package:flutter_application_1/route_path.dart';

class AppState extends ChangeNotifier {
  AppState()
      : _loggedinState = LoggedInState.loggedOut,
        _bottomNavigationIndex = HomePath.index,
        _searchingParam = '',
        _isOpenAccountView = false,
        _isDarkMode = false,
        _targetTodoTabId = '',
        _targetOrganizationId = '',
        _authService = AuthService();

  int _bottomNavigationIndex;
  int get bottomNavigationIndex => _bottomNavigationIndex;
  set bottomNavigationIndex(int index) {
    _bottomNavigationIndex = index;
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
  bool _isOpenAccountView;
  bool get isOpenAccountView => _isOpenAccountView;
  set isOpenAccountView(bool value) {
    _isOpenAccountView = value;
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
    this._loggedinState = LoggedInState.loggedIn;
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

  Future<void> logOut() async {
    _loggedinState = LoggedInState.loading;
    notifyListeners();
    await Future.delayed(Duration(seconds: 2));
    _loggedinState = LoggedInState.loggedOut;
    notifyListeners();
  }
}

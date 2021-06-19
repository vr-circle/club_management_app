import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService() {
    this._firebaseAuth = FirebaseAuth.instance;
  }
  FirebaseAuth _firebaseAuth;
  User _user;

  User get user => _user;

  Future<bool> isLoggedIn() async {
    this._user = _firebaseAuth.currentUser;
    if (this._user == null) {
      return false;
    }
    return true;
  }

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    try {
      final res = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return;
    } catch (e) {
      return;
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    this._user = (await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  User getCurrentUser() {
    return _firebaseAuth.currentUser;
  }
}

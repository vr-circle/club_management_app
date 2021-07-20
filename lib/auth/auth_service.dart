import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService() : this._firebaseAuth = FirebaseAuth.instance;

  Stream<User> Function() authStateChange() {
    return _firebaseAuth.authStateChanges;
  }

  FirebaseAuth _firebaseAuth;

  User _user;
  User get user => _firebaseAuth.currentUser ?? _user;
  set user(User user) {
    this._user = user;
  }

  Future<void> updateDisplayName(String name) async {
    await _user.updateDisplayName(name);
  }

  Future<void> signUpWithEmailAndPasswordAndName(
      String email, String password, String displayName) async {
    try {
      final resUserCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      await resUserCredential.user.updateDisplayName(displayName);
      return;
    } catch (e) {
      print(e);
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
}

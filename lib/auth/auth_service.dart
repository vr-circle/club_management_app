import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<User> signUpWithEmailAndPasswordAndName(
      String email, String password, String displayName) async {
    final resUserCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    await resUserCredential.user.updateDisplayName(displayName);
    await FirebaseFirestore.instance.collection('users').doc(_user.uid).set({
      'name': displayName,
      'organizations': [],
      'theme': {
        'general': 'none',
        'event': {'organization': 0xffff0000, 'personal': 0xff00ff00}
      }
    });
    return resUserCredential.user;
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

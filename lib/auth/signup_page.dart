import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'auth_service.dart';

class SignUpPage extends HookWidget {
  SignUpPage(this.appState);
  MyAppState appState;
  @override
  Widget build(BuildContext context) {
    String email = '';
    String password = '';
    return Scaffold(
      appBar: AppBar(
        title: Text('アカウントを登録'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                decoration: InputDecoration(
                    icon: Icon(Icons.email), labelText: 'Email'),
                onChanged: (value) {
                  email = value;
                },
              ),
              TextField(
                decoration: InputDecoration(
                    icon: Icon(Icons.lock_open), labelText: 'Password'),
                onChanged: (value) {
                  password = value;
                },
              ),
              TextButton(
                  onPressed: () async {
                    // signup function
                    try {
                      appState.signUpWithEmailAndPassword(email, password);
                    } catch (e) {
                      // failed to signup
                      print('failed to signUp');
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text('SignUp'))
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'auth_credentials.dart';
import '../schedule/schedule.dart';

final loginCredentialProvider =
    StateNotifierProvider((ref) => LoginCredentialState());

class LoginCredentialState extends StateNotifier {
  LoginCredentialState() : super(LoginCredential());

  void login(String username, String password) {
    print('login!');
  }
}

class LoginCredential {
  final String username;
  final String password;
  LoginCredential({this.username, this.password});
}

class LoginPage extends HookWidget {
  // be state
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Padding(
      padding: EdgeInsets.all(32),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(
          // controller: _usernameController,
          decoration:
              InputDecoration(icon: Icon(Icons.mail), labelText: 'Username'),
        ),
        TextField(
          // controller: _passwordController,
          decoration: InputDecoration(
              icon: Icon(Icons.lock_open), labelText: 'Password'),
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
        ),
        Consumer(builder: (context, watch, child) {
          return TextButton(
              onPressed: () {
                watch(loginCredentialProvider.notifier).login(
                    _usernameController.text.trim(),
                    _passwordController.text.trim());
              },
              child: Text('login'));
        }),
      ]),
    )));
  }
}

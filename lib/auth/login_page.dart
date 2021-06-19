import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'signup_page.dart';

final loginInfoStateProvider = StateNotifierProvider((ref) => LoginInfoState());

class UserStateNotifier extends StateNotifier<UserState> {
  UserStateNotifier() : super(UserState());
}

class UserState {
  UserState();
  LoginInfo loginInfo = LoginInfo();
}

class LoginInfoState extends StateNotifier<LoginInfo> {
  LoginInfoState() : super(LoginInfo());

  String get email => state.email;
  String get password => state.password;
  void updateEmail(String value) {
    state.email = value;
  }

  void updatePassword(String value) {
    state.password = value;
  }
}

class LoginInfo {
  LoginInfo() {
    email = '';
    password = '';
  }
  String email;
  String password;
}

class LoginPage extends HookWidget {
  LoginPage(this.appState);
  final MyAppState appState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Club Management App'),
        ),
        body: Center(
            child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
              decoration:
                  InputDecoration(icon: Icon(Icons.mail), labelText: 'Email'),
              onChanged: (value) {
                context
                    .read(loginInfoStateProvider.notifier)
                    .updateEmail(value);
              },
            ),
            TextField(
              decoration: InputDecoration(
                  icon: Icon(Icons.lock_open), labelText: 'Password'),
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              onChanged: (value) {
                context
                    .read(loginInfoStateProvider.notifier)
                    .updatePassword(value);
              },
            ),
            Consumer(builder: (context, watch, child) {
              return TextButton(
                  onPressed: () async {
                    String email =
                        context.read(loginInfoStateProvider.notifier).email;
                    String password =
                        context.read(loginInfoStateProvider.notifier).password;
                    try {
                      // login with email and password
                      await appState.signInWithEmailAndPassword(
                          email, password);
                      // if success to login
                    } catch (e) {
                      // if failed to login
                      // show error message by widget
                      print('failed to login');
                    }
                  },
                  child: Text('login'));
            }),
            SizedBox(
              height: 32,
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return SignUpPage(appState);
                  }));
                },
                child: Text('アカウントをお持ちでない場合'))
          ]),
        )));
  }
}

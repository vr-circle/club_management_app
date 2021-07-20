import 'package:flutter/material.dart';

enum LoggedInState {
  loading,
  loggedIn,
  loggedOut,
}

class LoginPage extends StatefulWidget {
  LoginPage(
      {Key key,
      @required this.handleLogin,
      @required this.handleChangeOpeningSignUpPage})
      : super(key: key);
  final void Function(bool value) handleChangeOpeningSignUpPage;
  final Future<void> Function(String email, String password) handleLogin;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = '', password = '';
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Organization Management App'),
        ),
        body: Center(
            child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
              decoration:
                  InputDecoration(icon: Icon(Icons.mail), labelText: 'Email'),
              onChanged: (value) {
                this.email = value;
              },
            ),
            TextField(
              decoration: InputDecoration(
                  icon: Icon(Icons.lock_open), labelText: 'Password'),
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              onChanged: (value) {
                this.password = value;
              },
            ),
            TextButton(
                onPressed: () async {
                  // login
                  widget.handleLogin(this.email, this.password);
                },
                child: const Text('Login')),
            SizedBox(
              height: 32,
            ),
            TextButton(
                onPressed: () {
                  widget.handleChangeOpeningSignUpPage(true);
                },
                child: Text('Do you have an account?'))
          ]),
        )));
  }
}

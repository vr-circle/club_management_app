import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage(
      {Key key,
      this.signUpWithEmailAndPasswordAndName,
      this.handleCloseSignUpPage})
      : super(key: key);
  final Future<void> Function(String email, String password, String displayName)
      signUpWithEmailAndPasswordAndName;
  final void Function() handleCloseSignUpPage;
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String email = '';
  String password = '';
  String displayName = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SignUp'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                decoration: const InputDecoration(
                    icon: const Icon(Icons.perm_identity),
                    labelText: 'Display Name'),
                onChanged: (value) {
                  displayName = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(
                    icon: const Icon(Icons.email), labelText: 'Email'),
                onChanged: (value) {
                  email = value;
                },
              ),
              TextField(
                decoration: InputDecoration(
                    icon: const Icon(Icons.lock_open), labelText: 'Password'),
                onChanged: (value) {
                  password = value;
                },
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
              ),
              TextButton(
                  onPressed: () async {
                    if (email.isEmpty ||
                        password.isEmpty ||
                        displayName.isEmpty) {
                      return;
                    }
                    await widget.signUpWithEmailAndPasswordAndName(
                        email, password, displayName);
                  },
                  child: const Text('SignUp'))
            ],
          ),
        ),
      ),
    );
  }
}

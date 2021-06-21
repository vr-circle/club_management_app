import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class UserAccountView extends HookWidget {
  UserAccountView({this.user});
  final User user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('アカウント情報'),
      ),
      body: Center(
        child: Column(
          children: [
            ListTile(
              title: Text('名前'),
              trailing: Text(user.displayName == null
                  ? '(表示名は設定されていません)'
                  : user.displayName),
            ),
            ListTile(
              title: Text('Email'),
              trailing: Text(user.email),
            ),
          ],
        ),
      ),
    );
  }
}

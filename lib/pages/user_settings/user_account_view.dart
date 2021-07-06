import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/user_settings/settings.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UserAccountView extends HookWidget {
  UserAccountView({this.user});
  final User user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ListTile(
              title: Text('Account information'),
            ),
            Divider(
              height: 8,
              color:
                  useProvider(darkModeProvider) ? Colors.white : Colors.black,
            ),
            ListTile(
              title: Text('name'),
              trailing:
                  Text(user.displayName == null ? '(Empty)' : user.displayName),
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

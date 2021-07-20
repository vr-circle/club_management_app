import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class UserAccountView extends HookWidget {
  UserAccountView(
      {Key key,
      @required this.user,
      @required this.handleChangeUserAccountName});
  final Future<void> Function(String name) handleChangeUserAccountName;
  final User user;
  @override
  Widget build(BuildContext context) {
    String newName = '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Information'),
      ),
      body: Center(
        child: Column(
          children: [
            ListTile(
              leading: const Text('Name'),
              title: Text(user.displayName ?? '(Empty)'),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () async {
                  await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Edit Display Name'),
                          content: Padding(
                            padding: EdgeInsets.all(8),
                            child: TextField(
                              decoration: InputDecoration(
                                  labelText: 'New Display Name',
                                  icon: Icon(Icons.perm_identity)),
                              onChanged: (value) {
                                newName = value;
                              },
                              onSubmitted: (value) {
                                handleChangeUserAccountName(value);
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  handleChangeUserAccountName(newName);
                                  Navigator.pop(context);
                                },
                                child: Text('Update')),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Cancel')),
                          ],
                        );
                      });
                },
              ),
            ),
            ListTile(
              leading: const Text('Email'),
              title: Text(user.email),
            ),
          ],
        ),
      ),
    );
  }
}

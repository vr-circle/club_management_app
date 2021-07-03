import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static const String route = '/homepage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Text('this is home'),
    ));
  }
}

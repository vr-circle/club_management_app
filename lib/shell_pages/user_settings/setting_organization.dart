import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_state.dart';

class SettingOrganization extends StatefulWidget {
  SettingOrganization({Key key, @required this.appState}) : super(key: key);
  final AppState appState;
  @override
  _SettingOrganizationState createState() => _SettingOrganizationState();
}

class _SettingOrganizationState extends State<SettingOrganization> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('tmp'),
      ),
      body: const Center(
        child: const Text('tmp'),
      ),
    );
  }
}

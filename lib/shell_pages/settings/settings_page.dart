import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_state.dart';
import 'package:flutter_application_1/shell_pages/search/organization_info.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({
    Key key,
    @required this.appState,
    @required this.participatingOrganizationInfoList,
  });
  final AppState appState;
  final List<OrganizationInfo> participatingOrganizationInfoList;
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const FlutterLogo(),
              const Text('CMA'),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            const ListTile(
              title: const Text('Organizations'),
            ),
            ListTile(
              leading: Icon(Icons.person_add_alt),
              onTap: () {
                widget.appState.isOpenAddOrganizationPage = true;
              },
              title: const Text('New Organization'),
            ),
            Column(children: [
              ...widget.participatingOrganizationInfoList
                  .map((e) => ListTile(
                        onTap: () {
                          widget.appState.settingOrganizationId = e.id;
                        },
                        leading: const Icon(Icons.people),
                        title: Text(e.name),
                      ))
                  .toList(),
            ]),
            const Divider(
              height: 8,
            ),
            const ListTile(
              title: const Text('Account'),
            ),
            ListTile(
              leading: const Icon(Icons.account_box),
              title: const Text('Account management'),
              onTap: () {
                widget.appState.isOpenAccountView = true;
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text(
                'SignOut',
                style: const TextStyle(color: Colors.red),
              ),
              onTap: () async {
                await widget.appState.logOut();
              },
            ),
            const Divider(
              height: 8,
            ),
            const ListTile(title: const Text('Information')),
            const ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Version'),
              subtitle: const Text('1.0.0'),
            ),
          ]),
        ));
  }
}

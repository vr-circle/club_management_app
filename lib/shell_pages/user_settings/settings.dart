import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_state.dart';
import 'package:flutter_application_1/store/store_service.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({
    Key key,
    @required this.appState,
  });
  final AppState appState;
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<List<OrganizationIdAndName>> getOrganizationName() async {
    List<OrganizationIdAndName> res = [];
    final ids = await dbService.getParticipatingOrganizationIdList();
    await Future.forEach(ids, (id) async {
      final _name = (await dbService.getOrganizationInfo(id)).name;
      final _tmp = OrganizationIdAndName(id: id, name: _name);
      res.add(_tmp);
    });
    return res;
  }

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
            FutureBuilder(
                future: this.getOrganizationName(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<OrganizationIdAndName>> snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const ListTile(
                      title: const Text('Loading...'),
                    );
                  }
                  return Column(children: [
                    ...snapshot.data
                        .map((e) => ListTile(
                              onTap: () {
                                widget.appState.settingOrganizationId = e.id;
                                // todo : e => id
                              },
                              leading: const Icon(Icons.people),
                              title: Text(e.name),
                            ))
                        .toList(),
                  ]);
                }),
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
                widget.appState.logOut();
              },
            ),
            // const Divider(),
            // const ListTile(
            //   title: const Text('Theme'),
            // ),
            // ListTile(
            //   leading: const Icon(Icons.dark_mode),
            //   title: const Text('Dark mode'),
            //   trailing: Switch(
            //     value: widget.appState.isDarkMode,
            //     onChanged: (value) async {
            //     },
            //   ),
            // ),
            const Divider(),
            const ListTile(title: const Text('Information')),
            const ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Version'),
              subtitle: const Text('0.1.0'),
            ),
          ]),
        ));
  }
}

class OrganizationIdAndName {
  OrganizationIdAndName({@required this.id, @required this.name});
  String id;
  String name;
}

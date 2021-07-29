import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_state.dart';
import 'package:flutter_application_1/shell_pages/search/organization_info.dart';

class SettingOrganization extends StatefulWidget {
  SettingOrganization({Key key, @required this.id, @required this.appState})
      : super(key: key);
  final String id;
  final AppState appState;
  @override
  _SettingOrganizationState createState() => _SettingOrganizationState();
}

class _SettingOrganizationState extends State<SettingOrganization> {
  OrganizationInfo _organizationInfo;
  Future<OrganizationInfo> _futureOrganizationInfo;

  @override
  void initState() {
    _futureOrganizationInfo = this._getOrganizationInfo();
    super.initState();
  }

  Future<OrganizationInfo> _getOrganizationInfo() async {
    _organizationInfo = widget.appState.participatingOrganizationList
        .where((element) => element.id == widget.id)
        .first;
    return _organizationInfo;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureOrganizationInfo,
      builder:
          (BuildContext context, AsyncSnapshot<OrganizationInfo> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: const CircularProgressIndicator(),
          );
        }
        return Scaffold(
            appBar: AppBar(
              title: Text(_organizationInfo.name),
              actions: [
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                    child: TextButton(
                        onPressed: () async {
                          await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title:
                                      Text('Leave ${_organizationInfo.name}?'),
                                  content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            'You are about to leave ${_organizationInfo.name}.'),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        const Text('Are you sure?'),
                                      ]),
                                  actions: [
                                    TextButton(
                                        onPressed: () async {
                                          await widget.appState
                                              .leaveOrganization(
                                                  _organizationInfo.id);
                                          widget.appState
                                              .settingOrganizationId = '';
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Leave')),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancel')),
                                  ],
                                );
                              });
                        },
                        child: const Text('Leave')))
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 320,
                      width: MediaQuery.of(context).size.width,
                      child: const FittedBox(
                          fit: BoxFit.contain, child: FlutterLogo())),
                  const ListTile(
                    title: const Text('Name'),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(32, 0, 32, 0),
                    child: Text('${_organizationInfo.name}'),
                  ),
                  const ListTile(
                    title: const Text('Tags'),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(32, 0, 32, 0),
                    child: Wrap(
                      children: _organizationInfo.tagList
                          .map((e) => (Card(
                              child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Text(e))))))
                          .toList(),
                    ),
                  ),
                  const ListTile(
                    title: const Text('Introduction'),
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                      child: Text(_organizationInfo.introduction)),
                  const ListTile(
                    title: const Text('Number of persons'),
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                      child: Text(_organizationInfo.memberNum.toString())),
                ],
              ),
            ));
      },
    );
  }
}

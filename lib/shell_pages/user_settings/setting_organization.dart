import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_state.dart';
import 'package:flutter_application_1/shell_pages/search/organization_info.dart';
import 'package:flutter_application_1/store/store_service.dart';

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
    _organizationInfo = await dbService.getOrganizationInfo(widget.id);
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
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      height: 320,
                      width: MediaQuery.of(context).size.width,
                      child:
                          FittedBox(fit: BoxFit.contain, child: FlutterLogo())),
                  // Container(child: Image.network(
                  // ))
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
                      padding: EdgeInsets.fromLTRB(32, 0, 32, 0),
                      child: Text(_organizationInfo.introduction)),
                  const ListTile(
                    title: const Text('Member'),
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(32, 0, 32, 0),
                      child: Text(_organizationInfo.memberNum.toString())),
                ],
              ),
            ));
      },
    );
  }
}

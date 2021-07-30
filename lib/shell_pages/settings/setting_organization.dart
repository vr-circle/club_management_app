import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/shell_pages/search/organization_info.dart';

class SettingOrganization extends StatefulWidget {
  SettingOrganization({
    Key key,
    @required this.selectedOrganizationId,
    @required this.participatingOrganizationInfoList,
    @required this.handleCloseSettingOrganization,
    @required this.leaveOrganization,
  }) : super(key: key);
  final String selectedOrganizationId;
  final List<OrganizationInfo> participatingOrganizationInfoList;
  final void Function() handleCloseSettingOrganization;
  final Future<void> Function(String targetId) leaveOrganization;
  @override
  _SettingOrganizationState createState() => _SettingOrganizationState();
}

class _SettingOrganizationState extends State<SettingOrganization> {
  OrganizationInfo _organizationInfo;

  @override
  void initState() {
    _organizationInfo = widget.participatingOrganizationInfoList
        .where((element) => element.id == widget.selectedOrganizationId)
        .toList()
        .first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                              title: Text('Leave ${_organizationInfo.name}?'),
                              content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      await widget.leaveOrganization(
                                          _organizationInfo.id);
                                      Navigator.pop(context);
                                      widget.handleCloseSettingOrganization();
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
  }
}

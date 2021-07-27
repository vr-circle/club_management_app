import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/shell_pages/search/organization_info.dart';
import 'package:flutter_application_1/store/store_service.dart';

class OrganizationDetailPage extends StatefulWidget {
  OrganizationDetailPage(
      {Key key,
      @required this.organizationId,
      @required this.handleJoinOrganization,
      @required this.handleCloseDetailPage})
      : super(key: key);
  final String organizationId;
  final Future<void> Function(OrganizationInfo targetOrganization)
      handleJoinOrganization;
  final void Function() handleCloseDetailPage;
  @override
  OrganizationDetailPageState createState() => OrganizationDetailPageState();
}

class OrganizationDetailPageState extends State<OrganizationDetailPage> {
  Future<OrganizationInfo> _future;
  OrganizationInfo _organizationInfo;

  Future<OrganizationInfo> getOrganizationInfo() async {
    _organizationInfo =
        await dbService.getOrganizationInfo(widget.organizationId);
    return _organizationInfo;
  }

  @override
  void initState() {
    _future = getOrganizationInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder:
            (BuildContext context, AsyncSnapshot<OrganizationInfo> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: const CircularProgressIndicator(),
            );
          }
          final targetOrganizationInfo = snapshot.data;
          return Scaffold(
              appBar: AppBar(
                title: Text(targetOrganizationInfo.name),
                actions: [
                  TextButton(
                      onPressed: () async {
                        await widget
                            .handleJoinOrganization(targetOrganizationInfo);
                        widget.handleCloseDetailPage();
                      },
                      child: const Text('Join'))
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: 320,
                        width: MediaQuery.of(context).size.width,
                        child: FittedBox(
                            fit: BoxFit.contain, child: FlutterLogo())),
                    // Container(child: Image.network(
                    // ))
                    const ListTile(
                      title: const Text('categories'),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Wrap(
                        children: targetOrganizationInfo.tagList
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
                      title: const Text('introduction'),
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(32, 0, 32, 0),
                        child: Text(targetOrganizationInfo.introduction)),
                    const ListTile(
                      title: const Text('member'),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(32, 0, 32, 0),
                      child: Text(targetOrganizationInfo.memberNum.toString()),
                    )
                  ],
                ),
              ));
        });
  }
}

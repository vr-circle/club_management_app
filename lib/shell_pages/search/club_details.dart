import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/shell_pages/search/organization_info.dart';

class OrganizationDetailPage extends StatelessWidget {
  OrganizationDetailPage({Key key, @required String clubId}) : super(key: key);
  Future<OrganizationInfo> getOrganizationInfo() async {
    await Future.delayed(Duration(seconds: 1));
    return OrganizationInfo(
      id: 0.toString(),
      memberNum: 10,
      name: 'hogehoge',
      categoryList: ['circle'],
      introduction: 'hogehogehogheohgoehoge',
      otherInfo: [],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(builder:
        (BuildContext context, AsyncSnapshot<OrganizationInfo> snapshot) {
      if (snapshot.connectionState != ConnectionState.done) {
        return const Center(
          child: const CircularProgressIndicator(),
        );
      }
      return ListView(
        children: [
          ListTile(
            title: Text(snapshot.data.name),
          ),
        ],
      );
    });
  }
}

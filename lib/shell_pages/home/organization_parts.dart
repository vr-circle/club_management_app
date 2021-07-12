import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_state.dart';
import 'package:flutter_application_1/route_path.dart';
import 'package:flutter_application_1/shell_pages/search/organization_info.dart';

class OrganizationPartsListView extends StatelessWidget {
  OrganizationPartsListView({Key key, @required this.appState})
      : super(key: key);
  final MyAppState appState;
  Future<List<OrganizationInfo>> getOrganizationInfoList() async {
    await Future.delayed(Duration(seconds: 1));
    return [
      OrganizationInfo(
          id: 0.toString(),
          name: 'Hitech',
          memberNum: 10,
          categoryList: ['circle'],
          introduction: 'hogehoge',
          otherInfo: [
            {'hogehoeg': 'hogehoe'}
          ]),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const ListTile(
        title: Text('Organization list'),
      ),
      FutureBuilder(
          future: getOrganizationInfoList(),
          builder: (BuildContext context,
              AsyncSnapshot<List<OrganizationInfo>> snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Expanded(
                child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: min(snapshot.data.length, 5),
                          itemBuilder: (BuildContext context, int index) {
                            return SizedBox(
                                width: 200,
                                child: GestureDetector(
                                  onTap: () {
                                    appState.selectedIndex =
                                        SearchViewPath.index;
                                    appState.selectedSearchingOrganizationId =
                                        snapshot.data[index].id.toString();
                                  },
                                  child: Card(
                                      child: Text(snapshot.data[index].name)),
                                ));
                          }),
                    ),
                  ]),
            ));
          })
    ]);
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/search/club.dart';

class ClubDetailPage extends StatelessWidget {
  ClubDetailPage({Key key, @required String clubId}) : super(key: key);
  Future<ClubInfo> getClubInfo() async {
    await Future.delayed(Duration(seconds: 1));
    return ClubInfo(
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
    return FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot<ClubInfo> snapshot) {
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

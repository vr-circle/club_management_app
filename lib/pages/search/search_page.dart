import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/search/club.dart';

class SearchPage extends StatefulWidget {
  @override
  SearchPageState createState() => SearchPageState();
}

int i = 0;
final dummyClubInfoList = <ClubInfo>[
  ClubInfo(
      id: i++,
      name: 'Hitech',
      details:
          'hogehogeaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
      memberNum: 10),
  ClubInfo(id: i++, name: 'Hitech', details: 'hogehoge', memberNum: 10),
  ClubInfo(id: i++, name: 'Hitech', details: 'hogehoge', memberNum: 10),
  ClubInfo(id: i++, name: 'Hitech', details: 'hogehoge', memberNum: 10),
  ClubInfo(id: i++, name: 'Hitech', details: 'hogehoge', memberNum: 10),
];

class SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: TextField(
            decoration: InputDecoration(
                icon: Icon(Icons.search), labelText: 'Search by name'),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        ListTile(title: Text('Club list')),
        Expanded(
            child: ListView.builder(
          shrinkWrap: true,
          itemCount: dummyClubInfoList.length,
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(
                height: 256,
                child: Container(
                    child: Card(
                        child: Padding(
                            padding: EdgeInsets.all(32),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.shortestSide /
                                          4,
                                  child: FlutterLogo(),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Flexible(
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                      Text(
                                        dummyClubInfoList[index].name,
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Text(dummyClubInfoList[index].details),
                                    ]))
                              ],
                            )))));
          },
        ))
      ],
    ));
  }
}

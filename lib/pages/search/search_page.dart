import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/search/club.dart';

class SearchPage extends StatefulWidget {
  // SearchPage({Key key, MyAppState appstate}) : super(key: key);
  @override
  SearchPageState createState() => SearchPageState();
}

int i = 0;
final dummyClubInfoList = <ClubInfo>[
  ClubInfo(
      id: i++,
      name: 'Hitech',
      introduction: 'hogehog',
      memberNum: 10,
      otherInfo: [
        {'hogehoge': 'fugafuga'}
      ],
      categoryList: [
        '文化',
        'circle'
      ]),
  ClubInfo(
      id: i++,
      name: 'soccer club',
      introduction: 'hogehog',
      memberNum: 10,
      categoryList: ['club', '運動']),
  ClubInfo(
      id: i++,
      name: 'soccer club',
      introduction: 'hogehog',
      memberNum: 10,
      categoryList: ['club', '運動']),
  ClubInfo(
      id: i++,
      name: 'soccer club',
      introduction: 'hogehog',
      memberNum: 10,
      categoryList: ['club', '運動']),
];

class SearchPageState extends State<SearchPage> {
  List<ClubInfo> searchResultList;
  Future<List<ClubInfo>> futureClubList;
  List<ClubInfo> allClubList;
  String text = '';

  Future<List<ClubInfo>> _getClubList() async {
    await Future.delayed(Duration(seconds: 2));
    // get all club data
    allClubList = dummyClubInfoList;
    this.searchResultList = dummyClubInfoList;
    return allClubList;
  }

  @override
  void initState() {
    futureClubList = _getClubList();
    super.initState();
  }

  List<ClubInfo> _search() {
    if (this.text.isEmpty) {
      return allClubList;
    }
    List<String> keywordList = this.text.split(' ');
    List<ClubInfo> res = [];
    allClubList.forEach((ClubInfo element) {
      for (final keyword in keywordList) {
        if (element.categoryList.contains(keyword) ||
            element.name.contains(keyword)) {
          res.add(element);
          break;
        }
      }
    });
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Padding(
            padding: EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                  icon: Icon(Icons.search),
                  labelText: 'Search by name or category'),
              onChanged: (value) {
                // setState(() {
                //   this.text = value;
                //   this.searchResultList = _search();
                // });
              },
              onSubmitted: (value) {
                // Rebuild card list by value.
                setState(() {
                  this.text = value;
                  this.searchResultList = _search();
                });
              },
            )),
        const ListTile(title: Text('Club list')),
        Expanded(
            // searching result list
            child: FutureBuilder(
          future: this.futureClubList,
          builder:
              (BuildContext context, AsyncSnapshot<List<ClubInfo>> snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ClubListView(clubList: this.searchResultList);
          },
        )),
      ],
    ));
  }
}

class ClubListView extends StatelessWidget {
  ClubListView({Key key, this.clubList}) : super(key: key);
  final List<ClubInfo> clubList;
  @override
  Widget build(BuildContext context) {
    return clubList == null || clubList.length == 0
        ? ListTile(
            title: Text('There is no search result'),
          )
        : ListView.builder(
            shrinkWrap: true,
            itemCount: clubList.length,
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
                                    width: MediaQuery.of(context)
                                            .size
                                            .shortestSide /
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
                                          this.clubList[index].name,
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 16,
                                        ),
                                        Text(dummyClubInfoList[index]
                                            .introduction),
                                      ]))
                                ],
                              )))));
            });
  }
}

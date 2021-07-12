import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_state.dart';
import 'package:flutter_application_1/pages/search/club.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key, @required this.appState}) : super(key: key);
  final MyAppState appState;
  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  List<ClubInfo> searchResultList;
  Future<List<ClubInfo>> futureClubList;
  List<ClubInfo> allClubList;
  TextEditingController _controller;

  Future<List<ClubInfo>> _getClubList() async {
    await Future.delayed(Duration(seconds: 1));
    // get all club data
    allClubList = dummyClubInfoList;
    this.searchResultList = dummyClubInfoList;
    return allClubList;
  }

  @override
  void initState() {
    this._controller =
        TextEditingController(text: widget.appState.searchingParams);
    super.initState();
  }

  List<ClubInfo> _search() {
    final String _param = widget.appState.searchingParams;
    if (_param.isEmpty) {
      return allClubList;
    }
    List<String> keywordList = _param.split(' ');
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
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                  icon: Icon(Icons.search),
                  labelText: 'Search by name or category'),
              onSubmitted: (value) {
                widget.appState.searchingParams = value;
                setState(() {
                  this.searchResultList = _search();
                });
              },
            )),
        const ListTile(title: Text('Club list')),
        Expanded(
            // searching result list
            child: FutureBuilder(
          future: this._getClubList(),
          builder:
              (BuildContext context, AsyncSnapshot<List<ClubInfo>> snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: const CircularProgressIndicator(),
              );
            }
            this.searchResultList = this._search();
            return ClubListView(
              clubList: this.searchResultList,
              handleChangeClubId: (String targetId) {
                widget.appState.selectedSearchingClubId = targetId;
              },
            );
          },
        )),
      ],
    ));
  }
}

class ClubListView extends StatelessWidget {
  ClubListView({Key key, this.clubList, this.handleChangeClubId})
      : super(key: key);
  final List<ClubInfo> clubList;
  final void Function(String targetId) handleChangeClubId;
  @override
  Widget build(BuildContext context) {
    return clubList == null || clubList.length == 0
        ? const ListTile(
            title: const Text('There is no search result'),
          )
        : ListView.builder(
            shrinkWrap: true,
            itemCount: clubList.length,
            itemBuilder: (BuildContext context, int index) {
              return SizedBox(
                  height: 256,
                  child: Card(
                      child: InkWell(
                          onTap: () {
                            handleChangeClubId(clubList[index].id.toString());
                          },
                          child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context)
                                            .size
                                            .shortestSide /
                                        4,
                                    child: const FlutterLogo(),
                                  ),
                                  const SizedBox(
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
                                        const SizedBox(
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

int i = 0;
final dummyClubInfoList = <ClubInfo>[
  ClubInfo(
      id: (i++).toString(),
      name: 'Hitech',
      introduction: 'hogehog',
      memberNum: 10,
      otherInfo: [
        {'hogehoge': 'fugafuga'}
      ],
      categoryList: [
        'cultual',
        'circle'
      ]),
  ClubInfo(
      id: (i++).toString(),
      name: 'soccer club',
      introduction: 'hogehog',
      memberNum: 10,
      categoryList: ['club', '運動']),
  ClubInfo(
      id: (i++).toString(),
      name: 'soccer club',
      introduction: 'hogehog',
      memberNum: 10,
      categoryList: ['club', '運動']),
  ClubInfo(
      id: (i++).toString(),
      name: 'soccer club',
      introduction: 'hogehog',
      memberNum: 10,
      categoryList: ['club', '運動']),
];

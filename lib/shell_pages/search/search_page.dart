import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_state.dart';
import 'package:flutter_application_1/shell_pages/search/organization_info.dart';
import 'package:flutter_application_1/store/store_service.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key, @required this.appState}) : super(key: key);
  final AppState appState;
  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  List<OrganizationInfo> searchResultList;
  Future<List<OrganizationInfo>> futureOrganizationList;
  List<OrganizationInfo> allOrganizationList;
  TextEditingController _controller;

  Future<List<OrganizationInfo>> _getOrganizationList() async {
    // get all club data
    allOrganizationList = await dbService.getOrganizationList();
    this.searchResultList = allOrganizationList;
    return allOrganizationList;
  }

  @override
  void initState() {
    this._controller =
        TextEditingController(text: widget.appState.searchingParam);
    super.initState();
  }

  List<OrganizationInfo> _search() {
    final String _param = widget.appState.searchingParam;
    if (_param.isEmpty) {
      return allOrganizationList;
    }
    List<String> keywordList = _param.split(' ');
    List<OrganizationInfo> res = [];
    allOrganizationList.forEach((OrganizationInfo element) {
      for (final keyword in keywordList) {
        if (element.tagList.contains(keyword) ||
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
        appBar: AppBar(
          title: Row(
            children: [
              const FlutterLogo(),
              const Text('CMA'),
            ],
          ),
        ),
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
                    widget.appState.searchingParam = value;
                    setState(() {
                      this.searchResultList = _search();
                    });
                  },
                )),
            const ListTile(title: Text('Organization list')),
            Expanded(
                // searching result list
                child: FutureBuilder(
              future: this._getOrganizationList(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<OrganizationInfo>> snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(
                    child: const CircularProgressIndicator(),
                  );
                }
                this.searchResultList = this._search();
                return OrganizationListView(
                  clubList: this.searchResultList,
                  handleChangeOrganizationId: (String targetId) {
                    widget.appState.targetOrganizationId = targetId;
                  },
                );
              },
            )),
          ],
        ));
  }
}

class OrganizationListView extends StatelessWidget {
  OrganizationListView(
      {Key key, this.clubList, this.handleChangeOrganizationId})
      : super(key: key);
  final List<OrganizationInfo> clubList;
  final void Function(String targetId) handleChangeOrganizationId;
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
                            handleChangeOrganizationId(
                                clubList[index].id.toString());
                          },
                          child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // SizedBox(
                                  //   width: MediaQuery.of(context)
                                  //           .size
                                  //           .shortestSide /
                                  //       4,
                                  //   child: const FlutterLogo(),
                                  // ),
                                  // const SizedBox(
                                  //   width: 12,
                                  // ),
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
                                        Text(
                                          this.clubList[index].introduction,
                                        ),
                                      ]))
                                ],
                              )))));
            });
  }
}

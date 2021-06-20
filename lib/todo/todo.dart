import 'package:flutter/material.dart';

import 'todo_tab_page.dart';

class TodoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BuildDefaultTabController();
  }
}

class BuildDefaultTabController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _tabInfo = <String>[
      'private',
      'circle',
    ]; // todo: get list from store
    return DefaultTabController(
        length: _tabInfo.length,
        child: Scaffold(
            appBar: AppBar(
              flexibleSpace: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TabBar(
                      isScrollable: true,
                      tabs: _tabInfo
                          .map((e) => Tab(
                                text: e,
                              ))
                          .toList())
                ],
              ),
              // elevation: 0,
            ),
            body: TabBarView(
                children: _tabInfo
                    .map((e) => TodoTabPage(
                          target: e,
                        ))
                    .toList())));
  }
}

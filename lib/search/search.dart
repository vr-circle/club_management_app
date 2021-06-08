import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SearchPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new RefreshIndicator(
      onRefresh: () {
        return;
      },
      child: GridView.count(
        crossAxisCount: MediaQuery.of(context).size.shortestSide < 600 ? 2 : 4,
        children: List.generate(28, (index) {
          return Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                FlutterLogo(),
                Container(child: Text('Circle name'))
              ]));
        }),
      ),
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends StatelessWidget {
  static const String route = '/homepage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Column(
            children: [
              Consumer(
                builder: (context, watch, child) {
                  return ListTile(
                    title: Text('all events'),
                    onTap: () {},
                  );
                },
              ),
              Card(
                child: Text("hogehoge"),
              ),
            ],
          ),
          Column(
            children: [
              const ListTile(
                title: Text('Club to which you belong'),
              ),
              Card(
                child: Text('event sample'),
              ),
            ],
          )
        ],
      ),
    );
  }
}

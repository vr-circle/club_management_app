import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final isOpenProvider =
    StateNotifierProvider<StateIsOpen, bool>((ref) => StateIsOpen());

class StateIsOpen extends StateNotifier<bool> {
  StateIsOpen() : super(false);

  void toggleIsOpen() {
    this.state = !this.state;
  }
}

class HomePage extends HookWidget {
  static const String route = '/homepage';
  @override
  Widget build(BuildContext context) {
    final _isOpen = useProvider(isOpenProvider);
    return Scaffold(
      body: Column(
        children: [
          Column(
            children: [
              Consumer(
                builder: (context, watch, child) {
                  return ListTile(
                    title: Text("全体のイベント"),
                    onTap: () {
                      watch(isOpenProvider.notifier).toggleIsOpen();
                    },
                  );
                },
              ),
              Visibility(
                visible: _isOpen,
                child: Card(
                  child: Text("hogehoge"),
                ),
              ),
            ],
          ),
          Column(
            children: [
              const ListTile(
                title: Text("所属サークルのイベント"),
              ),
              Card(
                child: Text("aaaaaaaaaaaaaaaaaaa"),
              ),
              Card(
                child: Text("hogehoge"),
              ),
            ],
          )
        ],
      ),
    );
  }
}

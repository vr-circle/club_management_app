import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/schedule/schedule.dart';
import 'package:flutter_application_1/todo/task.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:convert';

import 'todo/task_list.dart';

// todo: isPrivate -> targetClub or something

StoreService storeService;

class StoreService {
  StoreService({this.userId});
  String userId;
  Map<String, dynamic> privateJsonData;
  Map<String, dynamic> clubJsonData;
  List<String> taskTitleList;
  Future<void> getUserData() async {
    this.privateJsonData =
        (await FirebaseFirestore.instance.collection('users').doc(userId).get())
            .data();
    this.clubJsonData = (await FirebaseFirestore.instance
            .collection('users')
            .doc('circle')
            .get())
        .data();
  }

  Future<List<Task>> getClubTaskList() async {
    final clubTaskList = (await FirebaseFirestore.instance
            .collection('users')
            .doc('circle')
            .get())
        .data()['todo'];
    List<String> castedClubTaskList = clubTaskList.cast<String>();
    var result = castedClubTaskList.map((e) => Task(title: e)).toList();
    return result;
  }

  Future<List<Task>> getPrivateTaskList() async {
    final clubTaskList =
        (await FirebaseFirestore.instance.collection('users').doc(userId).get())
            .data()['todo'];
    List<String> castedPrivateTaskList = clubTaskList.cast<String>();
    var result = castedPrivateTaskList.map((e) => Task(title: e)).toList();
    return result;
  }

  Future<void> addTask(Task task, bool isPrivate) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(isPrivate ? userId : 'circle')
        .update({
      'todo': FieldValue.arrayUnion([task.title])
    });
  }

  Future<void> deleteTask(Task task, bool isPrivate) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(isPrivate ? userId : 'circle')
        .update({
      'todo': FieldValue.arrayRemove([task.title])
    });
  }

  Future<Map<String, List<Schedule>>> getPrivateSchedule() async {
    print('get private schedules');
    final _scheduleList =
        (await FirebaseFirestore.instance.collection('users').doc(userId).get())
            .data()['schedule'];
    print(_scheduleList.runtimeType);
    print(_scheduleList);
    // return _scheduleList;
    return <String, List<Schedule>>{
      '2021/06/14': <Schedule>[
        Schedule(
            title: 'tttttt',
            place: 'pppppp',
            start: DateTime.now(),
            end: DateTime.now()),
        Schedule(
            title: '2tttttt',
            place: 'pppppp',
            start: DateTime.now(),
            end: DateTime.now()),
        Schedule(
            title: '3tttttt',
            place: 'pppppp',
            start: DateTime.now(),
            end: DateTime.now()),
      ]
    };
  }

  Map<String, List<Schedule>> getClubSchedule() {
    final _scheduleList = clubJsonData['schedule'];
    print(_scheduleList);
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/schedule/schedule.dart';
import 'package:flutter_application_1/todo/task.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
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

  Future<Map<DateTime, List<Schedule>>> getPrivateSchedule() async {
    final _scheduleList = (await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('schedule')
            .doc('schedule')
            .get())
        .data();

    final _format = DateFormat("yyyyMMdd");
    Map<DateTime, List<Schedule>> res = {};
    _scheduleList.forEach((key, value) {
      res[_format.parseStrict(key)] = <Schedule>[
        Schedule(
            title: value['title'],
            place: value['place'],
            details: value['details'],
            start: value['start'].toDate(),
            end: value['end'].toDate()),
      ];
    });
    return res;
  }

  Future<void> addSchedule(Schedule schedule, bool isPrivate) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(isPrivate ? userId : 'circle')
        .collection('schedule')
        .doc('schedule')
        .set({
      DateFormat('yyyyMMdd').format(schedule.start): [
        {
          'title': schedule.title,
        },
        {
          'place': schedule.place,
        },
        {
          'start': Timestamp.fromDate(schedule.start),
        },
        {'end': Timestamp.fromDate(schedule.end)},
        {'details': schedule.details},
      ]
    }, SetOptions(merge: true));
  }
}

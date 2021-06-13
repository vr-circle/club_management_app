import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/schedule/schedule.dart';
import 'package:flutter_application_1/todo/task.dart';
import 'dart:convert';

StoreService storeService;

class StoreService {
  StoreService({this.userId}) {
    this.getUserData();
    print(privateJsonData);
  }
  String userId;
  Map<String, dynamic> privateJsonData;
  Map<String, dynamic> clubJsonData;
  List<String> taskTitleList;
  Future<void> getUserData() async {
    print('getUserData');
    print(
        (await FirebaseFirestore.instance.collection('users').doc(userId).get())
            .data());
    this.privateJsonData =
        (await FirebaseFirestore.instance.collection('users').doc(userId).get())
            .data();
    this.clubJsonData = (await FirebaseFirestore.instance
            .collection('users')
            .doc('circle')
            .get())
        .data();
  }

  List<Task> getClubTaskList() {
    final _taskTitle = clubJsonData['todo'];
    List<String> res = _taskTitle.cast<String>();
    var ans = res.map((e) => Task(title: e)).toList();
    return ans;
  }

  List<Task> getPrivateTaskList() {
    var _taskTitle = privateJsonData['todo'];
    List<String> res = _taskTitle.cast<String>();
    var ans = res.map((e) => Task(title: e)).toList();
    return ans;
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

  Map<String, List<Schedule>> getPrivateSchedule() {
    final _scheduleList = privateJsonData['schedule'];
    print(_scheduleList);
  }

  Map<String, List<Schedule>> getClubSchedule() {
    final _scheduleList = clubJsonData['schedule'];
    print(_scheduleList);
  }
}

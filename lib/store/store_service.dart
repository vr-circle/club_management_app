import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/schedule/schedule.dart';
import 'package:flutter_application_1/todo/task.dart';
import 'package:intl/intl.dart';

StoreService storeService;

class Club {
  String id;
  String name;
  List<String> members;
}

class StoreService {
  StoreService({this.userId});
  final _store = FirebaseFirestore.instance;
  String userId;
  Map<String, dynamic> privateJsonData;
  Map<String, dynamic> clubJsonData;
  List<String> taskTitleList;

  Future<String> getClubName(String targetID) async {
    final data = await this._store.collection('clubs').doc(targetID).get();
    return data.data()['name'];
  }

  Future<List<String>> getBelongingClubIDs() async {
    final clubIds = (await FirebaseFirestore.instance
        .collection('clubs')
        .where('members', arrayContains: this.userId)
        .get()) as List<String>;
    print(clubIds);
    return clubIds;
  }

  Future<String> getUserTheme() async {
    final data = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('settings')
        .doc('settings')
        .get();
    print(data['theme']);
    return data['theme'];
  }

  Future<void> setUserTheme(String theme) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('settings')
        .doc('settings')
        .update({'theme': theme});
  }

  Future<Map<String, List<Task>>> getTaskMap() async {
    Map<String, List<Task>> taskMap = new Map<String, List<Task>>();
    final privateTaskList =
        (await this._store.collection('users').doc(userId).get())
            .data()['todo']
            .cast<String>();
    taskMap['private'] = privateTaskList.map((e) => Task(title: e)).toList();

    final clubIds = await this
        ._store
        .collection('clubs')
        .where('members', arrayContains: this.userId)
        .get();
    print(clubIds);
    return taskMap;
  }

  Future<void> addTask(Task task, String targetGroup) async {
    if (targetGroup == 'private') {
      await _store.collection('users').doc(userId).update({
        'todo': FieldValue.arrayUnion([task.title])
      });
      return;
    }
    await _store.collection('clubs').doc(targetGroup).update({
      'todo': FieldValue.arrayUnion([task.title])
    });
  }

  Future<void> deleteTask(Task task, String target) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(target == 'private' ? userId : 'circle')
        .update({
      'todo': FieldValue.arrayRemove([task.title])
    });
  }

  Future<Map<DateTime, List<Schedule>>> getSchedule(
      List<String> targets) async {
    final _format = DateFormat("yyyy-MM-dd");
    // private
    final _scheduleList = (await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('schedule')
            .doc('schedule')
            .get())
        .data();
    Map<DateTime, List<Schedule>> res = {};
    _scheduleList.forEach((key, value) {
      DateTime targetDateString;
      try {
        targetDateString = _format.parseStrict(key);
        // Why couldn't use map() in 'value'.
        List<Schedule> ttmp = [];
        value.forEach((e) {
          ttmp.add(Schedule(
              title: e['title'],
              place: e['place'],
              details: e['details'],
              start: DateFormat('yyyy-MM-dd HH:mm').parseStrict(e['start']),
              end: DateFormat('yyyy-MM-dd HH:mm').parseStrict(e['end']),
              createdBy: 'private'));
        });
        Map<DateTime, List<Schedule>> tmp = {targetDateString: ttmp};
        res.addAll(tmp);
      } catch (e) {
        print(e);
      }
    });
    targets.forEach((target) async {
      final _clubScheduleList = (await FirebaseFirestore.instance
              .collection('users')
              .doc(target)
              .collection('schedule')
              .doc('schedule')
              .get())
          .data();
      Map<DateTime, List<Schedule>> clubRes = {};
      _clubScheduleList.forEach((key, value) {
        var targetDateString;
        try {
          targetDateString = _format.parseStrict(key);
          List<Schedule> ttmp = [];
          value.forEach((e) {
            ttmp.add(Schedule(
                title: e['title'],
                place: e['place'],
                details: e['details'],
                start: DateFormat('yyyy-MM-dd HH:mm').parseStrict(e['start']),
                end: DateFormat('yyyy-MM-dd HH:mm').parseStrict(e['end']),
                createdBy: target));
          });
          Map<DateTime, List<Schedule>> tmp = {targetDateString: ttmp};
          clubRes.addAll(tmp);
        } catch (e) {
          print(e);
        }
      });
      res.addAll(clubRes);
    });
    return res;
  }

  Future<void> addClubSchedule(
      Schedule schedule, String targetClubId, bool isPublic) async {
    await FirebaseFirestore.instance
        .collection('clubs')
        .doc(targetClubId)
        .collection('schedule')
        .doc(isPublic ? 'public' : 'private')
        .set({
      DateFormat('yyyy-MM-dd').format(schedule.start): FieldValue.arrayUnion([
        {
          'title': schedule.title,
          'place': schedule.place,
          'start': DateFormat('yyyy-MM-dd HH:mm').format(schedule.start),
          'end': DateFormat('yyyy-MM-dd HH:mm').format(schedule.end),
          'details': schedule.details,
        }
      ])
    }, SetOptions(merge: true));
  }

  Future<void> deleteClubSchedule(
      Schedule schedule, String targetClubId, bool isPublic) async {
    await FirebaseFirestore.instance
        .collection('clubs')
        .doc(targetClubId)
        .collection('schedule')
        .doc(isPublic ? 'public' : 'private')
        .update({
      DateFormat('yyyy-MM-dd').format(schedule.start): FieldValue.arrayRemove([
        {
          'details': schedule.details,
          'end': DateFormat('yyyy-MM-dd HH:mm').format(schedule.end),
          'place': schedule.place,
          'start': DateFormat('yyyy-MM-dd HH:mm').format(schedule.start),
          'title': schedule.title,
        }
      ])
    });
  }

  Future<void> addSchedule(Schedule schedule, String target) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(target == 'private' ? userId : target)
        .collection('schedule')
        .doc('schedule')
        .set({
      DateFormat('yyyy-MM-dd').format(schedule.start): FieldValue.arrayUnion([
        {
          'title': schedule.title,
          'place': schedule.place,
          'start': DateFormat('yyyy-MM-dd HH:mm').format(schedule.start),
          'end': DateFormat('yyyy-MM-dd HH:mm').format(schedule.end),
          'details': schedule.details,
        }
      ])
    }, SetOptions(merge: true));
  }

  Future<void> deleteSchedule(Schedule schedule) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(schedule.createdBy == 'private' ? userId : schedule.createdBy)
        .collection('schedule')
        .doc('schedule')
        .update({
      DateFormat('yyyy-MM-dd').format(schedule.start): FieldValue.arrayRemove([
        {
          'details': schedule.details,
          'end': DateFormat('yyyy-MM-dd HH:mm').format(schedule.end),
          'place': schedule.place,
          'start': DateFormat('yyyy-MM-dd HH:mm').format(schedule.start),
          'title': schedule.title,
        }
      ])
    });
  }
}

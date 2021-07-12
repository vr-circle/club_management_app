import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/pages/schedule/schedule.dart';
import 'package:flutter_application_1/pages/search/club.dart';
import 'package:flutter_application_1/pages/todo/task.dart';

DatabaseService dbService;

enum Permission {
  admin,
  none,
}

abstract class PermissionManager {
  Future<bool> getPermission();
}

abstract class DatabaseService {
  // club
  Future<List<ClubInfo>> getClubList();
  Future<List<String>> getParticipatingClubIdList();
  Future<ClubInfo> getClubInfo(String id);
  Future<void> createClub(ClubInfo newClub);
  Future<void> joinClub(ClubInfo targetClub);
  Future<void> leaveClub(ClubInfo targetClub);

  // schedule
  Future<Map<DateTime, List<Schedule>>> getSchedules(List<String> targetId);
  Future<List<Schedule>> getSchedulesOnDay(
      DateTime day, List<String> targetIdList);
  Future<Schedule> getSchedule(String id);
  Future<void> setSchedule(Schedule newSchedule, String targetId);
  Future<void> deleteSchedule(Schedule schedule, String targetId);

  // todo
  Future<Map<String, List<Task>>> getTaskList(String id);
  Future<void> setList(String listName, String targetGroupId);
  Future<void> deleteList(String listName, String targetGroupId);
  Future<void> setTask(Task task, String targetId);
  Future<void> deleteTask(Task task, String targetId);

  // settings
  Future<void> setUserTheme();
}

Future<void> dummyDelay() async {
  await Future.delayed(Duration(seconds: 1));
}

class FireStoreService extends DatabaseService {
  FireStoreService({this.userId});
  final _store = FirebaseFirestore.instance;
  final String userId;
  // --------------------------- club ------------------------------------------
  @override
  Future<List<String>> getParticipatingClubIdList() async {
    print('getParticipatingClubIdList');
    await dummyDelay();
    // _store.collection('clubs').where();
    return ['0', '1'];
  }

  @override
  Future<ClubInfo> getClubInfo(String id) async {
    await dummyDelay();
    return (await getClubList())
        .where((element) => element.id == id)
        .toList()
        .first;
  }

  @override
  Future<List<ClubInfo>> getClubList() async {
    await dummyDelay();
    return dummyClubInfoList;
  }

  @override
  Future<void> createClub(ClubInfo newClub) async {
    await dummyDelay();
    print('create club ${newClub.name}');
  }

  @override
  Future<void> joinClub(ClubInfo targetClub) async {
    await dummyDelay();
    // _store.collection('').doc().set();
    print('join club ${targetClub.name}');
  }

  @override
  Future<void> leaveClub(ClubInfo targetClub) async {
    print('leaveClub');
    await dummyDelay();
    // _store.collection('users').doc(userId).set({'clubs' : });
  }

  // --------------------------- schedule --------------------------------------
  @override
  Future<Map<DateTime, List<Schedule>>> getSchedules(
      List<String> targetId) async {
    print('getSchedules');
    await dummyDelay();
    // final data = await (_store.collection().doc().get()).data();
    return dummySchedules;
  }

  @override
  Future<List<Schedule>> getSchedulesOnDay(
      DateTime day, List<String> targetIdList) async {
    print('getScheduleOnDay');
    await dummyDelay();
    // final data = await _store.collection().doc().set()
    return dummyScheduleListOnDay;
  }

  @override
  Future<Schedule> getSchedule(String id) async {
    print('getSchedule');
    await dummyDelay();
    // _store.collection(collectionPath)
    return dummyScheduleListOnDay[0];
  }

  @override
  Future<void> setSchedule(Schedule newSchedule, String targetId) async {
    print('setSchedule');
    await dummyDelay();
    // _store.collection(targetId.isEmpty ? userId : targetId).doc().set();
  }

  @override
  Future<void> deleteSchedule(Schedule schedule, String targetId) async {
    print('deleteSchedule');
    await dummyDelay();
    // _store.collection(targetId.isEmpty ? userId : targetId).doc().set();
  }

  // --------------------------- todo ------------------------------------------
  @override
  Future<Map<String, List<Task>>> getTaskList(String id) async {
    print('getTaskList');
    await dummyDelay();
    // get task map form id
    if (id == 'private') {
      // private
    }
    // _store.collection().doc().get()
    return dummyTaskList;
  }

  @override
  Future<void> setList(String listName, String targetGroupId) async {
    print('setList');
    await dummyDelay();
    // _store.collection(targetGroupId.isEmpty ? userId : targetGroupId).doc('group').set({});
  }

  @override
  Future<void> deleteList(String listName, String targetGroupId) async {
    print('deleteList');
    await dummyDelay();
    // _store.collection(targetGroupId.isEmpty ? userId : targetGroupId).doc('group').set({});
  }

  @override
  Future<void> setTask(Task task, String targetId) async {
    print('setTask');
    await dummyDelay();
    // _store.collection(targetId.isEmpty ? userId : targetId).doc().set();
  }

  @override
  Future<void> deleteTask(Task task, String targetId) async {
    print('deleteTask');
    await dummyDelay();
    // _store.collection(targetId.isEmpty ? userId : targetId).doc().set();
  }

  // --------------------------- settings --------------------------------------

  @override
  Future<void> setUserTheme() async {
    print('setUserTheme');
    await dummyDelay();
  }
}

int _i = 0;
final dummyClubInfoList = <ClubInfo>[
  ClubInfo(
      id: (_i++).toString(),
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
      id: (_i++).toString(),
      name: 'soccer club',
      introduction: 'hogehog',
      memberNum: 10,
      categoryList: ['club', '運動']),
  ClubInfo(
      id: (_i++).toString(),
      name: 'soccer club',
      introduction: 'hogehog',
      memberNum: 10,
      categoryList: ['club', '運動']),
  ClubInfo(
      id: (_i++).toString(),
      name: 'soccer club',
      introduction: 'hogehog',
      memberNum: 10,
      categoryList: ['club', '運動']),
];

final dummyScheduleListOnDay = [
  Schedule(
      title: 'title',
      start: DateTime.now(),
      end: DateTime.now(),
      details: 'details',
      place: 'place01',
      createdBy: 'hogehoge'),
  Schedule(
      title: 'title',
      start: DateTime.now(),
      end: DateTime.now(),
      details: 'details',
      place: 'place01',
      createdBy: 'hogehoge'),
  Schedule(
      title: 'title',
      start: DateTime.now(),
      end: DateTime.now(),
      details: 'details',
      place: 'place01',
      createdBy: 'hogehoge'),
  Schedule(
      title: 'title',
      start: DateTime.now(),
      end: DateTime.now(),
      details: 'details',
      place: 'place01',
      createdBy: 'hogehoge'),
];

final dummySchedules = {
  DateTime.now(): [
    Schedule(
        title: 'title',
        start: DateTime.now(),
        end: DateTime.now(),
        details: 'details',
        place: 'place01',
        createdBy: 'hogehoge'),
    Schedule(
        title: 'title',
        start: DateTime.now(),
        end: DateTime.now(),
        details: 'details',
        place: 'place01',
        createdBy: 'hogehoge'),
    Schedule(
        title: 'title',
        start: DateTime.now(),
        end: DateTime.now(),
        details: 'details',
        place: 'place01',
        createdBy: 'hogehoge'),
    Schedule(
        title: 'title',
        start: DateTime.now(),
        end: DateTime.now(),
        details: 'details',
        place: 'place01',
        createdBy: 'hogehoge'),
  ],
  DateTime.now().add(Duration(days: 7)): [
    Schedule(
        title: 'title',
        start: DateTime.now(),
        end: DateTime.now(),
        details: 'details',
        place: 'place01',
        createdBy: 'hogehoge'),
    Schedule(
        title: 'title',
        start: DateTime.now(),
        end: DateTime.now(),
        details: 'details',
        place: 'place01',
        createdBy: 'hogehoge'),
    Schedule(
        title: 'title',
        start: DateTime.now(),
        end: DateTime.now(),
        details: 'details',
        place: 'place01',
        createdBy: 'hogehoge'),
    Schedule(
        title: 'title',
        start: DateTime.now(),
        end: DateTime.now(),
        details: 'details',
        place: 'place01',
        createdBy: 'hogehoge'),
  ],
  DateTime.now().add(Duration(days: 3)): [
    Schedule(
        title: 'title',
        start: DateTime.now(),
        end: DateTime.now(),
        details: 'details',
        place: 'place01',
        createdBy: 'hogehoge'),
    Schedule(
        title: 'title',
        start: DateTime.now(),
        end: DateTime.now(),
        details: 'details',
        place: 'place01',
        createdBy: 'hogehoge'),
    Schedule(
        title: 'title',
        start: DateTime.now(),
        end: DateTime.now(),
        details: 'details',
        place: 'place01',
        createdBy: 'hogehoge'),
    Schedule(
        title: 'title',
        start: DateTime.now(),
        end: DateTime.now(),
        details: 'details',
        place: 'place01',
        createdBy: 'hogehoge'),
  ],
};

final dummyTaskList = {
  'name0': [
    Task(title: 'tmp'),
    Task(title: 'tmp'),
    Task(title: 'tmp'),
    Task(title: 'tmp'),
    Task(title: 'tmp'),
  ],
  'name1': [
    Task(title: 'tmp'),
    Task(title: 'tmp'),
    Task(title: 'tmp'),
    Task(title: 'tmp'),
  ],
  'name2': [
    Task(title: 'tmp'),
    Task(title: 'tmp'),
    Task(title: 'tmp'),
  ],
  'name3': [
    Task(title: 'tmp'),
    Task(title: 'tmp'),
  ],
  'name4': [
    Task(title: 'tmp'),
  ]
};

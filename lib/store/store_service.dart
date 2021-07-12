import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/shell_pages/schedule/schedule.dart';
import 'package:flutter_application_1/shell_pages/search/organization_info.dart';
import 'package:flutter_application_1/shell_pages/todo/task.dart';
import 'package:flutter_application_1/store/database_service.dart';
import 'package:intl/intl.dart';

DatabaseService dbService;

class FireStoreService extends DatabaseService {
  FireStoreService({this.userId});
  final String userId;
  final _store = FirebaseFirestore.instance;
  final organizationCollectionName = 'organizations';
  final usersCollectionName = 'users';
  final todoCollectionName = 'todo';
  final scheduleCollectionName = 'schedule';
  final settingsCollectionName = 'settings';
  final settingsOrganizationName = 'organizations';
  final taskGroupDocName = 'group';

  // --------------------------- club ------------------------------------------
  @override
  Future<List<String>> getParticipatingOrganizationIdList() async {
    print('getParticipatingOrganizationIdList');
    final data = await _store
        .collection(usersCollectionName)
        .doc(userId)
        .collection(settingsCollectionName)
        .doc(settingsOrganizationName)
        .get() as Map<String, dynamic>;
    final res = [];
    data.forEach((key, value) {
      res.add(key);
    });
    return res;
  }

  @override
  Future<OrganizationInfo> getOrganizationInfo(String id) async {
    print('getOrganizationInfo');
    final list = await _store
        .collection(organizationCollectionName)
        .doc(id)
        .get() as Map<String, dynamic>;
    final res = OrganizationInfo(
        id: id,
        name: list['name'],
        memberNum: list['memberNum'],
        introduction: list['introduction'],
        categoryList: list['categoryList'],
        otherInfo: list['others']);
    return res;
  }

  @override
  Future<List<OrganizationInfo>> getOrganizationList() async {
    print('getOrganizationList');
    final data = await _store.collection(organizationCollectionName).get()
        as Map<String, dynamic>;
    final res = data.entries
        .map((e) => OrganizationInfo(
            id: e.key,
            name: e.value['name'],
            introduction: e.value['introduction'],
            categoryList: e.value['categoryList'],
            memberNum: e.value['memberNum'],
            otherInfo: e.value['otherInfo']))
        .toList();
    return res;
  }

  @override
  Future<void> createOrganization(OrganizationInfo newOrganization) async {
    print('create club ${newOrganization.name}');
    await _store.collection(organizationCollectionName).doc().set({
      'name': newOrganization.name,
      'introduction': newOrganization.introduction,
      'categoryList': newOrganization.categoryList,
      'otherInfo': newOrganization.otherInfo,
      'memberNum': newOrganization.memberNum
    });
  }

  @override
  Future<void> joinOrganization(OrganizationInfo targetOrganization) async {
    print('join club ${targetOrganization.name}');
    await _store
        .collection(usersCollectionName)
        .doc(userId)
        .collection(settingsCollectionName)
        .doc(settingsOrganizationName)
        .set({
      'ids': FieldValue.arrayUnion([targetOrganization.id])
    });
  }

  @override
  Future<void> leaveOrganization(OrganizationInfo targetOrganization) async {
    print('leaveOrganization');
    await _store
        .collection(usersCollectionName)
        .doc(userId)
        .collection(settingsCollectionName)
        .doc(settingsOrganizationName)
        .set({
      'ids': FieldValue.arrayRemove([targetOrganization.id])
    });
  }

  // --------------------------- schedule --------------------------------------
  @override
  Future<Map<DateTime, List<Schedule>>> getSchedules(String targetId) async {
    print('getSchedules');
    Map<DateTime, List<Schedule>> res = {};
    if (targetId.isEmpty) {
      final data = await _store
          .collection(usersCollectionName)
          .doc(userId)
          .collection(scheduleCollectionName)
          .doc()
          .get() as Map<String, List<dynamic>>;
      data.forEach((key, value) {
        try {
          final DateTime tmpDate = DateFormat('yyyy-MM-dd').parseStrict(key);
          final tmpList = <Schedule>[];
          value.forEach((e) {
            tmpList.add(Schedule(
              title: e['title'],
              place: e['place'],
              details: e['details'],
              start: DateFormat('yyyy-MM-dd HH:mm').parseStrict(e['start']),
              end: DateFormat('yyyy-MM-dd HH:mm').parseStrict(e['end']),
            ));
          });
          res.addAll({tmpDate: tmpList});
        } catch (e) {
          print(e);
        }
      });
      return res;
    }
    final data = await _store
        .collection(organizationCollectionName)
        .doc(targetId)
        .collection(scheduleCollectionName)
        .doc()
        .get() as Map<String, List<dynamic>>;
    data.forEach((key, value) {
      try {
        final DateTime tmpDate = DateFormat('yyyy-MM-dd').parseStrict(key);
        final tmpList = <Schedule>[];
        value.forEach((e) {
          tmpList.add(Schedule(
            title: e['title'],
            place: e['place'],
            details: e['details'],
            start: DateFormat('yyyy-MM-dd HH:mm').parseStrict(e['start']),
            end: DateFormat('yyyy-MM-dd HH:mm').parseStrict(e['end']),
          ));
        });
        res.addAll({tmpDate: tmpList});
      } catch (e) {
        print(e);
      }
    });

    return res;
  }

  @override
  Future<List<Schedule>> getSchedulesOnDay(
      DateTime day, List<String> targetIdList) async {
    print('getScheduleOnDay');
    await dummyDelay();
    return dummyScheduleListOnDay;
  }

  @override
  Future<void> addSchedule(
      Schedule newSchedule, String targetOrganizationId) async {
    print('addSchedule');
    final key = DateFormat('yyyy-MM-dd').format(newSchedule.start);
    final _start = DateFormat('yyyy-MM-dd HH:mm').format(newSchedule.start);
    final _end = DateFormat('yyyy-MM-dd HH:mm').format(newSchedule.end);
    if (targetOrganizationId.isEmpty) {
      await _store
          .collection(usersCollectionName)
          .doc(userId)
          .collection(scheduleCollectionName)
          .doc()
          .set({
        key: FieldValue.arrayUnion([
          {
            'title': newSchedule.title,
            'start': _start,
            'end': _end,
            'place': newSchedule.place,
            'details': newSchedule.details
          }
        ])
      });
      return;
    }
    await _store
        .collection(organizationCollectionName)
        .doc(targetOrganizationId)
        .collection(scheduleCollectionName)
        .doc() // private or public
        .set({
      key: FieldValue.arrayUnion([
        {
          'title': newSchedule.title,
          'start': _start,
          'end': _end,
          'place': newSchedule.place,
          'details': newSchedule.details
        }
      ])
    });
  }

  @override
  Future<void> deleteSchedule(
      Schedule targetSchedule, String targetOrganizationId) async {
    print('deleteSchedule');
    final key = DateFormat('yyyy-MM-dd').format(targetSchedule.start);
    final _start = DateFormat('yyyy-MM-dd HH:mm').format(targetSchedule.start);
    final _end = DateFormat('yyyy-MM-dd HH:mm').format(targetSchedule.end);
    if (targetOrganizationId.isEmpty) {
      await _store
          .collection(usersCollectionName)
          .doc(userId)
          .collection(scheduleCollectionName)
          .doc()
          .set({
        key: FieldValue.arrayRemove([
          {
            'title': targetSchedule.title,
            'start': _start,
            'end': _end,
            'place': targetSchedule.place,
            'details': targetSchedule.details
          }
        ])
      });
      return;
    }
    await _store
        .collection(organizationCollectionName)
        .doc(targetOrganizationId)
        .collection(scheduleCollectionName)
        .doc() // private or public
        .set({
      key: FieldValue.arrayRemove([
        {
          'title': targetSchedule.title,
          'start': _start,
          'end': _end,
          'place': targetSchedule.place,
          'details': targetSchedule.details
        }
      ])
    });
  }

  // --------------------------- todo ------------------------------------------
  @override
  Future<Map<String, List<Task>>> getTaskList(String id) async {
    print('getTaskList');
    Map<String, List<Task>> res = {};
    if (id.isEmpty) {
      // private
      final _data = await _store
          .collection(usersCollectionName)
          .doc(userId)
          .collection(todoCollectionName)
          .doc(taskGroupDocName)
          .get() as Map<String, List<String>>;
      _data.forEach((key, value) {
        res.addAll({key: value.map((e) => Task(title: e))});
      });
      return res;
    }
    final _data = await _store
        .collection(organizationCollectionName)
        .doc(id)
        .collection(todoCollectionName)
        .doc(taskGroupDocName)
        .get() as Map<String, List<String>>;
    _data.forEach((key, value) {
      res.addAll({key: value.map((e) => Task(title: e))});
    });
    return res;
  }

  @override
  Future<void> addTaskGroup(
      String listName, String targetOrganizationId) async {
    print('addTaskGroup');
    if (targetOrganizationId.isEmpty) {
      await _store
          .collection(usersCollectionName)
          .doc(userId)
          .collection(todoCollectionName)
          .doc(taskGroupDocName)
          .set({
        listName: ['']
      });
      return;
    }
    await _store
        .collection(organizationCollectionName)
        .doc(targetOrganizationId)
        .collection(todoCollectionName)
        .doc(taskGroupDocName)
        .set({
      listName: ['']
    });
  }

  @override
  Future<void> deleteTaskGroup(
      String listName, String targetOrganizationId) async {
    print('deleteList');
    if (targetOrganizationId.isEmpty) {
      await _store
          .collection(usersCollectionName)
          .doc(userId)
          .collection(todoCollectionName)
          .doc(taskGroupDocName)
          .update({listName: FieldValue.delete()});
      return;
    }
    await _store
        .collection(usersCollectionName)
        .doc(targetOrganizationId)
        .collection(todoCollectionName)
        .doc(taskGroupDocName)
        .update({listName: FieldValue.delete()});
  }

  @override
  Future<void> addTask(
      Task task, String targetListName, String targetOrganizationId) async {
    print('addTask');
    if (targetOrganizationId.isEmpty) {
      await _store
          .collection(usersCollectionName)
          .doc(userId)
          .collection(todoCollectionName)
          .doc(taskGroupDocName)
          .update({
        targetListName: FieldValue.arrayUnion([task.title])
      });
      return;
    }
    await _store
        .collection(organizationCollectionName)
        .doc(targetOrganizationId)
        .collection(todoCollectionName)
        .doc(taskGroupDocName)
        .update({
      targetListName: FieldValue.arrayUnion([task.title])
    });
  }

  @override
  Future<void> deleteTask(
      Task task, String targetListName, String targetOrganizationId) async {
    print('deleteTask');
    if (targetOrganizationId.isEmpty) {
      // private
      await _store
          .collection(usersCollectionName)
          .doc(userId)
          .collection(todoCollectionName)
          .doc(taskGroupDocName)
          .update({
        targetListName: FieldValue.arrayRemove([task.title])
      });
      return;
    }
    await _store
        .collection(organizationCollectionName)
        .doc(targetOrganizationId)
        .collection(todoCollectionName)
        .doc(taskGroupDocName)
        .update({
      targetListName: FieldValue.arrayRemove([task.title])
    });
  }

  // --------------------------- settings --------------------------------------
  @override
  Future<void> setUserTheme() async {
    print('setUserTheme');
    await dummyDelay();
  }
}

int _i = 0;
final dummyOrganizationInfoList = <OrganizationInfo>[
  OrganizationInfo(
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
  OrganizationInfo(
      id: (_i++).toString(),
      name: 'soccer club',
      introduction: 'hogehog',
      memberNum: 10,
      categoryList: ['club', '運動']),
  OrganizationInfo(
      id: (_i++).toString(),
      name: 'soccer club',
      introduction: 'hogehog',
      memberNum: 10,
      categoryList: ['club', '運動']),
  OrganizationInfo(
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

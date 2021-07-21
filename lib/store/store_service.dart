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
  final public = 'public';
  final private = 'private';

  // --------------------------- club ------------------------------------------
  @override
  Future<List<String>> getParticipatingOrganizationIdList() async {
    // print('getParticipatingOrganizationIdList');
    try {
      final data = await _store
          .collection(usersCollectionName)
          .doc(userId)
          .collection(settingsCollectionName)
          .doc(settingsOrganizationName)
          .get();
      final res = <String>[...data['ids']];
      return res;
    } catch (e) {
      print(e);
    }
    return [];
  }

  @override
  Future<OrganizationInfo> getOrganizationInfo(String id) async {
    // print('getOrganizationInfo');
    try {
      final list =
          await _store.collection(organizationCollectionName).doc(id).get();
      final res = OrganizationInfo(
        id: id,
        name: list['name'],
        memberNum: list['memberNum'],
        introduction: list['introduction'],
        tagList: List<String>.from(list['tagList']),
        // otherInfo: list ?? []
      );
      // print('success getOrganizationInfo');
      // print(res);
      return res;
    } catch (e) {
      print(e);
    }
    // print('failed getOrganizationInfo');
    return null;
  }

  @override
  Future<List<OrganizationInfo>> getOrganizationList() async {
    // print('getOrganizationList');
    final res = <OrganizationInfo>[];
    final data = await _store.collection(organizationCollectionName).get();
    data.docs.forEach((element) {
      try {
        res.add(OrganizationInfo(
          id: element.id,
          memberNum: element['memberNum'],
          tagList: List<String>.from(element['tagList']),
          name: element['name'],
          introduction: element['introduction'],
          // otherInfo: element['otherInfo'],
        ));
      } catch (e) {
        print(e);
      }
    });
    // print(res);
    return res;
  }

  @override
  Future<void> createOrganization(OrganizationInfo newOrganization) async {
    print('create organization ${newOrganization.name}');
    await _store.collection(organizationCollectionName).doc().set({
      'name': newOrganization.name,
      'introduction': newOrganization.introduction,
      'tagList': newOrganization.tagList,
      'otherInfo': newOrganization.otherInfo,
      'memberNum': newOrganization.memberNum
    });
  }

  @override
  Future<void> joinOrganization(OrganizationInfo targetOrganization) async {
    // print('join organization ${targetOrganization.name}');
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
    // print('leaveOrganization');
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
  Future<Map<DateTime, List<Schedule>>> getSchedulesForMonth(
      DateTime targetMonth, bool isAll) async {
    print('getSchedules');
    String _year = targetMonth.year.toString();
    String _month = targetMonth.month.toString();
    if (isAll) {
      // await _store.collection(public).doc(scheduleCollectionName)
    }
    Map<DateTime, List<Schedule>> res = {};
    List<String> targetIdList =
        await dbService.getParticipatingOrganizationIdList();
    targetIdList.forEach((id) async {
      final _data = (await _store
              .collection(organizationCollectionName)
              .doc(id)
              .collection(scheduleCollectionName)
              .doc(private)
              .collection(_year)
              .doc(_month)
              .get())
          .data();
      _data.forEach((key, value) {
        try {
          final _day = int.parse(key);
          final DateTime tmpDate =
              DateTime(targetMonth.year, targetMonth.month, _day);
          final tmpList = <Schedule>[];
          value.forEach((e) {
            tmpList.add(Schedule(
              id: e['id'],
              createdBy: id,
              isPublic: isAll,
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
    });
    return res;
  }

  @override
  Future<List<Schedule>> getSchedulesForDay(DateTime day, bool isAll) async {
    // print('getScheduleOnDay');
    Future.delayed(Duration(seconds: 1));
    return dummyScheduleListOnDay;
  }

  @override
  Future<Schedule> getSchedule(String targetId) async {
    Future.delayed(Duration(seconds: 1));
    return dummyScheduleListOnDay.first;
  }

  @override
  Future<void> addSchedule(
      Schedule newSchedule, String targetOrganizationId) async {
    // print('addSchedule');
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
            'id': newSchedule.id,
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
          'id': newSchedule.id,
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
  Future<void> deleteSchedule(Schedule targetSchedule) async {
    // print('deleteSchedule');
    final key = DateFormat('yyyy-MM-dd').format(targetSchedule.start);
    final _start = DateFormat('yyyy-MM-dd HH:mm').format(targetSchedule.start);
    final _end = DateFormat('yyyy-MM-dd HH:mm').format(targetSchedule.end);
    if (targetSchedule.createdBy == null ||
        targetSchedule.createdBy == userId) {
      await _store
          .collection(usersCollectionName)
          .doc(userId)
          .collection(scheduleCollectionName)
          .doc()
          .set({
        key: FieldValue.arrayRemove([
          {
            'id': targetSchedule.id,
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
        .doc(targetSchedule.createdBy)
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
    // print('getTaskList');
    Map<String, List<Task>> res = {};
    List<String> target;
    if (id.isEmpty) {
      target = [
        usersCollectionName,
        userId,
        todoCollectionName,
        taskGroupDocName
      ];
    } else {
      target = [
        organizationCollectionName,
        id,
        todoCollectionName,
        taskGroupDocName,
      ];
    }
    try {
      final _data = (await _store
              .collection(target[0])
              .doc(target[1])
              .collection(target[2])
              .doc(target[3])
              .get())
          .data();
      if (_data == null) {
        return res;
      }
      _data.forEach((key, value) {
        final _tmp = List<String>.from(value);
        res[key] = _tmp.map((e) => Task(title: e)).toList();
      });
    } catch (e) {
      print(e);
    }
    return res;
  }

  @override
  Future<void> addTaskGroup(
      String listName, String targetOrganizationId) async {
    // print('addTaskGroup');
    if (targetOrganizationId.isEmpty) {
      await _store
          .collection(usersCollectionName)
          .doc(userId)
          .collection(todoCollectionName)
          .doc(taskGroupDocName)
          .update({listName: []});
      return;
    }
    await _store
        .collection(organizationCollectionName)
        .doc(targetOrganizationId)
        .collection(todoCollectionName)
        .doc(taskGroupDocName)
        .update({listName: []});
  }

  @override
  Future<void> deleteTaskGroup(
      String listName, String targetOrganizationId) async {
    // print('deleteList');
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
        .collection(organizationCollectionName)
        .doc(targetOrganizationId)
        .collection(todoCollectionName)
        .doc(taskGroupDocName)
        .update({listName: FieldValue.delete()});
  }

  @override
  Future<void> addTask(
      Task task, String targetListName, String targetOrganizationId) async {
    // print('addTask');
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
    // print('deleteTask');
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
    // print('setUserTheme');
    await dummyDelay();
  }
}

final dummyScheduleListOnDay = [
  Schedule(
    title: 'title',
    start: DateTime.now(),
    end: DateTime.now(),
    details: 'details',
    place: 'place01',
  ),
  Schedule(
    title: 'title',
    start: DateTime.now(),
    end: DateTime.now(),
    details: 'details',
    place: 'place01',
  ),
  Schedule(
    title: 'title',
    start: DateTime.now(),
    end: DateTime.now(),
    details: 'details',
    place: 'place01',
  ),
  Schedule(
    title: 'title',
    start: DateTime.now(),
    end: DateTime.now(),
    details: 'details',
    place: 'place01',
  ),
];

Map<DateTime, List<Schedule>> getDummySchedules(DateTime day) {
  return {
    day: [
      Schedule(
        title: 'te',
        start: DateTime.now(),
        end: DateTime.now(),
        details: 'details',
        place: 'place01',
      ),
      Schedule(
        title: 'ti',
        start: DateTime.now(),
        end: DateTime.now(),
        details: 'details',
        place: 'place01',
      ),
      Schedule(
        title: 'tit',
        start: DateTime.now(),
        end: DateTime.now(),
        details: 'details',
        place: 'place01',
      ),
    ]
  };
}

final dummySchedules = {
  DateTime.now(): [
    Schedule(
      title: 'title',
      start: DateTime.now(),
      end: DateTime.now(),
      details: 'details',
      place: 'place01',
    ),
    Schedule(
      title: 'title',
      start: DateTime.now(),
      end: DateTime.now(),
      details: 'details',
      place: 'place01',
    ),
    Schedule(
      title: 'title',
      start: DateTime.now(),
      end: DateTime.now(),
      details: 'details',
      place: 'place01',
    ),
    Schedule(
      title: 'title',
      start: DateTime.now(),
      end: DateTime.now(),
      details: 'details',
      place: 'place01',
    ),
  ],
  DateTime.now().add(Duration(days: 7)): [
    Schedule(
      title: 'title',
      start: DateTime.now(),
      end: DateTime.now(),
      details: 'details',
      place: 'place01',
    ),
    Schedule(
      title: 'title',
      start: DateTime.now(),
      end: DateTime.now(),
      details: 'details',
      place: 'place01',
    ),
    Schedule(
      title: 'title',
      start: DateTime.now(),
      end: DateTime.now(),
      details: 'details',
      place: 'place01',
    ),
    Schedule(
      title: 'title',
      start: DateTime.now(),
      end: DateTime.now(),
      details: 'details',
      place: 'place01',
    ),
  ],
  DateTime.now().add(Duration(days: 3)): [
    Schedule(
      title: 'ti',
      start: DateTime.now(),
      end: DateTime.now(),
      details: 'details',
      place: 'place01',
    ),
    Schedule(
      title: 'title',
      start: DateTime.now(),
      end: DateTime.now(),
      details: 'details',
      place: 'place01',
    ),
    Schedule(
      title: 'ti',
      start: DateTime.now(),
      end: DateTime.now(),
      details: 'details',
      place: 'place01',
    ),
    Schedule(
      title: 'title',
      start: DateTime.now(),
      end: DateTime.now(),
      details: 'details',
      place: 'place01',
    ),
  ],
};

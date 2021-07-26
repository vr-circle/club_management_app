import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/shell_pages/schedule/schedule.dart';
import 'package:flutter_application_1/shell_pages/search/organization_info.dart';
import 'package:flutter_application_1/shell_pages/todo/task.dart';
import 'package:flutter_application_1/shell_pages/todo/task_list.dart';
import 'package:flutter_application_1/store/database_service.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

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
  final publicInfo = 'publicInformations';

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
    print('getOrganizationList');
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
  Future<void> requestJoinOrganization(
      OrganizationInfo targetOrganization) async {
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
  // users          /userId         /schedule/pub       /year/month/...
  // organizations  /organizationId /schedule/pub_or_pri/year/month/...

  Map<DateTime, List<Schedule>> convertScheduleMap(
      Map<String, dynamic> data, bool dataIsPublic, DateTime targetMonth) {
    Map<DateTime, List<Schedule>> res = {};
    if (data == null) {
      return res;
    }
    data.forEach((key, value) {
      try {
        final _day = int.parse(key);
        final DateTime _tmpDate =
            DateTime(targetMonth.year, targetMonth.month, _day);
        final _tmpList = <Schedule>[];
        value.forEach((e) {
          _tmpList.add(Schedule(
            id: e['id'],
            title: e['title'],
            start: DateFormat('yyyy-MM-dd HH:mm').parseStrict(e['start']),
            end: DateFormat('yyyy-MM-dd HH:mm').parseStrict(e['end']),
            place: e['place'],
            details: e['details'],
            createdBy: e['createdBy'],
            isPublic: dataIsPublic,
          ));
        });
        res.addAll({_tmpDate: _tmpList});
      } catch (e) {
        print(e);
      }
    });
    return res;
  }

  @override
  Future<Map<DateTime, List<Schedule>>> getSchedulesForMonth(
      DateTime targetMonth, bool isContainPublicSchedule) async {
    print('getSchedulesForMonth');
    final String _year = targetMonth.year.toString();
    final String _month = targetMonth.month.toString();
    final Map<DateTime, List<Schedule>> res = {};
    final List<String> _participatingOrganizationIds =
        await dbService.getParticipatingOrganizationIdList();
    // private perticipating organization
    await Future.forEach(_participatingOrganizationIds, (id) async {
      final _data = (await _store
              .collection(organizationCollectionName)
              .doc(id)
              .collection(scheduleCollectionName)
              .doc(private)
              .collection(_year)
              .doc(_month)
              .get())
          .data();
      res.addAll(convertScheduleMap(_data, false, targetMonth));
    });
    // all public organizations scheudle
    if (isContainPublicSchedule) {
      final List<String> _allOrganizationIdList =
          (await _store.collection(organizationCollectionName).get())
              .docs
              .map((e) => e.id);
      await Future.forEach(_allOrganizationIdList, (organizationId) async {
        final _data = (await _store
                .collection(organizationCollectionName)
                .doc(organizationId)
                .collection(scheduleCollectionName)
                .doc(public)
                .collection(_year)
                .doc(_month)
                .get())
            .data();
        final m = convertScheduleMap(_data, true, targetMonth);
        m.forEach((key, value) {
          if (res.containsKey(key))
            res[key].addAll(value);
          else
            res.addAll({key: value});
        });
      });
    } else {
      await Future.forEach(_participatingOrganizationIds, (id) async {
        final _data = (await _store
                .collection(organizationCollectionName)
                .doc(id)
                .collection(scheduleCollectionName)
                .doc(public)
                .collection(_year)
                .doc(_month)
                .get())
            .data();
        final m = convertScheduleMap(_data, true, targetMonth);
        m.forEach((key, value) {
          if (res.containsKey(key))
            res[key].addAll(value);
          else
            res.addAll({key: value});
        });
      });
    }
    // personal schedule
    final _personalData = (await _store
            .collection(usersCollectionName)
            .doc(userId)
            .collection(scheduleCollectionName)
            .doc(private)
            .collection(_year)
            .doc(_month)
            .get())
        .data();
    final m = convertScheduleMap(_personalData, false, targetMonth);
    m.forEach((key, value) {
      if (res.containsKey(key))
        res[key].addAll(value);
      else
        res.addAll({key: value});
    });
    return res;
  }

  @override
  Future<List<Schedule>> getSchedulesForDay(DateTime day, bool isAll) async {
    final _data = LinkedHashMap<DateTime, List<Schedule>>(
        equals: isSameDay,
        hashCode: (DateTime key) {
          return key.day * 1000000 + key.month * 10000 + key.year;
        })
      ..addAll(await getSchedulesForMonth(day, isAll));
    return _data[day] ?? [];
  }

  @override
  Future<Schedule> getSchedule(
      String targetScheduleId, DateTime targetDay) async {
    final _data = await getSchedulesForDay(targetDay, false);
    final res = _data.where((element) => element.id == targetScheduleId);
    return res.first ?? null;
  }

  Future<void> setNewSchedule(
      DocumentReference target, Schedule newSchedule) async {
    final key = DateFormat('dd').format(newSchedule.start);
    final start = DateFormat('yyyy-MM-dd HH:mm').format(newSchedule.start);
    final end = DateFormat('yyyy-MM-dd HH:mm').format(newSchedule.end);
    await target.set({
      key: FieldValue.arrayUnion([
        {
          'id': newSchedule.id,
          'title': newSchedule.title,
          'start': start,
          'end': end,
          'place': newSchedule.place,
          'details': newSchedule.details,
          'createdBy': newSchedule.createdBy
        }
      ])
    }, SetOptions(merge: true));
  }

  Future<void> removeSchedule(
      DocumentReference target, Schedule targetSchedule) async {
    final key = DateFormat('dd').format(targetSchedule.start);
    final start = DateFormat('yyyy-MM-dd HH:mm').format(targetSchedule.start);
    final end = DateFormat('yyyy-MM-dd HH:mm').format(targetSchedule.end);
    await target.set({
      key: FieldValue.arrayRemove([
        {
          'id': targetSchedule.id,
          'title': targetSchedule.title,
          'start': start,
          'end': end,
          'place': targetSchedule.place,
          'details': targetSchedule.details,
          'createdBy': targetSchedule.createdBy
        }
      ])
    });
  }

  @override
  Future<void> addSchedule(Schedule newSchedule, bool isPersonal) async {
    if (isPersonal) {
      addPersonalSchedule(newSchedule);
    } else {
      addOrganizationSchedule(newSchedule);
    }
  }

  Future<void> addPersonalSchedule(Schedule newSchedule) async {
    final target = _store
        .collection(usersCollectionName)
        .doc(userId)
        .collection(scheduleCollectionName)
        .doc(private)
        .collection(newSchedule.start.year.toString())
        .doc(newSchedule.start.month.toString());
    newSchedule.createdBy = this.userId;
    await setNewSchedule(target, newSchedule);
  }

  Future<void> addOrganizationSchedule(Schedule newSchedule) async {
    DocumentReference target;
    target = _store
        .collection(organizationCollectionName)
        .doc(newSchedule.createdBy)
        .collection(scheduleCollectionName)
        .doc(newSchedule.isPublic ? public : private)
        .collection(newSchedule.start.year.toString())
        .doc(newSchedule.start.month.toString());
    await setNewSchedule(target, newSchedule);
  }

  @override
  Future<void> deleteSchedule(Schedule targetSchedule, bool isPersonal) async {
    if (isPersonal) {
      deletePersonalSchedule(targetSchedule);
    } else {
      deleteOrganizationSchedule(targetSchedule);
    }
  }

  Future<void> deletePersonalSchedule(Schedule targetSchedule) async {
    final target = _store
        .collection(usersCollectionName)
        .doc(userId)
        .collection(scheduleCollectionName)
        .doc(private)
        .collection(targetSchedule.start.year.toString())
        .doc(targetSchedule.start.month.toString());
    await removeSchedule(target, targetSchedule);
  }

  Future<void> deleteOrganizationSchedule(Schedule targetSchedule) async {
    if (targetSchedule.isPublic) {
      final target = _store
          .collection(publicInfo)
          .doc(scheduleCollectionName)
          .collection(targetSchedule.start.year.toString())
          .doc(targetSchedule.start.month.toString());
      await removeSchedule(target, targetSchedule);
    }
    final target = _store
        .collection(organizationCollectionName)
        .doc(targetSchedule.createdBy)
        .collection(scheduleCollectionName)
        .doc(private)
        .collection(targetSchedule.start.year.toString())
        .doc(targetSchedule.start.month.toString());
    await removeSchedule(target, targetSchedule);
  }

  // --------------------------- todo ------------------------------------------
  @override
  Future<Map<String, TaskList>> getTaskList(String id) async {
    print('getTaskList');
    Map<String, TaskList> res = {};
    final target = _store
        .collection(
            id.isEmpty ? usersCollectionName : organizationCollectionName)
        .doc(id.isEmpty ? userId : id)
        .collection(todoCollectionName)
        .doc(taskGroupDocName);
    try {
      final _data = (await target.get()).data();
      if (_data == null) {
        return res;
      }
      _data.forEach((key, value) {
        final _tmp = List<String>.from(value);
        res[key] = TaskList(_tmp.map((e) => Task(title: e)).toList());
      });
    } catch (e) {
      print(e);
    }
    return res;
  }

  @override
  Future<void> addTaskGroup(
      String listName, String targetOrganizationId) async {
    print('addTaskGroup');
    bool isPersonal =
        targetOrganizationId == null || targetOrganizationId.isEmpty;
    await _store
        .collection(
            isPersonal ? usersCollectionName : organizationCollectionName)
        .doc(isPersonal ? userId : targetOrganizationId)
        .collection(todoCollectionName)
        .doc(taskGroupDocName)
        .update({listName: []});
  }

  @override
  Future<void> deleteTaskGroup(
      String listName, String targetOrganizationId) async {
    print('deleteList');
    bool isPersonal =
        targetOrganizationId == null || targetOrganizationId.isEmpty;
    await _store
        .collection(
            isPersonal ? usersCollectionName : organizationCollectionName)
        .doc(isPersonal ? userId : targetOrganizationId)
        .collection(todoCollectionName)
        .doc(taskGroupDocName)
        .update({listName: FieldValue.delete()});
  }

  @override
  Future<void> addTask(
      Task task, String targetListName, String targetOrganizationId) async {
    print('addTask');
    bool isPersonal =
        targetOrganizationId == null || targetOrganizationId.isEmpty;
    await _store
        .collection(
            isPersonal ? usersCollectionName : organizationCollectionName)
        .doc(isPersonal ? userId : targetOrganizationId)
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
    bool isPersonal =
        targetOrganizationId == null || targetOrganizationId.isEmpty;
    // private
    await _store
        .collection(
            isPersonal ? usersCollectionName : organizationCollectionName)
        .doc(isPersonal ? userId : targetOrganizationId)
        .collection(todoCollectionName)
        .doc(taskGroupDocName)
        .update({
      targetListName: FieldValue.arrayRemove([task.title])
    });
  }

  // --------------------------- settings --------------------------------------
  @override
  Future<bool> getUserGeneralTheme() async {
    try {
      return ((await _store.collection(usersCollectionName).doc(userId).get())
              .data())['theme'] ==
          'dark';
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> setUserGeneralTheme(bool isDark) async {
    print('setUserTheme');
    await _store
        .collection(usersCollectionName)
        .doc(userId)
        .set({'theme': isDark ? 'dark' : 'light'});
  }
}

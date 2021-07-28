import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/shell_pages/schedule/schedule.dart';
import 'package:flutter_application_1/shell_pages/search/organization_info.dart';
import 'package:flutter_application_1/shell_pages/todo/task.dart';
import 'package:flutter_application_1/shell_pages/todo/task_list.dart';
import 'package:flutter_application_1/store/database_service.dart';
import 'package:flutter_application_1/user_settings/user_settings.dart';
import 'package:flutter_application_1/user_settings/user_theme.dart';
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

  @override
  Future<UserSettings> initializeUserSettings() async {
    final x =
        (await _store.collection(usersCollectionName).doc(userId).get()).data();
    print(x);
    UserThemeSettings userThemeSettings = UserThemeSettings();
    try {
      userThemeSettings.generalTheme = x['theme']['general'] == 'dark'
          ? ThemeData.dark()
          : ThemeData.light();
      userThemeSettings.personalEventColor =
          Color(x['theme']['event']['personal']);
      userThemeSettings.organizationEventColor =
          Color(x['theme']['event']['organization']);
    } catch (e) {
      print(e);
    }
    UserSettings res = UserSettings(
        id: userId, name: x['name'], userThemeSettings: userThemeSettings);
    print(res);
    return res;
  }

  // --------------------------- club ------------------------------------------
  @override
  Future<List<String>> getParticipatingOrganizationIdList() async {
    try {
      final data =
          (await _store.collection(usersCollectionName).doc(userId).get())
              .data();
      final res = List<String>.from(data['organizations']);
      print(res);
      return res;
    } catch (e) {
      print(e);
    }
    return [];
  }

  List<UserInfo> convertToUserInfoListFromMapList(List<Map> data) {
    final res = [];
    data.forEach((element) {
      res.add(UserInfo(
          id: element['id'],
          name: element['name'],
          userAuthorities: convertToUserAuthorities(element['authority'])));
    });
    return res;
  }

  @override
  Future<OrganizationInfo> getOrganizationInfo(String id) async {
    try {
      final mapData =
          (await _store.collection(organizationCollectionName).doc(id).get())
              .data();
      final res = OrganizationInfo(
          id: id,
          name: mapData['name'],
          introduction: mapData['introduction'],
          tagList: List<String>.from(mapData['tagList']),
          members: convertToUserInfoListFromMapList(mapData['members']));
      print(res);
      return res;
    } catch (e) {
      print(e);
    }
    print('error in get organization info');
    return null;
  }

  @override
  Future<List<OrganizationInfo>> getOrganizationList() async {
    final res = <OrganizationInfo>[];
    final data = await _store.collection(organizationCollectionName).get();
    data.docs.forEach((element) {
      try {
        res.add(OrganizationInfo(
            id: element.id,
            tagList: List<String>.from(element['tagList']),
            name: element['name'],
            introduction: element['introduction'],
            members: convertToUserInfoListFromMapList(element['members'])));
      } catch (e) {
        print(e);
      }
    });
    return res;
  }

  @override
  Future<void> createOrganization(OrganizationInfo newOrganization) async {
    final List<Map<String, String>> members = newOrganization.members
        .map((e) => {
              'id': e.id,
              'name': e.name,
              'authority': e.userAuthorities.toString().split('.')[1]
            })
        .toList();
    final docRef = await _store.collection(organizationCollectionName).add({
      'name': newOrganization.name,
      'introduction': newOrganization.introduction,
      'tagList': newOrganization.tagList,
      'members': members
    });
    await _store
        .collection(usersCollectionName)
        .doc(userId)
        .collection(settingsCollectionName)
        .doc(settingsOrganizationName)
        .set({
      'ids': FieldValue.arrayUnion([docRef.id])
    }, SetOptions(merge: true));
    await _store
        .collection(organizationCollectionName)
        .doc(docRef.id)
        .set({'id': userId}, SetOptions(merge: true));
  }

  @override
  Future<void> joinOrganization(String targetOrganizationId) async {
    await _store
        .collection(usersCollectionName)
        .doc(userId)
        .collection(settingsCollectionName)
        .doc(settingsOrganizationName)
        .set({
      'ids': FieldValue.arrayUnion([targetOrganizationId])
    }, SetOptions(merge: true));
    await _store
        .collection(organizationCollectionName)
        .doc(targetOrganizationId)
        .update({'memberNum': FieldValue.increment(1)});
    await _store
        .collection(organizationCollectionName)
        .doc(targetOrganizationId)
        .set({'id': userId}, SetOptions(merge: true));
  }

  @override
  Future<void> leaveOrganization(
      OrganizationInfo targetOrganizationInfo) async {
    await _store
        .collection(usersCollectionName)
        .doc(userId)
        .collection(settingsCollectionName)
        .doc(settingsOrganizationName)
        .update({
      'ids': FieldValue.arrayRemove([targetOrganizationInfo.id])
    });
    final targetUserInfo = targetOrganizationInfo.members
        .where((element) => element.id == userId)
        .first;
    await _store
        .collection(organizationCollectionName)
        .doc(targetOrganizationInfo.id)
        .update({
      'member': FieldValue.arrayRemove([
        {
          'id': userId,
          'name': targetUserInfo.name,
          'authority': targetUserInfo.userAuthorities.toString().split('.')[1]
        }
      ])
    });
  }

  @override
  Future<void> giveAuthority(
      String targetOrganizationId, String targetUserId) async {}

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
    try {
      await target.update({
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
    } catch (e) {
      print(e);
    }
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
    final target = _store
        .collection(organizationCollectionName)
        .doc(targetSchedule.createdBy)
        .collection(scheduleCollectionName)
        .doc(targetSchedule.isPublic ? public : private)
        .collection(targetSchedule.start.year.toString())
        .doc(targetSchedule.start.month.toString());
    await removeSchedule(target, targetSchedule);
  }

  // --------------------------- todo ------------------------------------------
  @override
  Future<Map<String, TaskList>> getTaskList(String id) async {
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
    bool isPersonal =
        targetOrganizationId == null || targetOrganizationId.isEmpty;
    await _store
        .collection(
            isPersonal ? usersCollectionName : organizationCollectionName)
        .doc(isPersonal ? userId : targetOrganizationId)
        .collection(todoCollectionName)
        .doc(taskGroupDocName)
        .set({listName: []}, SetOptions(merge: true));
  }

  @override
  Future<void> deleteTaskGroup(
      String listName, String targetOrganizationId) async {
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
}

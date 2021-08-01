import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/shell_pages/schedule/schedule.dart';
import 'package:flutter_application_1/shell_pages/search/organization_info.dart';
import 'package:flutter_application_1/shell_pages/todo/task.dart';
import 'package:flutter_application_1/shell_pages/todo/task_group.dart';
import 'package:flutter_application_1/store/database_service.dart';
import 'package:flutter_application_1/user_settings/user_info.dart';
import 'package:flutter_application_1/user_settings/user_settings.dart';
import 'package:flutter_application_1/user_settings/user_theme.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

DatabaseService dbService;

class FireStoreService extends DatabaseService {
  FireStoreService({this.user}) {
    userId = user.uid;
  }
  final User user;
  String userId;
  final _store = FirebaseFirestore.instance;
  final organizationCollectionName = 'organizations';
  final usersCollectionName = 'users';
  final todoCollectionName = 'todo';
  final scheduleCollectionName = 'schedule';
  final settingsCollectionName = 'settings';
  final settingsOrganizationName = 'organizations';
  final public = 'public';
  final private = 'private';

  @override
  Future<UserSettings> initializeUserSettings() async {
    final x =
        (await _store.collection(usersCollectionName).doc(userId).get()).data();
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
        id: userId,
        name: x['name'],
        userThemeSettings: userThemeSettings,
        participatingOrganizationIdList: List<String>.from(x['organizations']));
    return res;
  }

  @override
  Future<void> updateUserTheme(UserThemeSettings userTheme) async {
    await _store.collection(usersCollectionName).doc(userId).update({
      'theme': {
        'event': {
          'organization': userTheme.organizationEventColor.value,
          'personal': userTheme.personalEventColor.value
        },
        'general': userTheme.generalTheme == ThemeData.dark() ? 'dark' : 'light'
      }
    });
  }

  // --------------------------- club ------------------------------------------
  @override
  Future<List<String>> getParticipatingOrganizationIdList() async {
    try {
      final data =
          (await _store.collection(usersCollectionName).doc(userId).get())
              .data();
      final res = List<String>.from(data['organizations']);
      return res;
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<List<MemberInfo>> getMemberDetails(String targetOrganizationId) async {
    final data = (await _store
            .collection(organizationCollectionName)
            .doc(targetOrganizationId)
            .collection('members')
            .get())
        .docs;
    List<MemberInfo> res = [];
    data.forEach((element) {
      res.add(MemberInfo(
          id: element.id,
          name: element.data()['name'],
          userAuthorities: UserAuthUtils.fromString(element.data()['auth'])));
    });
    return res;
  }

  @override
  Future<OrganizationInfo> getOrganizationInfo(
      String id, bool isContainMemberDetail) async {
    try {
      final mapData =
          (await _store.collection(organizationCollectionName).doc(id).get())
              .data();
      if (isContainMemberDetail) {
        final res = OrganizationInfo(
            id: id,
            name: mapData['name'],
            introduction: mapData['introduction'],
            tagList: List<String>.from(mapData['tagList']),
            memberNum: mapData['memberNum'],
            members: await getMemberDetails(id));
        return res;
      }
      final res = OrganizationInfo(
        id: id,
        name: mapData['name'],
        introduction: mapData['introduction'],
        tagList: List<String>.from(mapData['tagList']),
        memberNum: mapData['memberNum'],
      );
      return res;
    } catch (e) {
      print(e);
    }
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
            name: element.data()['name'],
            introduction: element.data()['introduction'],
            tagList: List<String>.from(element.data()['tagList']),
            memberNum: element.data()['memberNum']));
      } catch (e) {
        print(e);
      }
    });
    return res;
  }

  @override
  Future<OrganizationInfo> createOrganization(
      OrganizationInfo newOrganization) async {
    final docRef = await _store.collection(organizationCollectionName).add({
      'name': newOrganization.name,
      'introduction': newOrganization.introduction,
      'tagList': newOrganization.tagList,
      'memberNum': 1
    });
    await _store.collection(usersCollectionName).doc(userId).set({
      'organizations': FieldValue.arrayUnion([docRef.id])
    }, SetOptions(merge: true));
    await _store
        .collection(organizationCollectionName)
        .doc(docRef.id)
        .collection('members')
        .doc(userId)
        .set({'auth': 'admin', 'name': user.displayName});
    await _store.collection(usersCollectionName).doc(userId).set({
      'organizations': FieldValue.arrayUnion([docRef.id])
    }, SetOptions(merge: true));
    newOrganization.id = docRef.id;
    newOrganization.members = [];
    newOrganization.members.add(MemberInfo(
        id: userId,
        name: user.displayName,
        userAuthorities: UserAuthorities.admin));
    return newOrganization;
  }

  @override
  Future<void> deleteOrganization(String targetOrganizationId) async {
    _store
        .collection(organizationCollectionName)
        .doc(targetOrganizationId)
        .delete();
  }

  @override
  Future<void> joinOrganization(String targetOrganizationId) async {
    await _store.collection(usersCollectionName).doc(userId).set({
      'organizations': FieldValue.arrayUnion([targetOrganizationId])
    }, SetOptions(merge: true));
    await _store
        .collection(organizationCollectionName)
        .doc(targetOrganizationId)
        .update({'memberNum': FieldValue.increment(1)});
    await _store
        .collection(organizationCollectionName)
        .doc(targetOrganizationId)
        .collection('members')
        .doc(userId)
        .set({'auth': 'readonly', 'name': user.displayName});
  }

  @override
  Future<void> leaveOrganization(
      OrganizationInfo targetOrganizationInfo) async {
    await _store.collection(usersCollectionName).doc(userId).update({
      'organizations': FieldValue.arrayRemove([targetOrganizationInfo.id])
    });
    // This is not work. increment(-1) makes memberNum(1) change to memberNum(-1)
    // await _store
    //     .collection(organizationCollectionName)
    //     .doc(targetOrganizationInfo.id)
    //     .update({'memberNum': FieldValue.increment(-1)},SetOptions(merge: true));
    await _store
        .collection(organizationCollectionName)
        .doc(targetOrganizationInfo.id)
        .update({'memberNum': targetOrganizationInfo.memberNum - 1});
    await _store
        .collection(organizationCollectionName)
        .doc(targetOrganizationInfo.id)
        .collection('members')
        .doc(userId)
        .delete();
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
      DateTime targetMonth,
      bool isContainPublicSchedule,
      List<String> participatingOrganizationIdList) async {
    final String _year = targetMonth.year.toString();
    final String _month = targetMonth.month.toString();
    final Map<DateTime, List<Schedule>> res = {};
    // private perticipating organization
    await Future.forEach(participatingOrganizationIdList, (id) async {
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
      await Future.forEach(participatingOrganizationIdList, (id) async {
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
  Future<List<Schedule>> getSchedulesForDay(
      DateTime targetDay,
      bool isContainPublicSchedule,
      List<String> participatingOrganizationIdList) async {
    final _data = LinkedHashMap<DateTime, List<Schedule>>(
        equals: isSameDay,
        hashCode: (DateTime key) {
          return key.day * 1000000 + key.month * 10000 + key.year;
        })
      ..addAll(await getSchedulesForMonth(
          targetDay, isContainPublicSchedule, participatingOrganizationIdList));
    return _data[targetDay] ?? [];
  }

  @override
  Future<Schedule> getSchedule(String targetScheduleId, DateTime targetDay,
      List<String> participatingOrganizationIdList) async {
    final _data = await getSchedulesForDay(
        targetDay, false, participatingOrganizationIdList);
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
  Future<List<TaskGroup>> loadTaskList([String organizationId]) async {
    bool isPersonal = organizationId == null;
    List<TaskGroup> taskGroup = [];
    final data = await _store
        .collection(
            isPersonal ? usersCollectionName : organizationCollectionName)
        .doc(isPersonal ? userId : organizationId)
        .collection(todoCollectionName)
        .get();
    try {
      data.docs.forEach((element) {
        taskGroup.add(TaskGroup(
            id: element.id,
            name: element.data()['name'],
            taskList: List<Task>.from(element
                .data()['tasks']
                .map((e) => Task(id: e['id'], title: e['title']))
                .toList())));
      });
    } catch (e) {
      print(e);
    }
    return taskGroup;
  }

  @override
  Future<TaskGroup> addTaskGroup(String newGroupName,
      [String targetOrganizationId]) async {
    bool isPersonal = targetOrganizationId == null;
    final docRef = await _store
        .collection(
            isPersonal ? usersCollectionName : organizationCollectionName)
        .doc(isPersonal ? userId : targetOrganizationId)
        .collection(todoCollectionName)
        .add({'name': newGroupName, 'tasks': []});
    return TaskGroup(id: docRef.id, name: newGroupName);
  }

  @override
  Future<void> deleteTaskGroup(String targetGroupId,
      [String targetOrganizationId]) async {
    bool isPersonal = targetOrganizationId == null;
    await _store
        .collection(
            isPersonal ? usersCollectionName : organizationCollectionName)
        .doc(isPersonal ? userId : targetOrganizationId)
        .collection(todoCollectionName)
        .doc(targetGroupId)
        .delete();
  }

  @override
  Future<void> addTask(Task task, String targetGroupId,
      [String targetOrganizationId]) async {
    bool isPersonal = targetOrganizationId == null;
    await _store
        .collection(
            isPersonal ? usersCollectionName : organizationCollectionName)
        .doc(isPersonal ? userId : targetOrganizationId)
        .collection(todoCollectionName)
        .doc(targetGroupId)
        .update({
      'tasks': FieldValue.arrayUnion([
        {'id': task.id, 'title': task.title},
      ])
    });
  }

  @override
  Future<void> deleteTask(Task task, String targetGroupId,
      [String targetOrganizationId]) async {
    bool isPersonal = targetOrganizationId == null;
    await _store
        .collection(
            isPersonal ? usersCollectionName : organizationCollectionName)
        .doc(isPersonal ? userId : targetOrganizationId)
        .collection(todoCollectionName)
        .doc(targetGroupId)
        .update({
      'tasks': FieldValue.arrayRemove([
        {'id': task.id, 'title': task.title},
      ])
    });
  }
}

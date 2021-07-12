import 'package:flutter_application_1/shell_pages/schedule/schedule.dart';
import 'package:flutter_application_1/shell_pages/search/organization_info.dart';
import 'package:flutter_application_1/shell_pages/todo/task.dart';

abstract class DatabaseService {
  // club
  Future<List<OrganizationInfo>> getOrganizationList();
  Future<List<String>> getParticipatingOrganizationIdList();
  Future<OrganizationInfo> getOrganizationInfo(String id);
  Future<void> createOrganization(OrganizationInfo newOrganization);
  Future<void> joinOrganization(OrganizationInfo targetOrganization);
  Future<void> leaveOrganization(OrganizationInfo targetOrganization);

  // schedule
  Future<Map<DateTime, List<Schedule>>> getSchedules(String targetId);
  Future<List<Schedule>> getSchedulesOnDay(
      DateTime day, List<String> targetIdList);
  Future<void> addSchedule(Schedule newSchedule, String targetId);
  Future<void> deleteSchedule(Schedule schedule, String targetId);

  // todo
  Future<Map<String, List<Task>>> getTaskList(String id);
  Future<void> addTaskGroup(String groupName, String targetOrganizationId);
  Future<void> deleteTaskGroup(String groupName, String targetOrganizationId);
  Future<void> addTask(
      Task task, String targetGroupName, String targetOrganizationId);
  Future<void> deleteTask(
      Task task, String targetGroupName, String targetOrganizationId);

  // settings
  Future<void> setUserTheme();
}

Future<void> dummyDelay() async {
  await Future.delayed(Duration(seconds: 1));
}

import 'package:flutter_application_1/shell_pages/schedule/schedule.dart';
import 'package:flutter_application_1/shell_pages/search/organization_info.dart';
import 'package:flutter_application_1/shell_pages/todo/task.dart';
import 'package:flutter_application_1/shell_pages/todo/task_list.dart';

abstract class DatabaseService {
  // club
  Future<List<OrganizationInfo>> getOrganizationList();
  Future<List<String>> getParticipatingOrganizationIdList();
  Future<OrganizationInfo> getOrganizationInfo(String id);
  Future<void> createOrganization(OrganizationInfo newOrganization);
  Future<void> joinOrganization(String targetOrganizationId);
  Future<void> leaveOrganization(String targetOrganizationId);

  // schedule
  Future<Map<DateTime, List<Schedule>>> getSchedulesForMonth(
      DateTime day, bool isContainPublicSchedule);
  Future<List<Schedule>> getSchedulesForDay(
      DateTime day, bool isContainPublicSchedule);
  Future<Schedule> getSchedule(String targetScheduleId, DateTime targetDay);
  Future<void> addSchedule(Schedule newSchedule, bool isPersonal);
  Future<void> deleteSchedule(Schedule targetSchedule, bool isPersonal);

  // todo
  Future<Map<String, TaskList>> getTaskList(String id);
  Future<void> addTaskGroup(String groupName, String targetOrganizationId);
  Future<void> deleteTaskGroup(String groupName, String targetOrganizationId);
  Future<void> addTask(
      Task task, String targetGroupName, String targetOrganizationId);
  Future<void> deleteTask(
      Task task, String targetGroupName, String targetOrganizationId);

  // settings
  Future<bool> getUserGeneralTheme();
  Future<void> setUserGeneralTheme(bool isDark);
}

import 'package:flutter_application_1/shell_pages/schedule/schedule.dart';
import 'package:flutter_application_1/shell_pages/search/organization_info.dart';
import 'package:flutter_application_1/shell_pages/todo/task.dart';
import 'package:flutter_application_1/shell_pages/todo/task_group.dart';
import 'package:flutter_application_1/user_settings/user_settings.dart';
import 'package:flutter_application_1/user_settings/user_theme.dart';

abstract class DatabaseService {
  // club
  Future<List<OrganizationInfo>> getOrganizationList();
  Future<List<String>> getParticipatingOrganizationIdList();
  Future<OrganizationInfo> getOrganizationInfo(
      String id, bool isContainMemberDetail);
  Future<OrganizationInfo> createOrganization(OrganizationInfo newOrganization);
  Future<void> deleteOrganization(String targetOrganizationId);
  Future<void> joinOrganization(String targetOrganizationId);
  Future<void> leaveOrganization(OrganizationInfo targetOrganizationInfo);
  Future<void> giveAuthority(String targetOrganizationId, String targetUserId);

  // schedule
  Future<Map<DateTime, List<Schedule>>> getSchedulesForMonth(
      DateTime day,
      bool isContainPublicSchedule,
      List<String> participatingOrganizationIdList);
  Future<List<Schedule>> getSchedulesForDay(
      DateTime day,
      bool isContainPublicSchedule,
      List<String> participatingOrganizationIdList);
  Future<Schedule> getSchedule(String targetScheduleId, DateTime targetDay,
      List<String> participatingOrganizationIdList);
  Future<void> addSchedule(Schedule newSchedule, bool isPersonal);
  Future<void> deleteSchedule(Schedule targetSchedule, bool isPersonal);

  // todo
  Future<List<TaskGroup>> loadTaskList([String organizationId]);
  Future<TaskGroup> addTaskGroup(String newGroupName,
      [String targetOrganizationId]);
  Future<void> deleteTaskGroup(String targetGroupId,
      [String targetOrganizationId]);
  Future<void> addTask(Task task, String targetGroupName,
      [String targetOrganizationId]);
  Future<void> deleteTask(Task task, String targetGroupName,
      [String targetOrganizationId]);

  // settings
  Future<UserSettings> initializeUserSettings();
  Future<void> updateUserTheme(UserThemeSettings userTheme);
}

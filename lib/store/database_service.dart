import 'package:flutter_application_1/shell_pages/schedule/schedule.dart';
import 'package:flutter_application_1/shell_pages/search/organization_info.dart';
import 'package:flutter_application_1/shell_pages/todo/task.dart';

abstract class DatabaseService {
  // club
  Future<List<OrganizationInfo>> getOrganizationList();
  Future<List<String>> getParticipatingOrganizationIdList();
  Future<OrganizationInfo> getOrganizationInfo(String id);
  Future<void> createOrganization(OrganizationInfo newOrganization);
  Future<void> requestJoinOrganization(OrganizationInfo targetOrganization);
  Future<void> leaveOrganization(OrganizationInfo targetOrganization);

  // schedule
  Future<Map<DateTime, List<Schedule>>> getSchedulesForMonth(
      DateTime day, bool isContainPublicSchedule);
  Future<List<Schedule>> getSchedulesForDay(
      DateTime day, bool isContainPublicSchedule);
  Future<Schedule> getSchedule(String targetScheduleId, DateTime targetDay);
  Future<void> addPersonalSchedule(Schedule newSchedule);
  Future<void> addOrganizationSchedule(Schedule newSchedule);
  Future<void> deletePersonalSchedule(Schedule targetSchedule);
  Future<void> deleteOrganizationSchedule(Schedule targetSchedule);

  // todo
  Future<Map<String, List<Task>>> getTaskList(String id);
  Future<void> addTaskGroup(String groupName, String targetOrganizationId);
  Future<void> deleteTaskGroup(String groupName, String targetOrganizationId);
  Future<void> addTask(
      Task task, String targetGroupName, String targetOrganizationId);
  Future<void> deleteTask(
      Task task, String targetGroupName, String targetOrganizationId);

  // settings
  Future<void> setUserGeneralTheme(bool isDark);
}

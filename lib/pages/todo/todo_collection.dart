import 'package:flutter_application_1/pages/todo/task.dart';
import 'package:flutter_application_1/store/store_service.dart';

class TodoCollection {
  Map<String, List<Task>> taskMap; // {target id, List<Task>}
  Map<String, String> clubNames; // {target id, target name}
  TodoCollection() {
    taskMap = Map<String, List<Task>>();
  }

  Future<void> getClubNames() async {
    this.taskMap.keys.forEach((element) async {
      clubNames[element] = (await storeService.getClubName(element));
    });
  }

  Future<void> initTasks() async {
    this.taskMap = await storeService.getTaskMap();
    await getClubNames();
  }

  Future<void> addTask(Task newTask, String target) async {
    await storeService.addTask(newTask, target);
    this.taskMap[target] = [...this.taskMap[target], newTask];
  }

  Future<void> deleteTask(Task targetTask, String targetGroupId) async {
    await storeService.deleteTask(targetTask, targetGroupId);
    this.taskMap[targetGroupId] = taskMap[targetGroupId]
        .where((task) => task.id != targetTask.id)
        .toList();
  }

  void toggleDone(Task task, String target) {
    task.toggleDone();
  }
}

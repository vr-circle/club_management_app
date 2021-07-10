import 'package:flutter_application_1/pages/todo/task.dart';
import 'package:flutter_application_1/store/store_service.dart';

class TodoCollection {
  Map<String, List<Task>> taskMap; // {target group id, List<Task>}
  TodoCollection() {
    this.taskMap = Map<String, List<Task>>();
  }

  get length => taskMap.length;

  Future<Map<String, List<Task>>> initTasks(String id) async {
    // get todo list by id
    await Future.delayed(Duration(seconds: 1));
    taskMap = {
      'all0': [
        Task(title: 'hogehoge'),
        Task(title: 'hogehoge'),
        Task(title: 'hogehoge'),
        Task(title: 'hogehoge'),
      ],
      'all1': [
        Task(title: 'hogehoge'),
        Task(title: 'hogehoge'),
        Task(title: 'hogehoge'),
        Task(title: 'hogehoge'),
      ],
      'all2': [
        Task(title: 'hogehoge'),
        Task(title: 'hogehoge'),
        Task(title: 'hogehoge'),
        Task(title: 'hogehoge'),
      ],
      'all3': [
        Task(title: 'hogehoge'),
        Task(title: 'hogehoge'),
        Task(title: 'hogehoge'),
        Task(title: 'hogehoge'),
      ],
      'seconds': [
        Task(title: 'hogehoge'),
        Task(title: 'hogehoge'),
        Task(title: 'hogehoge'),
        Task(title: 'hogehoge'),
      ]
    };
    return taskMap;
  }

  Future<void> addGroup(String title) async {
    if (this.taskMap.containsKey(title)) {
      return;
    }
    await Future.delayed(Duration(seconds: 1));
    this.taskMap[title] = [];
  }

  Future<void> addTask(Task newTask, String targetGroupId) async {
    await storeService.addTask(newTask, targetGroupId);
    this.taskMap[targetGroupId] = [...this.taskMap[targetGroupId], newTask];
  }

  Future<void> deleteTask(Task targetTask, String targetGroupId) async {
    await storeService.deleteTask(targetTask, targetGroupId);
    this.taskMap[targetGroupId] = taskMap[targetGroupId]
        .where((task) => task.id != targetTask.id)
        .toList();
  }

  Future<void> toggleDone(Task task, String target) async {
    task.toggleDone();
  }
}

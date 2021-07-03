import 'package:flutter_application_1/pages/todo/task.dart';

class TaskList {
  TaskList(List<Task> initialTask) {
    this.taskList = initialTask;
  }
  List<Task> taskList;

  void addTask(Task newTask) {
    taskList = [...taskList, newTask];
  }

  void addTaskList(List<Task> taskList) {
    taskList.forEach((element) {
      addTask(element);
    });
  }

  void deleteTask(Task target) {
    taskList = taskList.where((task) => task.id != target.id).toList();
  }

  void toggleDone(String id) {
    taskList = [
      for (final task in taskList)
        if (task.id == id)
          Task(id: task.id, title: task.title, isDone: !task.isDone)
        else
          task
    ];
  }
}

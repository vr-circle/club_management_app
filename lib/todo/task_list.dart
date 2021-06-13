import 'package:flutter_application_1/todo/task.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final taskListProvider =
    StateNotifierProvider<TaskList, List<Task>>((refs) => TaskList());
final clubTaskListProvider =
    StateNotifierProvider<TaskList, List<Task>>((refs) => TaskList());

class TaskList extends StateNotifier<List<Task>> {
  TaskList([List<Task> initialTask]) : super(initialTask ?? []);

  void addTask(String title) {
    state = [...state, Task(title: title)];
  }

  void toggleDone(String id) {
    // todo: O(N) -> O(1)
    state = [
      for (final task in state)
        if (task.id == id)
          Task(id: task.id, title: task.title, isDone: !task.isDone)
        else
          task
    ];
  }

  void deleteTask(Task target) {
    state = state.where((task) => task.id != target.id).toList();
    print("delete!");
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/todo/todo_collection.dart';

// import 'task_list.dart';
// import 'task_list_panel.dart';
// import 'task.dart';
// import 'task_tile.dart';

// class TodoTabPage extends StatefulWidget {
//   TodoTabPage({
//     Key key,
//     @required this.groupId,
//     @required this.groupName,
//     @required this.todoCollection,
//     @required this.taskList,
//   }) : super(key: key);
//   final String groupId;
//   final String groupName;
//   final TodoCollection todoCollection;
//   final List<Task> taskList;
//   @override
//   _TodoPageState createState() => _TodoPageState();
// }

// class _TodoPageState extends State<TodoTabPage> {
//   void _showDialog(Task task) {
//     showDialog(
//         context: context,
//         builder: (context) {
//           return SimpleDialog(
//             title: Text(task.title),
//             children: [
//               SimpleDialogOption(
//                 child: Text('Delete'),
//                 onPressed: () async {
//                   await widget.todoCollection.deleteTask();
//                   // Navigator.pop(context);
//                 },
//               ),
//               SimpleDialogOption(
//                   child: Text('Cancel'),
//                   onPressed: () {
//                     // Navigator.pop(context);
//                   })
//             ],
//           );
//         });
//   }

//   ExpansionTile _createExpansionTile(TaskListPanel taskListItem) {
//     return ExpansionTile(
//         initiallyExpanded: true,
//         leading: Icon(Icons.task),
//         title: Text(taskListItem.name),
//         children: taskListItem.taskList.taskList.length == 0
//             ? [
//                 ListTile(
//                   title: Text('There are no tasks'),
//                 )
//               ]
//             : taskListItem.taskList.taskList.map((e) {
//                 return TaskTile(
//                   task: e,
//                   checkboxCallback: (value) {
//                     setState(() {
//                       taskListItem.taskList.toggleDone(e.id);
//                     });
//                   },
//                   longPressCallback: () {
//                     _showDialog(e);
//                   },
//                 );
//               }).toList());
//   }

//   @override
//   Widget build(BuildContext context) {
//     final _isDoneList =
//         TaskList(widget.taskList.where((element) => element.isDone).toList());
//     final _isNotDoneList =
//         TaskList(widget.taskList.where((element) => !element.isDone).toList());
//     return Scaffold(
//       body: SingleChildScrollView(
//           child: Column(
//         children: [
//           _createExpansionTile(TaskListPanel('Incomplete', _isNotDoneList)),
//           _createExpansionTile(TaskListPanel('Completed', _isDoneList)),
//         ],
//       )),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {},
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }

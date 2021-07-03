// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/todo/task.dart';
// import 'package:flutter_application_1/todo/todo_collection.dart';

// import 'todo_tab_page.dart';

// class TodoPage extends StatefulWidget {
//   TodoPage({Key key, @required this.todoCollection}) : super(key: key);
//   final TodoCollection todoCollection;
//   TodoPageState createState() => TodoPageState();
// }

// class TodoPageState extends State<TodoPage> {
//   // TabController _tabController;
//   Future<void> getTodoData() async {
//     await widget.todoCollection.initTasks();
//   }

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: getTodoData(),
//       builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
//         if (snapshot.connectionState != ConnectionState.done) {
//           return Center(child: CircularProgressIndicator());
//         }
//         return DefaultTabController(
//           length: widget.todoCollection.taskMap.length,
//           child: Scaffold(
//             appBar: AppBar(
//               flexibleSpace: Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   TabBar(
//                     tabs: widget.todoCollection.taskMap.keys
//                         .map((e) => Tab(
//                               text: widget.todoCollection.clubNames[e],
//                             ))
//                         .toList(),
//                   )
//                 ],
//               ),
//             ),
//             body: TabBarView(
//               children: widget.todoCollection.taskMap.entries
//                   .map((element) => TodoTabPage(
//                         groupId: element.key,
//                         groupName: widget.todoCollection.clubNames[element.key],
//                         tasks: element.value,
//                       ))
//                   .toList(),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

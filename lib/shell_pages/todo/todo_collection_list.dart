import 'package:flutter_application_1/shell_pages/todo/todo_collection.dart';
import 'package:flutter_application_1/store/store_service.dart';
import 'package:tuple/tuple.dart';

class TodoPageState {
  List<Tuple2> tabIdAndName;
  List<TodoCollection> _todoCollection;
  Future<void> getTabInfo() async {
    // ids = dbService.getParticipatingOrganizationIdList();
  }
}

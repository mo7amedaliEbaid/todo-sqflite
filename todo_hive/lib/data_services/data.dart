
import 'package:hive_flutter/hive_flutter.dart';

class ToDoDataBase {
  List toDoList = [];
  final _todoBox = Hive.box('mybox');
  // load the data from database
  void loadData() {
    toDoList = _todoBox.get("TODOLIST");
  }

  void updateDataBase() {
    _todoBox.put("TODOLIST", toDoList);
  }
}

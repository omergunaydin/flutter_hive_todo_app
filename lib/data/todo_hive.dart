import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/todo_model.dart';

class HiveDb {
  final Box<Todo> box = Hive.box<Todo>('todosBox');

  //Add new Todo
  Future<void> addTodo({required Todo todo}) async {
    await box.put(todo.id, todo).whenComplete(() => debugPrint(todo.id));
  }

  //Select Todo
  Future<Todo?> getTodo({required String id}) async {
    return box.get(id);
  }

  // Update Todo
  Future<void> updateTodo({required Todo todo}) async {
    await todo.save();
  }

  // Delete Todo
  Future<void> deleteTodo({required Todo todo}) async {
    await todo.delete();
  }

  // Delete All Todos
  Future<void> deleteAllTodos() async {
    await box.clear();
  }

  ValueListenable<Box<Todo>> listenToTodo() {
    return box.listenable();
  }
}

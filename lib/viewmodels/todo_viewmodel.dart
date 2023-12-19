import 'package:flutter/material.dart';

import '../models/todo_model.dart';
import '../services/todo_service.dart';

class TodoViewModel extends ChangeNotifier {
  final TodoService _todoService = TodoService();
  List<TodoModel> _todos = [];
  bool _isLoading = false;

  List<TodoModel> get todos => _todos;
  bool get isLoading => _isLoading;

  TodoViewModel() {
    fetchTodos(); // Fetch data when the TodoViewModel is initialized
  }

  Future<void> fetchTodos() async {
    _isLoading = true;
    notifyListeners();

    try {
      _todos = await _todoService.fetchTodos();
    } catch (e) {
      print('Error fetching todos: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTodo(TodoModel todo) async {
    try {
      await _todoService.addTodo(todo);
      await fetchTodos(); // Refresh the list after adding
    } catch (e) {
      print('Error adding todo: $e');
    }
  }

  Future<void> updateTodo(TodoModel todo) async {
    try {
      await _todoService.updateTodo(todo);
      await fetchTodos(); // Refresh the list after updating
    } catch (e) {
      print('Error updating todo: $e');
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      await _todoService.deleteTodo(id);
      await fetchTodos(); // Refresh the list after deleting
    } catch (e) {
      print('Error deleting todo: $e');
    }
  }
}
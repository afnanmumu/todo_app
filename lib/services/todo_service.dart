import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/todo_model.dart';

class TodoService {
  final String baseUrl = 'https://api.nstack.in/v1/todos';

  Future<List<TodoModel>> fetchTodos() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      return result.map((item) => TodoModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }

  Future<void> addTodo(TodoModel todo) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      body: jsonEncode({
        'title': todo.title,
        'description': todo.description,
        'is_completed': false,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add todo');
    }
  }

  Future<void> updateTodo(TodoModel todo) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${todo.id}'),
      body: jsonEncode({
        'title': todo.title,
        'description': todo.description,
        'is_completed': false,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update todo');
    }
  }

  Future<void> deleteTodo(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete todo');
    }
  }
}
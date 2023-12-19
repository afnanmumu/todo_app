// screens/todo_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/screens/add_todo_screen.dart';

import '../models/todo_model.dart';
import '../viewmodels/todo_viewmodel.dart';

class TodoListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List App'),
      ),
      body: Consumer<TodoViewModel>(
        builder: (context, viewModel, child) {
          return _buildBody(context, viewModel);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddPage(context),
        label: Text('Add Todo'),
      ),
    );
  }

  Widget _buildBody(BuildContext context, TodoViewModel viewModel) {
    if (viewModel.isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (viewModel.todos.isEmpty) {
      return Center(child: Text('No Todo item'));
    } else {
      return RefreshIndicator(
        onRefresh: () async {
          await viewModel.fetchTodos();
        },
        child: ListView.builder(
          itemCount: viewModel.todos.length,
          itemBuilder: (context, index) {
            final todo = viewModel.todos[index];
            return ListTile(
              leading: CircleAvatar(child: Text('${index + 1}')),
              title: Text(todo.title),
              subtitle: Text(todo.description),
              trailing: PopupMenuButton(
                onSelected: (value) {
                  if (value == 'edit') {
                    _navigateToEditPage(context, todo);
                  } else if (value == 'delete') {
                    viewModel.deleteTodo(todo.id);
                  }
                },
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      child: Text('Edit'),
                      value: 'edit',
                    ),
                    PopupMenuItem(
                      child: Text('Delete'),
                      value: 'delete',
                    ),
                  ];
                },
              ),
            );
          },
        ),
      );
    }
  }

  Future<void> _navigateToEditPage(BuildContext context, TodoModel todo) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTodoPage(todo: todo)),
    );
  }

  Future<void> _navigateToAddPage(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTodoPage()),
    );
  }
}

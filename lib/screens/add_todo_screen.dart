import 'package:flutter/material.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/viewmodels/todo_viewmodel.dart';
import 'package:provider/provider.dart';

class AddTodoPage extends StatefulWidget {
  final TodoModel? todo;

  const AddTodoPage({Key? key, this.todo}) : super(key: key);

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool get isEdit => widget.todo != null;

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      titleController.text = widget.todo!.title;
      descriptionController.text = widget.todo!.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Todo" : "Add Todo"),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: 'Title'),
          ),
          SizedBox(height: 20),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _handleSubmit(context),
            child: Text(isEdit ? "Update" : "Submit"),
          )
        ],
      ),
    );
  }

  Future<void> _handleSubmit(BuildContext context) async {
    final title = titleController.text;
    final description = descriptionController.text;
    final todo = TodoModel(id: '', title: title, description: description);

    final viewModel = Provider.of<TodoViewModel>(context, listen: false);

    if (isEdit) {
      todo.id = widget.todo!.id;
      await viewModel.updateTodo(todo);
    } else {
      await viewModel.addTodo(todo);
    }

    Navigator.pop(context); // Close the current screen
  }
}